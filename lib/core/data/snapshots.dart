import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'db.dart';

/// JSON text columns per table: stored parsed in snapshot data (DATA_MODEL 13.1),
/// re-encoded on restore.
const _jsonCols = {
  'projects': ['type_fields', 'ai_permissions'],
  'beats': ['character_ids', 'blocks', 'say_show'],
  'frames': ['character_ids', 'reference_images'],
  'character_maps': ['nodes', 'edges', 'groups', 'viewport'],
};

/// Creates and restores project snapshots (DATA_MODEL 13). Drawings are never
/// read, copied or deleted: frames keep their `strokes_path` as a plain reference.
class SnapshotService {
  SnapshotService(this.db, {int Function()? clock, String Function()? newId})
      : now = clock ?? (() => DateTime.now().millisecondsSinceEpoch),
        newId = newId ?? (() => const Uuid().v4());

  final AppDatabase db;
  final int Function() now;
  final String Function() newId;

  Future<List<Map<String, dynamic>>> _rows(
      String table, String where, List<Object> args) async {
    final rs = await db
        .customSelect('SELECT * FROM $table WHERE $where ORDER BY rowid',
            variables: [for (final a in args) Variable(a)])
        .get();
    return [
      for (final r in rs)
        {
          for (final e in r.data.entries)
            e.key: (_jsonCols[table]?.contains(e.key) ?? false) &&
                    e.value is String
                ? jsonDecode(e.value as String)
                : e.value
        }
    ];
  }

  /// The project and its owned rows as a snapshot `data` map.
  Future<Map<String, dynamic>> capture(String projectId) async {
    final project = (await _rows('projects', 'id = ?', [projectId])).single;
    final chars = await _rows('project_characters', 'project_id = ?', [projectId]);
    for (final c in chars.where((c) => c['mode'] == 'linked')) {
      final g = c['character_id'] == null
          ? null
          : await (db.select(db.characters)
                ..where((t) => t.id.equals(c['character_id'] as String)))
              .getSingleOrNull();
      c['resolved'] = g == null
          ? null
          : {
              'name': g.name, 'age': g.age, 'role': g.role,
              'appearance': g.appearance, 'background': g.background,
              'traits': g.traits, 'habits': g.habits,
              'wants_needs_fears': g.wantsNeedsFears, 'notes': g.notes,
            };
    }
    final tid = project['template_id'] as String?;
    final tpl = tid == null
        ? null
        : await (db.select(db.templates)..where((t) => t.id.equals(tid)))
            .getSingleOrNull();
    final beats = await _rows('beats', 'project_id = ?', [projectId]);
    final frames = await _rows('frames',
        'beat_id IN (SELECT id FROM beats WHERE project_id = ?)', [projectId]);
    final map = await _rows('character_maps', 'project_id = ?', [projectId]);
    return {
      'format': 1,
      'project': project,
      'template': tpl == null ? null : {'template_id': tpl.id, 'seed_id': tpl.seedId},
      'project_characters': chars,
      'beats': beats,
      'frames': frames,
      'character_map': map.isEmpty ? null : map.single,
    };
  }

  /// Inserts a snapshot of the project's current state. Call inside the
  /// caller's transaction when the snapshot must be atomic with other writes.
  Future<Snapshot> create(String projectId, SnapshotReason reason, String label,
      {String? proposalId, String? restoredFromSnapshotId}) async {
    final row = SnapshotsCompanion.insert(
      id: newId(),
      projectId: projectId,
      reason: reason,
      label: label,
      proposalId: Value(proposalId),
      restoredFromSnapshotId: Value(restoredFromSnapshotId),
      data: await capture(projectId),
      createdAt: now(),
    );
    return db.into(db.snapshots).insertReturning(row);
  }

  Future<bool> _exists(String table, Object? id) async {
    if (id == null) return false;
    final r = await db.customSelect('SELECT 1 FROM $table WHERE id = ?',
        variables: [Variable(id)]).get();
    return r.isNotEmpty;
  }

  Map<String, dynamic> _raw(String table, Map<String, dynamic> m) => {
        for (final e in m.entries)
          if (e.key != 'resolved')
            e.key: (_jsonCols[table]?.contains(e.key) ?? false) && e.value != null
                ? jsonEncode(e.value)
                : e.value
      };

  Future<void> _put<T extends Table, D>(
      TableInfo<T, D> t, Map<String, dynamic> m) async {
    await db.into(t).insert(t.map(m) as Insertable<D>);
  }

  /// Replaces the project's rows with the snapshot's, then records a
  /// `restored` snapshot. IDs are reused. Stroke files are not touched.
  /// References to rows that no longer exist (template, slot, global
  /// character, shot) are set to NULL so the restore cannot fail on a FK.
  Future<Snapshot> restore(String snapshotId) => db.transaction(() async {
        final snap = await (db.select(db.snapshots)
              ..where((t) => t.id.equals(snapshotId)))
            .getSingle();
        final d = snap.data;
        final pid = snap.projectId;
        // Cascades remove frames; the snapshot re-inserts them.
        await (db.delete(db.beats)..where((t) => t.projectId.equals(pid))).go();
        await (db.delete(db.projectCharacters)
              ..where((t) => t.projectId.equals(pid)))
            .go();
        await (db.delete(db.characterMaps)..where((t) => t.projectId.equals(pid)))
            .go();

        final p = _raw('projects', Map.of(d['project'] as Map<String, dynamic>));
        if (!await _exists('templates', p['template_id'])) p['template_id'] = null;
        await db.update(db.projects).replace(db.projects.map(p));

        for (final m in (d['project_characters'] as List).cast<Map<String, dynamic>>()) {
          final r = _raw('project_characters', m);
          if (!await _exists('characters', r['character_id'])) r['character_id'] = null;
          await _put(db.projectCharacters, r);
        }
        for (final m in (d['beats'] as List).cast<Map<String, dynamic>>()) {
          final r = _raw('beats', m);
          if (!await _exists('slots', r['slot_id'])) r['slot_id'] = null;
          await _put(db.beats, r);
        }
        for (final m in (d['frames'] as List).cast<Map<String, dynamic>>()) {
          final r = _raw('frames', m);
          if (!await _exists('shots', r['shot_id'])) r['shot_id'] = null;
          await _put(db.frames, r);
        }
        final cm = d['character_map'] as Map<String, dynamic>?;
        if (cm != null) await _put(db.characterMaps, _raw('character_maps', cm));

        return create(pid, SnapshotReason.restored, 'Restored: ${snap.label}',
            restoredFromSnapshotId: snap.id);
      });
}
