import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/features/beats/beat_ops.dart';

void main() {
  test(
    'split joins to the original; merge reverses it, keeping frames',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      await db
          .into(db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: 'p',
              title: 'P',
              type: ProjectType.shortFilm,
              summary: '',
              aspectRatio: '16:9',
              typeFields: const {},
              aiPermissions: const {},
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      Future<void> beat(String id, int pos, String d) => db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: id,
          projectId: 'p',
          position: pos,
          title: id,
          description: d,
          characterIds: const [],
          createdAt: 1,
          updatedAt: 1,
        ),
      );
      const orig = 'She opens the door. He is gone.';
      await beat('a', 0, 'x');
      await beat('b', 1, orig);
      await beat('c', 2, 'z');
      await db
          .into(db.frames)
          .insert(
            FramesCompanion.insert(
              id: 'f1',
              beatId: 'b',
              position: 0,
              notes: '',
              characterIds: const [],
              referenceImages: const [],
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      Future<List<Beat>> rows() => (db.select(
        db.beats,
      )..orderBy([(b) => OrderingTerm.asc(b.position)])).get();

      final n = await splitBeat(db, 'b', at: 20);
      var r = await rows();
      expect([for (final b in r) b.id], ['a', 'b', n, 'c']);
      expect([for (final b in r) b.position], [0, 1, 2, 3]);
      expect('${r[1].description} ${r[2].description}', orig);

      await mergeBeats(db, ['b', n]);
      r = await rows();
      expect([for (final b in r) b.id], ['a', 'b', 'c']);
      expect([for (final b in r) b.position], [0, 1, 2]);
      expect(r[1].description, orig);
      expect((await db.select(db.frames).get()).single.beatId, 'b');
      await db.close();
    },
  );
}
