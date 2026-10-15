import 'package:drift/drift.dart';
import 'package:lynch/core/data/db.dart';

Future<List<Beat>> _ordered(AppDatabase db, String projectId) =>
    (db.select(db.beats)
          ..where((b) => b.projectId.equals(projectId))
          ..orderBy([(b) => OrderingTerm.asc(b.position)]))
        .get();

/// Writes [order] back as positions 0..n-1 (contiguous), only where changed.
Future<void> _renumber(AppDatabase db, List<Beat> order) async {
  for (var i = 0; i < order.length; i++) {
    if (order[i].position != i) {
      await (db.update(db.beats)..where((b) => b.id.equals(order[i].id))).write(
        BeatsCompanion(position: Value(i)),
      );
    }
  }
}

/// Moves [beatId] into [slotId] (null = unplaced) at [index] among that
/// slot's beats ([flat]: among all beats, slot untouched; no-template mode).
/// Positions stay contiguous.
// ponytail: an empty target slot appends to the end of the global order.
Future<void> moveBeat(
  AppDatabase db,
  String beatId, {
  required String? slotId,
  required int index,
  bool flat = false,
}) => db.transaction(() async {
  final b = await (db.select(
    db.beats,
  )..where((t) => t.id.equals(beatId))).getSingle();
  final all = await _ordered(db, b.projectId);
  all.removeWhere((x) => x.id == beatId);
  final peers = [
    for (var i = 0; i < all.length; i++)
      if (flat || all[i].slotId == slotId) i,
  ];
  final at = peers.isEmpty
      ? all.length
      : index < peers.length
      ? peers[index]
      : peers.last + 1;
  all.insert(at, b);
  await (db.update(db.beats)..where((t) => t.id.equals(beatId))).write(
    BeatsCompanion(
      slotId: flat ? const Value.absent() : Value(slotId),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );
  await _renumber(db, all);
});

/// Splits [beatId]'s description at [at]: the beat keeps the first part (and
/// its frames and script), a new beat right after it takes the rest.
/// Whitespace at the cut is dropped, so `a + ' ' + b` is the original.
Future<String> splitBeat(AppDatabase db, String beatId, {required int at}) =>
    db.transaction(() async {
      final b = await (db.select(
        db.beats,
      )..where((t) => t.id.equals(beatId))).getSingle();
      final cut = at.clamp(0, b.description.length);
      final now = DateTime.now().millisecondsSinceEpoch;
      final newId = 'beat-$now-split';
      await (db.update(db.beats)..where((t) => t.id.equals(beatId))).write(
        BeatsCompanion(
          description: Value(b.description.substring(0, cut).trimRight()),
          updatedAt: Value(now),
        ),
      );
      await db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: newId,
          projectId: b.projectId,
          slotId: Value(b.slotId),
          position: b.position + 1,
          title: '${b.title} (2)',
          description: b.description.substring(cut).trimLeft(),
          characterIds: b.characterIds,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final all = await _ordered(db, b.projectId);
      // The new row shares a position with the beat after it; put it first.
      all.sort((x, y) {
        final c = x.position.compareTo(y.position);
        return c != 0 ? c : (x.id == newId ? -1 : (y.id == newId ? 1 : 0));
      });
      await _renumber(db, all);
      return newId;
    });

/// Merges [ids] into the first (survivor). Mirrors the proposal engine:
/// frames are re-parented, never deleted; script and say/show are appended.
Future<void> mergeBeats(AppDatabase db, List<String> ids) {
  assert(ids.length >= 2 && ids.toSet().length == ids.length);
  return db.transaction(() async {
    Future<Beat> get(String id) =>
        (db.select(db.beats)..where((t) => t.id.equals(id))).getSingle();
    final s = await get(ids.first);
    var desc = s.description;
    var blocks = s.blocks;
    var sayShow = s.sayShow;
    final chars = [...s.characterIds];
    var fpos = (await (db.select(
      db.frames,
    )..where((t) => t.beatId.equals(s.id))).get()).length;
    for (final id in ids.skip(1)) {
      final b = await get(id);
      if (b.description.isNotEmpty) {
        desc = desc.isEmpty ? b.description : '$desc ${b.description}';
      }
      if (b.blocks?.isNotEmpty ?? false) blocks = [...?blocks, ...b.blocks!];
      if (b.sayShow?.isNotEmpty ?? false) {
        sayShow = [...?sayShow, ...b.sayShow!];
      }
      chars.addAll(b.characterIds.where((c) => !chars.contains(c)));
      final fs =
          await (db.select(db.frames)
                ..where((t) => t.beatId.equals(id))
                ..orderBy([(t) => OrderingTerm.asc(t.position)]))
              .get();
      for (final f in fs) {
        await (db.update(db.frames)..where((t) => t.id.equals(f.id))).write(
          FramesCompanion(beatId: Value(s.id), position: Value(fpos++)),
        );
      }
    }
    await (db.update(db.beats)..where((t) => t.id.equals(s.id))).write(
      BeatsCompanion(
        description: Value(desc),
        characterIds: Value(chars),
        blocks: Value(blocks),
        sayShow: Value(sayShow),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    await (db.delete(db.beats)..where((t) => t.id.isIn(ids.skip(1)))).go();
    await _renumber(db, await _ordered(db, s.projectId));
  });
}
