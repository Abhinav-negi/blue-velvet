import 'package:drift/drift.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/data/db.dart';
import 'package:uuid/uuid.dart';

/// "Promote" for a story idea: marks it pre-project (Home lists those and
/// opens the pre-project review). Nothing else changes.
Future<void> promoteIdea(AppDatabase db, VoidItem item) async {
  if (item.type != VoidType.storyIdea || item.promotedProjectId != null) {
    throw StateError('Only an unpromoted story idea can be promoted');
  }
  await (db.update(db.voidItems)..where((v) => v.id.equals(item.id))).write(
    VoidItemsCompanion(
      status: const Value(VoidStatus.preProject),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );
}

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

/// Sends [item] into [projectId] as a PENDING proposal (AI_CONTRACT 4.6) and
/// marks the item used. The AI call comes first, so a failure changes
/// nothing. AI never writes project data: only the proposal engine does, on
/// Approve (D-17). The item stays in the Void and can be sent again.
/// Returns the proposal id.
Future<String> sendToProject(
  AppDatabase db,
  AiClient ai, {
  required VoidItem item,
  required String projectId,
}) async {
  final p = await db.projectsDao.byId(projectId);
  if (p == null) throw StateError('Project not found');
  final draft = await buildProposal(
    ai,
    rawTranscript: item.rawTranscript,
    context: await projectContext(db, p),
    permissions: p.aiPermissions,
  );
  final id = const Uuid().v4();
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.transaction(() async {
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: id,
            projectId: projectId,
            status: ProposalStatus.pending,
            summary: draft.summary,
            rawTranscript: item.rawTranscript,
            summarySpans: [for (final s in draft.spans) s.toJson()],
            changes: draft.changes,
            sourceVoidItemId: Value(item.id),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await markUsed(db, item.id, projectId);
  });
  return id;
}

/// Adds [projectId] to the item's used-in list (once). Never removes anything.
Future<void> markUsed(AppDatabase db, String itemId, String projectId) async {
  final it = await db.voidItemsDao.byId(itemId);
  if (it == null || it.usedInProjectIds.contains(projectId)) return;
  await (db.update(db.voidItems)..where((v) => v.id.equals(itemId))).write(
    VoidItemsCompanion(
      usedInProjectIds: Value([...it.usedInProjectIds, projectId]),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );
}
