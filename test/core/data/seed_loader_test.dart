import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/data/seed_mapping.dart';

Map<String, dynamic> shot(String id, String name,
        {String category = 'shot_size'}) =>
    {
      'id': id, 'name': name, 'category': category, 'description': 'd',
      'when_to_use': 'w', 'effect': 'e', 'tags': ['t'],
      'sources': ['https://en.wikipedia.org/wiki/X'],
      'images': [
        {'file': '$id.jpg', 'license': 'CC0', 'author': 'a', 'source_url': 'https://c.org/x'}
      ],
    };

Map<String, dynamic> template(String id, String name) => {
      'id': id, 'name': name, 'description': 'd',
      'source_urls': ['https://en.wikipedia.org/wiki/T'],
      'project_types': ['short-film', 'youtube-video'],
      'slots': [
        {'id': 'a', 'name': 'A', 'description': 'd', 'proportion': 0.4},
        {'id': 'b', 'name': 'B', 'description': 'd'},
      ],
    };

String file(int v, List items) => jsonEncode({'version': v, 'items': items});

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> count(ResultSetImplementation<HasResultSet, dynamic> t) async =>
      (await db.select(t).get()).length;

  SeedLoader loader(Map<String, String> files, [List<String>? logs]) =>
      SeedLoader(db,
          read: (n) async => files[n] ?? (throw 'no file $n'),
          log: logs?.add,
          now: () => 1000);

  test('fresh DB: row counts equal item counts', () async {
    await loader({
      'templates': file(1, [template('t1', 'T1'), template('t2', 'T2')]),
      'shots_camera': file(1, [shot('s1', 'S1'), shot('s2', 'S2')]),
      'shots_look': file(1, [shot('s3', 'S3', category: 'lens')]),
    }).load();
    expect(await count(db.templates), 2);
    expect(await count(db.slots), 4);
    expect(await count(db.shots), 3);
    expect(await count(db.shotImages), 3);
    expect(jsonDecode((await db.settingsDao.get('seed_version'))!),
        {'templates': 1, 'shots_camera': 1, 'shots_look': 1});
  });

  test('version bump updates untouched rows, keeps user_edited rows', () async {
    await loader({
      'templates': file(1, [template('t1', 'T1')]),
      'shots_camera': file(1, [shot('s1', 'S1'), shot('s2', 'S2')]),
      'shots_look': file(1, [shot('s3', 'S3')]),
    }).load();
    await (db.update(db.shots)..where((t) => t.seedId.equals('s2'))).write(
        const ShotsCompanion(name: Value('Mine'), userEdited: Value(true)));

    await loader({
      'templates': file(1, [template('t1', 'T1 renamed')]), // same version
      'shots_camera': file(
          2, [shot('s1', 'S1 v2'), shot('s2', 'S2 v2'), shot('s4', 'S4')]),
      'shots_look': file(1, [shot('s3', 'S3 renamed')]), // same version
    }).load();

    final shots = {
      for (final s in await db.select(db.shots).get()) s.seedId!: s
    };
    expect(shots['s1']!.name, 'S1 v2');
    expect(shots['s2']!.name, 'Mine');
    expect(shots['s4']!.name, 'S4');
    expect(shots['s3']!.name, 'S3');
    expect((await db.select(db.templates).getSingle()).name, 'T1');
    expect(await count(db.shots), 4);
  });

  test('missing or malformed file is skipped and logged; others load',
      () async {
    final logs = <String>[];
    await loader({
      'templates': '{not json',
      'shots_look': file(1, [shot('s3', 'S3'), {'id': 'bad'}]),
      'shots_camera': file(1, [shot('s1', 'S1')]),
    }, logs)
        .load();
    expect(logs.length, 2); // templates + shots_look
    expect(await count(db.templates), 0);
    expect((await db.select(db.shots).get()).map((s) => s.seedId), ['s1']);

    logs.clear();
    await loader({'shots_look': file(1, [shot('s3', 'S3')])}, logs).load();
    expect(logs.length, 2); // templates + shots_camera missing
    expect(await count(db.shots), 2);
  });

  test('seed names map to DATA_MODEL names', () {
    final t = mapSeedTemplate({
      ...template('t1', 'T1'),
      'project_types': ['short-film', 'long-film', 'youtube-video', 'short'],
    }, 1);
    expect(t.template.projectTypes.value,
        ['short_film', 'long_film', 'youtube', 'short']);
    expect(t.template.sourceUrl.value, 'https://en.wikipedia.org/wiki/T');
    expect(t.slots[0].runtimeProportion.value, 0.4); // proportion
    expect(t.slots[0].seedId.value, 't1/a');
    expect(t.slots[1].runtimeProportion.value, isNull);

    final s = mapSeedShot(shot('s1', 'S1'), 1);
    expect(s.shot.category.value, ShotCategory.size); // shot_size
    expect(s.shot.sources.value.first, {
      'title': 'en.wikipedia.org',
      'url': 'https://en.wikipedia.org/wiki/X'
    });
    expect(s.images.single.path.value, 'assets/seed/images/s1.jpg');
    expect(s.images.single.kind.value, ShotImageKind.seedAsset);
  });

  test('real assets/seed files load', () async {
    final logs = <String>[];
    await SeedLoader(db,
            read: (n) => File('assets/seed/$n.json').readAsString(),
            log: logs.add)
        .load();
    expect(logs, isEmpty);
    expect(await count(db.templates), greaterThan(0));
    expect(await count(db.shots), greaterThan(0));
  });
}
