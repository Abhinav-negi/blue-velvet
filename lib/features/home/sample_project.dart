import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Settings key (DATA_MODEL 14): set once the sample was created, so deleting
/// it keeps it deleted.
const sampleCreatedKey = 'sample_project_created';

const _canvas = {'width': 1912, 'height': 800}; // 2.39:1

/// App documents folder; stroke files go under it. Tests override.
final sampleFilesDirProvider = FutureProvider<Directory>(
  (ref) => getApplicationDocumentsDirectory(),
);

/// Runs [loadSampleProject] once when Home first builds. Tests override it.
final sampleInitProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(dbProvider);
  final files = await ref.watch(sampleFilesDirProvider.future);
  await loadSampleProject(
    db,
    files,
    await rootBundle.loadString('assets/seed/sample_project.json'),
  );
});

/// Creates the S5 sample project from [json] (assets/seed/sample_project.json)
/// unless it was created before. Adds rows only; never touches other projects.
/// Returns the project id, or null when skipped.
Future<String?> loadSampleProject(
  AppDatabase db,
  Directory files,
  String json,
) async {
  if (await db.settingsDao.get(sampleCreatedKey) == 'true') return null;
  final hasSample =
      await (db.select(db.projects)
            ..where((t) => t.isSample.equals(true))
            ..limit(1))
          .get();
  final now = DateTime.now().millisecondsSinceEpoch;
  if (hasSample.isNotEmpty) {
    await db.settingsDao.put(sampleCreatedKey, 'true', now);
    return null;
  }

  final doc = jsonDecode(json) as Map<String, dynamic>;
  final ids = <String, String>{};
  String id(String key) => ids.putIfAbsent(key, () => const Uuid().v4());
  final proj = doc['project'] as Map<String, dynamic>;
  final pid = id('project');
  Map<String, dynamic> m(Object? o) => o as Map<String, dynamic>;
  List<Map<String, dynamic>> ml(Object? o) =>
      (o as List? ?? const []).cast<Map<String, dynamic>>();

  // Template is optional: skip it when the seed templates are not loaded.
  final tid = proj['template'] as String;
  final hasTemplate = await (db.select(
    db.templates,
  )..where((t) => t.id.equals(tid))).getSingleOrNull();

  final defaults = await db.settingsDao.get('ai_permission_defaults');
  await db.transaction(() async {
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: pid,
        title: proj['title'] as String,
        type: ProjectType.values.firstWhere(
          (t) => t.name == _camel(proj['type'] as String),
        ),
        summary: proj['summary'] as String,
        templateId: Value(hasTemplate == null ? null : tid),
        aspectRatio: proj['aspect_ratio'] as String,
        typeFields: const {},
        aiPermissions: defaults == null ? const {} : m(jsonDecode(defaults)),
        isSample: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );
    for (final c in ml(doc['characters'])) {
      final cid = id('global-${c['key']}');
      await db.charactersDao.upsert(
        CharactersCompanion.insert(
          id: cid,
          name: c['name'] as String,
          age: Value((c['age'] as String).isEmpty ? null : c['age'] as String),
          role: c['role'] as String,
          appearance: c['appearance'] as String,
          background: c['background'] as String,
          traits: c['traits'] as String,
          habits: c['habits'] as String,
          wantsNeedsFears: c['wants_needs_fears'] as String,
          notes: c['notes'] as String,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.charactersDao.upsertMember(
        ProjectCharactersCompanion.insert(
          id: id('char-${c['key']}'),
          projectId: pid,
          characterId: Value(cid),
          mode: CharacterMode.linked,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    var pos = <String, int>{};
    for (final b in ml(doc['beats'])) {
      final slot = hasTemplate == null ? null : '$tid/${b['slot']}';
      final n = pos[b['slot']] = (pos[b['slot']] ?? -1) + 1;
      final bid = id(b['key'] as String);
      await db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: bid,
          projectId: pid,
          slotId: Value(slot),
          position: n,
          title: b['title'] as String,
          description: b['description'] as String,
          characterIds: [for (final k in b['characters']) id('char-$k')],
          blocks: Value([
            for (final x in ml(b['blocks']))
              {
                'id': id(x['key'] as String),
                'type': x['type'],
                'text': x['text'],
                'scaffold': x['scaffold'] ?? false,
                'ai_suggested': false,
              },
          ]),
          createdAt: now,
          updatedAt: now,
        ),
      );
      for (final (i, f) in ml(b['frames']).indexed) {
        final fid = id(f['key'] as String);
        final rel = 'strokes/$fid.json';
        final file = File(p.join(files.path, rel));
        await file.parent.create(recursive: true);
        await file.writeAsString(jsonEncode(_strokeFile(f['strokes'])));
        await db.beatsDao.upsertFrame(
          FramesCompanion.insert(
            id: fid,
            beatId: bid,
            position: i,
            strokesPath: Value(rel),
            shotSize: Value(f['shot_size'] as String?),
            angle: Value(f['angle'] as String?),
            notes: f['notes'] as String,
            blockId: Value(id(f['block'] as String)),
            characterIds: [for (final k in f['characters']) id('char-$k')],
            referenceImages: const [],
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
    final cm = m(doc['character_map']);
    await db.charactersDao.upsertMap(
      CharacterMapsCompanion.insert(
        id: id('map'),
        projectId: pid,
        nodes: [
          for (final n in ml(cm['nodes']))
            {
              'id': id(n['key'] as String),
              'project_character_id': id('char-${n['character']}'),
              'x': n['x'],
              'y': n['y'],
              'group_id': n['group'] == null ? null : id(n['group'] as String),
            },
        ],
        edges: [
          for (final e in ml(cm['edges']))
            {
              'id': const Uuid().v4(),
              'from_node_id': id(e['from'] as String),
              'to_node_id': id(e['to'] as String),
              'label': e['label'],
            },
        ],
        groups: [
          for (final g in ml(cm['groups']))
            {
              'id': id(g['key'] as String),
              'name': g['name'],
              'color': g['color'],
            },
        ],
        viewport: const {'x': 0.0, 'y': 0.0, 'zoom': 1.0},
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.settingsDao.put(sampleCreatedKey, 'true', now);
  });
  return pid;
}

String _camel(String snake) =>
    snake.replaceAllMapped(RegExp(r'_(\w)'), (m) => m[1]!.toUpperCase());

/// DATA_MODEL 10.2 stroke file from compact `[x, y]` point lists.
Map<String, dynamic> _strokeFile(Object? strokes) => {
  'version': 1,
  'canvas': _canvas,
  'strokes': [
    for (final s in (strokes as List).cast<Map<String, dynamic>>())
      {
        'id': const Uuid().v4(),
        'tool': s['tool'],
        'layer': s['layer'],
        'color': s['color'],
        'width': s['width'],
        'shape': null,
        'points': [
          for (final (i, pt) in (s['points'] as List).indexed)
            {'x': pt[0], 'y': pt[1], 'pressure': 1.0, 't': i * 8},
        ],
      },
  ],
};

/// Deletes the sample project and only what it created: the project cascades
/// its own rows; global characters it made go too unless another project now
/// uses them. The created-flag stays set, so it is not recreated.
Future<void> deleteSampleProject(AppDatabase db, String projectId) =>
    db.transaction(() async {
      final project = await db.projectsDao.byId(projectId);
      if (project == null || !project.isSample) return;
      final linked = await (db.select(
        db.projectCharacters,
      )..where((t) => t.projectId.equals(projectId))).get();
      await db.projectsDao.remove(projectId);
      for (final c in linked.map((c) => c.characterId).nonNulls) {
        final others = await (db.select(
          db.projectCharacters,
        )..where((t) => t.characterId.equals(c))).get();
        if (others.isEmpty) {
          await (db.delete(db.characters)..where((t) => t.id.equals(c))).go();
        }
      }
    });
