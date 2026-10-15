import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/shots/shot_detail_screen.dart';
import 'package:lynch/features/shots/shot_providers.dart';
import 'package:lynch/features/shots/shots_screen.dart';

Future<void> addShot(
  AppDatabase db,
  String id,
  String name,
  ShotCategory cat, {
  List<String> tags = const [],
}) => db
    .into(db.shots)
    .insert(
      ShotsCompanion.insert(
        id: id,
        name: name,
        category: cat,
        description: 'd',
        whenToUse: 'w',
        effect: 'e',
        tags: tags,
        sources: const [],
        createdAt: 1,
        updatedAt: 1,
      ),
    );

Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
}

Future<void> finish(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.runAsync(db.close);
}

void main() {
  late AppDatabase db;
  late Directory tmp;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tmp = Directory.systemTemp.createTempSync('shots_test');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  Future<void> pump(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          filesDirProvider.overrideWith((ref) => tmp),
        ],
        child: MaterialApp(home: home),
      ),
    );
    await settle(tester);
  }

  testWidgets('category filter and search narrow the list', (tester) async {
    await tester.runAsync(() async {
      await addShot(db, 'a', 'Close-up', ShotCategory.size, tags: ['face']);
      await addShot(db, 'b', 'Dolly in', ShotCategory.movement);
      await addShot(db, 'c', 'Dutch angle', ShotCategory.angle);
    });
    await pump(tester, const ShotsScreen());
    expect(find.text('Close-up'), findsOneWidget);
    expect(find.text('Dolly in'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Movement'));
    await tester.pumpAndSettle();
    expect(find.text('Dolly in'), findsOneWidget);
    expect(find.text('Close-up'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.enterText(find.byType(TextField), 'face');
    await tester.pumpAndSettle();
    expect(find.text('Close-up'), findsOneWidget);
    expect(find.text('Dolly in'), findsNothing);
    await finish(tester, db);
  });

  testWidgets('detail shows author and license of built-in image', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await addShot(db, 'a', 'Close-up', ShotCategory.size);
      await db
          .into(db.shotImages)
          .insert(
            ShotImagesCompanion.insert(
              id: 'i1',
              shotId: 'a',
              position: 0,
              path: 'assets/seed/images/close-up.jpg',
              kind: ShotImageKind.seedAsset,
              license: const Value('CC BY-SA 4.0'),
              author: const Value('Jane Doe'),
              createdAt: 1,
              updatedAt: 1,
            ),
          );
    });
    await pump(tester, const ShotDetailScreen(id: 'a'));
    expect(find.textContaining('Jane Doe'), findsOneWidget);
    expect(find.textContaining('CC BY-SA 4.0'), findsOneWidget);
    await finish(tester, db);
  });

  test('addUserImage copies into files folder and links it', () async {
    await addShot(db, 'a', 'Close-up', ShotCategory.size);
    final src = File('${tmp.path}/pic.JPG')..writeAsBytesSync([1, 2, 3]);
    await addUserImage(db, tmp, 'a', src);
    final rows = await db.select(db.shotImages).get();
    expect(rows, hasLength(1));
    expect(rows.single.kind, ShotImageKind.userFile);
    expect(rows.single.shotId, 'a');
    expect(rows.single.path, matches(RegExp(r'^shot_images/[^/]+\.jpg$')));
    expect(File('${tmp.path}/${rows.single.path}').readAsBytesSync(), [
      1,
      2,
      3,
    ]);
    await db.close();
  });
}
