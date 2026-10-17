import 'package:drift/drift.dart';
import 'package:lynch/core/data/db.dart';

/// AI_CONTRACT 5 project context (no blocks/say_show text).
Future<Map<String, dynamic>> projectContext(AppDatabase db, Project p) async {
  final tpl = p.templateId == null
      ? null
      : await (db.select(
          db.templates,
        )..where((t) => t.id.equals(p.templateId!))).getSingleOrNull();
  final slots = tpl == null
      ? <Slot>[]
      : await (db.select(db.slots)
              ..where((s) => s.templateId.equals(tpl.id))
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
  final beats =
      await (db.select(db.beats)
            ..where((b) => b.projectId.equals(p.id))
            ..orderBy([(b) => OrderingTerm.asc(b.position)]))
          .get();
  final members = await (db.select(
    db.projectCharacters,
  )..where((m) => m.projectId.equals(p.id))).get();
  final globals = {
    for (final c in await db.select(db.characters).get()) c.id: c,
  };
  final chars = <Map<String, dynamic>>[];
  final names = <String, String>{};
  for (final m in members) {
    final g = m.characterId == null ? null : globals[m.characterId];
    final forked = m.mode == CharacterMode.forked || g == null;
    String f(String? own, String? linked) => (forked ? own : linked) ?? '';
    final name = f(m.name, g?.name);
    names[m.id] = name;
    chars.add({
      'project_character_id': m.id,
      'name': name,
      'age': f(m.age, g?.age),
      'role': f(m.role, g?.role),
      'appearance': f(m.appearance, g?.appearance),
      'background': f(m.background, g?.background),
      'traits': f(m.traits, g?.traits),
      'habits': f(m.habits, g?.habits),
      'wants_needs_fears': f(m.wantsNeedsFears, g?.wantsNeedsFears),
      'notes': f(m.notes, g?.notes),
    });
  }
  return {
    'project': {
      'title': p.title,
      'type': const EnumConverter(ProjectType.values).toSql(p.type),
      'summary': p.summary,
    },
    'template': tpl == null
        ? null
        : {
            'id': tpl.id,
            'name': tpl.name,
            'slots': [
              for (final s in slots)
                {
                  'slot_id': s.id,
                  'seed_id': s.seedId,
                  'position': s.position,
                  'name': s.name,
                  'description': s.description,
                  'runtime_proportion': s.runtimeProportion,
                },
            ],
          },
    'beats': [
      for (final b in beats)
        {
          'id': b.id,
          'slot_id': b.slotId,
          'position': b.position,
          'title': b.title,
          'description': b.description,
          'character_names': [
            for (final id in b.characterIds)
              if (names[id] != null) names[id],
          ],
          'has_script': (b.blocks ?? b.sayShow ?? const []).isNotEmpty,
        },
    ],
    'characters': chars,
  };
}
