import 'package:drift/drift.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/project_context.dart';
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
