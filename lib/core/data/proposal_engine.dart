import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'db.dart';
import 'snapshots.dart';

/// A malformed op or a reference that does not resolve. Thrown inside the
/// approve transaction, so nothing is applied.
class ProposalException implements Exception {
  ProposalException(this.message);
  final String message;
  @override
  String toString() => 'ProposalException: $message';
}

/// Applies change-ops (docs/AI_CONTRACT.md section 3). The only code path that
/// changes project content from a proposal (D-17). Never touches drawings.
class ProposalEngine {
  ProposalEngine(this.db, {int Function()? clock, String Function()? newId})
      : now = clock ?? (() => DateTime.now().millisecondsSinceEpoch),
        newId = newId ?? (() => const Uuid().v4()) {
    snapshots = SnapshotService(db, clock: now, newId: this.newId);
  }

  final AppDatabase db;
  final int Function() now;
  final String Function() newId;
  late final SnapshotService snapshots;

  /// Snapshots the pre-approve state, runs every `accepted` op in order, marks
  /// the proposal approved. One transaction: any failure rolls everything back.
  /// Returns notes for soft failures (unmatched character names).
  Future<List<String>> approve(String proposalId) => db.transaction(() async {
        final p = await (db.select(db.proposals)
              ..where((t) => t.id.equals(proposalId)))
            .getSingle();
        if (p.status != ProposalStatus.pending) {
          throw ProposalException('proposal $proposalId is not pending');
        }
        final snap = await snapshots.create(p.projectId,
            SnapshotReason.proposalApproved, 'Approved: ${p.summary}',
            proposalId: p.id);
        final run = _Run(this, p.projectId);
        for (final o in p.changes.cast<Map<String, dynamic>>()) {
          if (o['accepted'] == false) continue;
          await run.apply(o);
        }
        final t = now();
        await (db.update(db.projects)..where((x) => x.id.equals(p.projectId)))
            .write(ProjectsCompanion(updatedAt: Value(t)));
        await (db.update(db.proposals)..where((x) => x.id.equals(p.id))).write(
            ProposalsCompanion(
                status: const Value(ProposalStatus.approved),
                snapshotId: Value(snap.id),
                resolvedAt: Value(t),
                updatedAt: Value(t)));
        return run.notes;
      });

  /// Restores the pre-approve snapshot of the project's latest approved
  /// proposal and puts that proposal back to pending.
  Future<Snapshot> undoLastApprove(String projectId) => db.transaction(() async {
        final p = await (db.select(db.proposals)
              ..where((t) =>
                  t.projectId.equals(projectId) &
                  t.status.equalsValue(ProposalStatus.approved) &
                  t.snapshotId.isNotNull())
              ..orderBy([(t) => OrderingTerm.desc(t.resolvedAt)])
              ..limit(1))
            .getSingleOrNull();
        if (p == null) throw ProposalException('nothing to undo');
        final s = await snapshots.restore(p.snapshotId!);
        final t = now();
        await (db.update(db.proposals)..where((x) => x.id.equals(p.id))).write(
            ProposalsCompanion(
                status: const Value(ProposalStatus.pending),
                snapshotId: const Value(null),
                resolvedAt: const Value(null),
                updatedAt: Value(t)));
        return s;
      });
}

const _fieldCols = [
  'age', 'role', 'appearance', 'background', 'traits', 'habits',
  'wants_needs_fears', 'notes'
];

class _Run {
  _Run(this.e, this.projectId);
  final ProposalEngine e;
  final String projectId;
  AppDatabase get db => e.db;
  final notes = <String>[];
  final _beatRefs = <String, String>{};
  final _charRefs = <String, String>{};

  Never _bad(String m) => throw ProposalException(m);

  Future<void> apply(Map<String, dynamic> o) async {
    switch (o['op']) {
      case 'addBeat':
        return _addBeat(o);
      case 'editBeat':
        return _editBeat(o);
      case 'splitBeat':
        return _split(o);
      case 'mergeBeats':
        return _merge(o);
      case 'moveBeat':
        return _move(o, requireUnplaced: false);
      case 'placeBeatInSlot':
        return _move(o, requireUnplaced: true);
      case 'addCharacter':
        return _addCharacter(o);
      case 'editCharacter':
        return _editCharacter(o);
      case 'setSummary':
        final text = o['text'] as String? ?? _bad('setSummary needs text');
        await (db.update(db.projects)..where((t) => t.id.equals(projectId)))
            .write(ProjectsCompanion(summary: Value(text)));
        return;
      case 'addScaffold':
        return _scaffold(o);
      default:
        _bad('unknown op ${o['op']}');
    }
  }

