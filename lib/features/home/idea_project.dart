import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/data/ai_defaults.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/proposal_engine.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/data/snapshots.dart';
import 'package:uuid/uuid.dart';

/// One row of assets/seed/project_types.json, reduced to what creation needs.
class IdeaType {
  const IdeaType({
    required this.id,
    required this.name,
    required this.type,
    required this.aspectRatio,
    required this.templateIds,
  });

  final String id;
  final String name;
  final ProjectType type;

  /// Display name used by `projects.aspect_ratio`, e.g. `2.39:1`.
  final String aspectRatio;

  /// Template ids (= seed ids), the type's default first.
  final List<String> templateIds;
}

const _typeBySeedId = {
  'short-film': ProjectType.shortFilm,
  'long-film': ProjectType.longFilm,
  'youtube-video': ProjectType.youtube,
  'short': ProjectType.short,
};

Future<Map<String, dynamic>> _seed(String file) async =>
    jsonDecode(await rootBundle.loadString('assets/seed/$file'))
        as Map<String, dynamic>;

/// The four project types with their template options (D-14: from seed JSON).
final ideaTypesProvider = FutureProvider<List<IdeaType>>((ref) async {
  final ratios = {
    for (final r in (await _seed('aspect_ratios.json'))['items'] as List)
      (r as Map)['id'] as String: r['name'] as String,
  };
  return [
    for (final t in (await _seed('project_types.json'))['items'] as List)
      if (_typeBySeedId[(t as Map)['id']] != null)
        IdeaType(
          id: t['id'] as String,
          name: t['name'] as String,
          type: _typeBySeedId[t['id']]!,
          aspectRatio: ratios[t['default_aspect_ratio']]!,
          templateIds: [
            t['default_template'] as String,
            for (final o in t['template_options'] as List)
              if (o != t['default_template']) o as String,
          ],
        ),
  ];
});

/// Template rows for [ids], in that order (ids missing from the DB are skipped).
final ideaTemplatesProvider = FutureProvider.family<List<Template>, IdeaType>((
  ref,
  t,
) async {
  final rows =
      await (ref.watch(dbProvider).select(ref.watch(dbProvider).templates)
            ..where((r) => r.id.isIn(t.templateIds)))
          .get();
  return [
    for (final id in t.templateIds)
      for (final r in rows)
        if (r.id == id) r,
  ];
});

/// AI_CONTRACT 4.5 + spec 7: generates first content for a story idea, then
/// creates the project. The AI call comes first, so a failure leaves no
/// project behind. All content is written by [ProposalEngine.approve] from a
/// proposal row (D-17); storyboards are never touched. Returns the project id.
Future<String> createProjectFromIdea(
  AppDatabase db,
  AiClient ai, {
  required VoidItem item,
  required String summary,
  required String title,
  required IdeaType type,
  required String templateId,
}) async {
  if (item.promotedProjectId != null) {
    throw StateError('Story idea already became a project');
  }
  if (title.trim().isEmpty) throw ArgumentError('title is required');
  final perms = await newProjectAiPermissions(db);
  final tpl = await (db.select(
    db.templates,
  )..where((t) => t.id.equals(templateId))).getSingle();
  final slots =
      await (db.select(db.slots)
            ..where((s) => s.templateId.equals(templateId))
            ..orderBy([(s) => OrderingTerm.asc(s.position)]))
          .get();
  final draft = await generateProject(
    ai,
    summary: summary,
    rawTranscript: item.rawTranscript,
    projectType: const EnumConverter(ProjectType.values).toSql(type.type),
    template: {
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
    permissions: perms,
  );
  final id = const Uuid().v4();
  final pid = const Uuid().v4();
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.transaction(() async {
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: id,
        title: title.trim(),
        type: type.type,
        summary: '',
        templateId: Value(templateId),
        aspectRatio: type.aspectRatio,
        typeFields: const {},
        aiPermissions: perms,
        sourceVoidItemId: Value(item.id),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: pid,
            projectId: id,
            status: ProposalStatus.pending,
            summary: 'First content from story idea',
            rawTranscript: item.rawTranscript,
            summarySpans: const [],
            changes: draft.changes,
            sourceVoidItemId: Value(item.id),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await ProposalEngine(db).approve(pid);
    await SnapshotService(db)
        .create(id, SnapshotReason.created, 'Created from story idea');
    await (db.update(db.voidItems)..where((v) => v.id.equals(item.id))).write(
      VoidItemsCompanion(
        status: const Value(VoidStatus.ready),
        promotedProjectId: Value(id),
        usedInProjectIds: Value([...item.usedInProjectIds, id]),
        updatedAt: Value(now),
      ),
    );
  });
  return id;
}
