import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// Template id of a project (null = no-template mode).
final projectTemplateProvider = StreamProvider.family<String?, String>((
  ref,
  projectId,
) {
  final db = ref.watch(dbProvider);
  return (db.select(db.projects)..where((p) => p.id.equals(projectId)))
      .watchSingleOrNull()
      .map((p) => p?.templateId);
});

/// Beats of a project in board order.
final projectBeatsProvider = StreamProvider.family<List<Beat>, String>(
  (ref, projectId) => ref.watch(dbProvider).beatsDao.watchForProject(projectId),
);

/// Ids of beats that have at least one storyboard frame.
// ponytail: reads every frame's beat id; narrow to the project if it gets slow.
final beatsWithFramesProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.watch(dbProvider);
  final q = db.selectOnly(db.frames, distinct: true)
    ..addColumns([db.frames.beatId]);
  return q.watch().map(
    (rows) => {for (final r in rows) r.read(db.frames.beatId)!},
  );
});

/// Creates ([id] null) or edits a beat. New beats go last, in [slotId].
Future<void> saveBeat(
  AppDatabase db, {
  required String projectId,
  String? id,
  String? slotId,
  required String title,
  required String description,
}) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  if (id != null) {
    await (db.update(db.beats)..where((b) => b.id.equals(id))).write(
      BeatsCompanion(
        title: Value(title.trim()),
        description: Value(description.trim()),
        updatedAt: Value(now),
      ),
    );
    return;
  }
  final last =
      await (db.select(db.beats)
            ..where((b) => b.projectId.equals(projectId))
            ..orderBy([(b) => OrderingTerm.desc(b.position)])
            ..limit(1))
          .getSingleOrNull();
  await db.beatsDao.upsert(
    BeatsCompanion.insert(
      id: 'beat-$now',
      projectId: projectId,
      slotId: Value(slotId),
      position: (last?.position ?? -1) + 1,
      title: title.trim(),
      description: description.trim(),
      characterIds: const [],
      createdAt: now,
      updatedAt: now,
    ),
  );
}
