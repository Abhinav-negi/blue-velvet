import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// App documents folder; `strokes_path` is relative to it. Tests override.
final filesDirProvider = FutureProvider<Directory>(
  (ref) => getApplicationDocumentsDirectory(),
);

/// Frames of a beat in order.
final framesProvider = StreamProvider.family<List<Frame>, String>(
  (ref, beatId) => ref.watch(dbProvider).beatsDao.watchFrames(beatId),
);

/// Members of a project as (project_characters id, display name).
final frameCharactersProvider =
    FutureProvider.family<Map<String, String>, String>((ref, projectId) async {
      final db = ref.watch(dbProvider);
      final q = db.select(db.projectCharacters).join([
        leftOuterJoin(
          db.characters,
          db.characters.id.equalsExp(db.projectCharacters.characterId),
        ),
      ])..where(db.projectCharacters.projectId.equals(projectId));
      return {
        for (final r in await q.get())
          r.readTable(db.projectCharacters).id:
              r.readTable(db.projectCharacters).name ??
              r.readTableOrNull(db.characters)?.name ??
              '?',
      };
    });

/// One-line caption: shot size · angle · movement · lens · duration.
String frameCaption(Frame f) {
  final d = f.durationMs;
  final secs = d == null
      ? null
      : '${(d / 1000).toStringAsFixed(d % 1000 == 0 ? 0 : 1)}s';
  return [
    f.shotSize,
    f.angle,
    f.movement,
    f.lensFeel,
    secs,
  ].where((s) => s != null && s.trim().isNotEmpty).join(' · ');
}

Future<void> _renumber(AppDatabase db, List<Frame> ordered) async {
  for (var i = 0; i < ordered.length; i++) {
    if (ordered[i].position == i) continue;
    await (db.update(db.frames)..where((f) => f.id.equals(ordered[i].id)))
        .write(FramesCompanion(position: Value(i)));
  }
}

Future<List<Frame>> _ordered(AppDatabase db, String beatId) =>
    (db.select(db.frames)
          ..where((f) => f.beatId.equals(beatId))
          ..orderBy([(f) => OrderingTerm.asc(f.position)]))
        .get();

/// Appends an empty frame to the beat.
Future<void> addFrame(AppDatabase db, String beatId) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.beatsDao.upsertFrame(
    FramesCompanion.insert(
      id: 'frame-${now}_${_seq++}',
      beatId: beatId,
      position: (await _ordered(db, beatId)).length,
      notes: '',
      characterIds: const [],
      referenceImages: const [],
      createdAt: now,
      updatedAt: now,
    ),
  );
}

int _seq = 0;

/// Copies a frame (details and stroke file) right after the original.
Future<void> duplicateFrame(AppDatabase db, Directory files, Frame f) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final id = 'frame-${now}_${_seq++}';
  String? strokes;
  final src = f.strokesPath;
  if (src != null && File(p.join(files.path, src)).existsSync()) {
    strokes = p.join('strokes', '$id.json');
    final dest = File(p.join(files.path, strokes));
    await dest.parent.create(recursive: true);
    await File(p.join(files.path, src)).copy(dest.path);
  }
  await db.transaction(() async {
    final all = await _ordered(db, f.beatId);
    final at = all.indexWhere((x) => x.id == f.id) + 1;
    await db.beatsDao.upsertFrame(
      FramesCompanion.insert(
        id: id,
        beatId: f.beatId,
        position: at,
        strokesPath: Value(strokes),
        aspectRatio: Value(f.aspectRatio),
        shotSize: Value(f.shotSize),
        angle: Value(f.angle),
        movement: Value(f.movement),
        lensFeel: Value(f.lensFeel),
        durationMs: Value(f.durationMs),
        notes: f.notes,
        blockId: Value(f.blockId),
        characterIds: f.characterIds,
        referenceImages: f.referenceImages,
        shotId: Value(f.shotId),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final copy = await (db.select(
      db.frames,
    )..where((x) => x.id.equals(id))).getSingle();
    await _renumber(db, [...all]..insert(at, copy));
  });
}

/// Deletes the row only. The stroke file stays until backup compaction
/// (DATA_MODEL 13.1) so a snapshot restore does not bring back a blank frame.
Future<void> deleteFrame(AppDatabase db, Frame f) async {
  await db.transaction(() async {
    await (db.delete(db.frames)..where((x) => x.id.equals(f.id))).go();
    await _renumber(db, await _ordered(db, f.beatId));
  });
}

/// Moves a frame from index [from] to [to] (final index, after removal).
Future<void> moveFrame(AppDatabase db, String beatId, int from, int to) async {
  await db.transaction(() async {
    final all = await _ordered(db, beatId);
    all.insert(to, all.removeAt(from));
    await _renumber(db, all);
  });
}

/// Saves edited details. Blank strings become null; [durationSecs] null clears.
Future<void> saveFrameDetails(
  AppDatabase db,
  String id, {
  required String shotSize,
  required String angle,
  required String movement,
  required String lensFeel,
  required double? durationSecs,
  required String notes,
  required String? blockId,
  required List<String> characterIds,
}) {
  String? n(String s) => s.trim().isEmpty ? null : s.trim();
  return (db.update(db.frames)..where((f) => f.id.equals(id))).write(
    FramesCompanion(
      shotSize: Value(n(shotSize)),
      angle: Value(n(angle)),
      movement: Value(n(movement)),
      lensFeel: Value(n(lensFeel)),
      durationMs: Value(
        durationSecs == null ? null : (durationSecs * 1000).round(),
      ),
      notes: Value(notes.trim()),
      blockId: Value(blockId),
      characterIds: Value(characterIds),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );
}

@visibleForTesting
void resetFrameSeq() => _seq = 0;

/// Beats of a project in board order (storyboard keeps its own read; features can't import each other).
final boardBeatsProvider = StreamProvider.family<List<Beat>, String>(
  (ref, projectId) => ref.watch(dbProvider).beatsDao.watchForProject(projectId),
);