  // ---- lookups
  Future<Beat> _beat(Map<String, dynamic> o, [String idKey = 'beat_id']) async {
    final id = (o[idKey] as String?) ??
        _beatRefs[o['beat_ref']] ??
        _bad('${o['op']}: no beat_id/beat_ref');
    final b = await (db.select(db.beats)
          ..where((t) => t.id.equals(id) & t.projectId.equals(projectId)))
        .getSingleOrNull();
    return b ?? _bad('${o['op']}: beat $id not in project');
  }

  /// Slot id from slot_seed_id / slot_id; null when both absent (unplaced).
  Future<String?> _slot(Map<String, dynamic> o) async {
    final seed = o['slot_seed_id'] as String?;
    final id = o['slot_id'] as String?;
    if (seed == null && id == null) return null;
    final s = await (db.select(db.slots)
          ..where((t) => seed != null ? t.seedId.equals(seed) : t.id.equals(id!)))
        .getSingleOrNull();
    return s?.id ?? _bad('${o['op']}: unknown slot ${seed ?? id}');
  }

  /// Case-insensitive name -> project_characters.id (includes earlier addCharacter).
  Future<Map<String, String>> _names() async {
    final pcs = await (db.select(db.projectCharacters)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final globals = {for (final c in await db.select(db.characters).get()) c.id: c.name};
    return {
      for (final pc in pcs.reversed)
        (pc.name ?? globals[pc.characterId] ?? '').toLowerCase(): pc.id
    };
  }

  Future<List<String>> _ids(Object? names) async {
    final m = await _names();
    final out = <String>[];
    for (final n in (names as List?)?.cast<String>() ?? const <String>[]) {
      final id = m[n.toLowerCase()];
      if (id == null) {
        notes.add('Character "$n" not found; left unlinked.');
      } else if (!out.contains(id)) {
        out.add(id);
      }
    }
    return out;
  }

  Future<bool> _isScreenplay() async {
    final p = await (db.select(db.projects)..where((t) => t.id.equals(projectId)))
        .getSingle();
    return p.type == ProjectType.shortFilm || p.type == ProjectType.longFilm;
  }

  /// Rewrites positions 0..n in a slot; optionally puts [put] into the slot at
  /// [at] (null = end) or right [after] another beat.
  Future<void> _arrange(String? slotId,
      {String? put, int? at, String? after}) async {
    final sibs = await (db.select(db.beats)
          ..where((t) =>
              t.projectId.equals(projectId) &
              (slotId == null ? t.slotId.isNull() : t.slotId.equals(slotId)))
          ..orderBy([
            (t) => OrderingTerm.asc(t.position),
            (t) => OrderingTerm.asc(t.createdAt)
          ]))
        .get();
    final ids = [for (final b in sibs) if (b.id != put) b.id];
    if (put != null) {
      final i = after != null ? ids.indexOf(after) + 1 : (at ?? ids.length);
      ids.insert(i.clamp(0, ids.length), put);
    }
    final cur = {for (final b in sibs) b.id: b.position};
    final t = e.now();
    for (var i = 0; i < ids.length; i++) {
      if (ids[i] != put && cur[ids[i]] == i) continue;
      await (db.update(db.beats)..where((x) => x.id.equals(ids[i]))).write(
          BeatsCompanion(
              position: Value(i), slotId: Value(slotId), updatedAt: Value(t)));
    }
  }

  Future<String> _insertBeat(String title, String desc, String? slotId,
      List<String> chars) async {
    final id = e.newId();
    final film = await _isScreenplay();
    final t = e.now();
    await db.into(db.beats).insert(BeatsCompanion.insert(
        id: id,
        projectId: projectId,
        position: 0,
        title: title,
        description: desc,
        characterIds: chars,
        slotId: Value(slotId),
        blocks: Value(film ? [] : null),
        sayShow: Value(film ? null : []),
        createdAt: t,
        updatedAt: t));
    return id;
  }

  // ---- ops
  Future<void> _addBeat(Map<String, dynamic> o) async {
    final slot = await _slot(o);
    final id = await _insertBeat(
        o['title'] as String? ?? _bad('addBeat needs title'),
        o['description'] as String? ?? '',
        slot,
        await _ids(o['character_names']));
    if (o['ref'] != null) _beatRefs[o['ref'] as String] = id;
    await _arrange(slot, put: id, at: o['position'] as int?);
  }

  Future<void> _editBeat(Map<String, dynamic> o) async {
    final b = await _beat(o);
    final add = await _ids(o['character_names_add']);
    final rem = await _ids(o['character_names_remove']);
    final chars = [
      ...b.characterIds.where((c) => !rem.contains(c)),
      ...add.where((c) => !b.characterIds.contains(c))
    ];
    await (db.update(db.beats)..where((t) => t.id.equals(b.id))).write(
        BeatsCompanion(
            title: Value.absentIfNull(o['title'] as String?),
            description: Value.absentIfNull(o['description'] as String?),
            characterIds: Value(chars),
            updatedAt: Value(e.now())));
  }

  Future<void> _split(Map<String, dynamic> o) async {
    final b = await _beat(o);
    final parts = (o['parts'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    if (parts.length < 2) _bad('splitBeat needs 2+ parts');
    await (db.update(db.beats)..where((t) => t.id.equals(b.id))).write(
        BeatsCompanion(
            title: Value(parts[0]['title'] as String),
            description: Value(parts[0]['description'] as String),
            characterIds: Value(await _ids(parts[0]['character_names'])),
            updatedAt: Value(e.now())));
    var prev = b.id;
    for (final part in parts.skip(1)) {
      final id = await _insertBeat(part['title'] as String,
          part['description'] as String, b.slotId, await _ids(part['character_names']));
      await _arrange(b.slotId, put: id, after: prev);
      prev = id;
    }
  }

  Future<void> _merge(Map<String, dynamic> o) async {
    final ids = (o['beat_ids'] as List?)?.cast<String>() ?? const [];
    if (ids.length < 2) _bad('mergeBeats needs 2+ beat_ids');
    final survivor = await _beat({'op': 'mergeBeats', 'beat_id': ids.first});
    var blocks = survivor.blocks;
    var sayShow = survivor.sayShow;
    var fpos = (await (db.select(db.frames)
              ..where((t) => t.beatId.equals(survivor.id))).get())
        .length;
    final slots = <String?>{};
    for (final id in ids.skip(1)) {
      final b = await _beat({'op': 'mergeBeats', 'beat_id': id});
      slots.add(b.slotId);
      if (b.blocks?.isNotEmpty ?? false) blocks = [...?blocks, ...b.blocks!];
      if (b.sayShow?.isNotEmpty ?? false) sayShow = [...?sayShow, ...b.sayShow!];
      final fs = await (db.select(db.frames)
            ..where((t) => t.beatId.equals(b.id))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();
      for (final f in fs) {
        await (db.update(db.frames)..where((t) => t.id.equals(f.id))).write(
            FramesCompanion(beatId: Value(survivor.id), position: Value(fpos++)));
      }
    }
    await (db.update(db.beats)..where((t) => t.id.equals(survivor.id))).write(
        BeatsCompanion(
            title: Value(o['title'] as String),
            description: Value(o['description'] as String),
            characterIds: Value(await _ids(o['character_names'])),
            blocks: Value(blocks),
            sayShow: Value(sayShow),
            updatedAt: Value(e.now())));
    await (db.delete(db.beats)..where((t) => t.id.isIn(ids.skip(1)))).go();
    for (final s in slots) {
      await _arrange(s);
    }
  }

  Future<void> _move(Map<String, dynamic> o, {required bool requireUnplaced}) async {
    final b = await _beat(o);
    final slot = await _slot(o);
    if (requireUnplaced) {
      if (b.slotId != null) _bad('placeBeatInSlot: beat already placed');
      if (slot == null) _bad('placeBeatInSlot needs a slot');
    }
    await _arrange(slot, put: b.id, at: o['position'] as int?);
    if (b.slotId != slot) await _arrange(b.slotId);
  }

  Future<void> _addCharacter(Map<String, dynamic> o) async {
    final name = o['name'] as String? ?? _bad('addCharacter needs name');
    final existing = (await _names())[name.toLowerCase()];
    if (existing != null) {
      if (o['ref'] != null) _charRefs[o['ref'] as String] = existing;
      return;
    }
    final f = (o['fields'] as Map?)?.cast<String, dynamic>() ?? const {};
    final t = e.now();
    final cid = e.newId();
    String s(String k) => f[k] as String? ?? '';
    await db.into(db.characters).insert(CharactersCompanion.insert(
        id: cid,
        name: name,
        age: Value(f['age'] as String?),
        role: s('role'),
        appearance: s('appearance'),
        background: s('background'),
        traits: s('traits'),
        habits: s('habits'),
        wantsNeedsFears: s('wants_needs_fears'),
        notes: s('notes'),
        createdAt: t,
        updatedAt: t));
    final pcid = e.newId();
    await db.into(db.projectCharacters).insert(ProjectCharactersCompanion.insert(
        id: pcid,
        projectId: projectId,
        mode: CharacterMode.linked,
        characterId: Value(cid),
        createdAt: t,
        updatedAt: t));
    if (o['ref'] != null) _charRefs[o['ref'] as String] = pcid;
  }

  Future<void> _editCharacter(Map<String, dynamic> o) async {
    final id = o['project_character_id'] as String? ?? _bad('editCharacter needs project_character_id');
    final pc = await (db.select(db.projectCharacters)
          ..where((t) => t.id.equals(id) & t.projectId.equals(projectId)))
        .getSingleOrNull() ?? _bad('editCharacter: $id not in project');
    final f = (o['fields'] as Map?)?.cast<String, dynamic>() ?? const {};
    final vals = {
      for (final k in _fieldCols)
        if (f[k] != null) k: f[k] as String
    };
    if (vals.isEmpty) return;
    final t = e.now();
    if (pc.mode == CharacterMode.linked) {
      if (pc.characterId == null) _bad('editCharacter: linked character is gone');
      await (db.update(db.characters)..where((x) => x.id.equals(pc.characterId!)))
          .write(CharactersCompanion(
              age: Value.absentIfNull(vals['age']),
              role: Value.absentIfNull(vals['role']),
              appearance: Value.absentIfNull(vals['appearance']),
              background: Value.absentIfNull(vals['background']),
              traits: Value.absentIfNull(vals['traits']),
              habits: Value.absentIfNull(vals['habits']),
              wantsNeedsFears: Value.absentIfNull(vals['wants_needs_fears']),
              notes: Value.absentIfNull(vals['notes']),
              updatedAt: Value(t)));
    } else {
      await (db.update(db.projectCharacters)..where((x) => x.id.equals(pc.id)))
          .write(ProjectCharactersCompanion(
              age: Value.absentIfNull(vals['age']),
              role: Value.absentIfNull(vals['role']),
              appearance: Value.absentIfNull(vals['appearance']),
              background: Value.absentIfNull(vals['background']),
              traits: Value.absentIfNull(vals['traits']),
              habits: Value.absentIfNull(vals['habits']),
              wantsNeedsFears: Value.absentIfNull(vals['wants_needs_fears']),
              notes: Value.absentIfNull(vals['notes']),
              updatedAt: Value(t)));
    }
  }

  Future<void> _scaffold(Map<String, dynamic> o) async {
    final b = await _beat(o);
    final blocks = (o['blocks'] as List?)?.cast<Map<String, dynamic>>();
    final rows = (o['rows'] as List?)?.cast<Map<String, dynamic>>();
    if ((blocks == null) == (rows == null)) _bad('addScaffold needs blocks xor rows');
    final flags = {'scaffold': true, 'ai_suggested': false};
    if (blocks != null) {
      for (final x in blocks) {
        if (x['type'] != 'scene_heading' && x['type'] != 'action') {
          _bad('addScaffold: block type ${x['type']} not allowed (D-18)');
        }
      }
      final add = [
        for (final x in blocks)
          {'id': e.newId(), 'type': x['type'], 'text': x['text'], ...flags}
      ];
      await (db.update(db.beats)..where((t) => t.id.equals(b.id))).write(
          BeatsCompanion(
              blocks: Value([...?b.blocks, ...add]), updatedAt: Value(e.now())));
    } else {
      if (rows!.any((r) => r['say'] != '')) _bad('addScaffold: say must be empty');
      final add = [
        for (final r in rows) {'id': e.newId(), 'say': '', 'show': r['show'], ...flags}
      ];
      await (db.update(db.beats)..where((t) => t.id.equals(b.id))).write(
          BeatsCompanion(
              sayShow: Value([...?b.sayShow, ...add]), updatedAt: Value(e.now())));
    }
  }
}
