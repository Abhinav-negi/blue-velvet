import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/data/snapshots.dart';
import 'package:lynch/features/home/sample_project.dart';

void main() {
  late AppDatabase db;
  late Directory files;
  late String json;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    files = Directory.systemTemp.createTempSync('sample');
    json = File('assets/seed/sample_project.json').readAsStringSync();
    await SeedLoader(db).load(); // five-point template + slots
  });
  tearDown(() async {
    await db.close();
    files.deleteSync(recursive: true);
  });

  Future<List<Project>> projects() => db.select(db.projects).get();

  test(
    'content: summary, 2 characters, 3 beats in slots, frame, map edge',
    () async {
      final id = (await loadSampleProject(db, files, json))!;
      final p = (await db.projectsDao.byId(id))!;
      expect(p.isSample, isTrue);
      expect(p.templateId, 'five-point');
      expect(p.summary, isNotEmpty);
      expect(await db.select(db.characters).get(), hasLength(2));
      final beats = await db.select(db.beats).get();
      expect(beats, hasLength(3));
      expect(beats.every((b) => b.slotId!.startsWith('five-point/')), isTrue);
      expect(
        beats.any((b) => b.blocks!.any((x) => x['scaffold'] == true)),
        isTrue,
      );
      final f = (await db.select(db.frames).get()).single;
      final strokes = jsonDecode(
        File('${files.path}/${f.strokesPath}').readAsStringSync(),
      );
      expect((strokes['strokes'] as List), isNotEmpty);
      final map = (await db.charactersDao.mapFor(id))!;
      expect(map.edges.single['label'], 'afraid of');
    },
  );

  test('second launch does not duplicate; deleting keeps it deleted', () async {
    final id = await loadSampleProject(db, files, json);
    expect(await loadSampleProject(db, files, json), isNull);
    expect(await projects(), hasLength(1));

    await deleteSampleProject(db, id!);
    expect(await projects(), isEmpty);
    expect(await db.select(db.characters).get(), isEmpty);
    expect(await loadSampleProject(db, files, json), isNull);
    expect(await projects(), isEmpty);
  });

  test('delete touches only the sample', () async {
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'mine',
        title: 'Mine',
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {},
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    final id = (await loadSampleProject(db, files, json))!;
    await deleteSampleProject(db, 'mine'); // not a sample: no-op
    expect(await projects(), hasLength(2));
    await deleteSampleProject(db, id);
    expect((await projects()).single.id, 'mine');
  });

  test('snapshot round trip', () async {
    final id = (await loadSampleProject(db, files, json))!;
    final svc = SnapshotService(db);
    final before = await svc.capture(id);
    final snap = await svc.create(id, SnapshotReason.manual, 'sample');
    await db.beatsDao.upsert(
      BeatsCompanion.insert(
        id: 'extra',
        projectId: id,
        position: 9,
        title: 'x',
        description: '',
        characterIds: const [],
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    await svc.restore(snap.id);
    expect(jsonEncode(await svc.capture(id)), jsonEncode(before));
  });
}
