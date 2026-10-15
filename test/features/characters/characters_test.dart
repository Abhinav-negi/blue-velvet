import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/main.dart';
import 'package:lynch/router.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

Future<void> addProject(AppDatabase db, String id, String title) =>
    db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: id,
        title: title,
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {},
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

  setUpAll(() async {
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    await loadFont('Literata', 'assets/fonts/Literata-VF.ttf');
  });

  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<void> pumpAt(WidgetTester tester, String path) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router.go(path);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: const LynchApp(),
      ),
    );
    await settle(tester);
  }

  testWidgets('creating a character saves every field', (tester) async {
    await tester.runAsync(() => addProject(db, 'a', 'Alpha'));
    await pumpAt(tester, '/project/a/characters');
    await tester.tap(find.text('New character'));
    await tester.pumpAndSettle();
    const values = {
      'name': 'Watchman',
      'age': '70s',
      'role': 'Guardian',
      'appearance': 'old man',
      'background': 'lost a son',
      'traits': 'stubborn',
      'habits': 'never sleeps',
      'wantsNeedsFears': 'wants peace',
      'notes': 'recurring',
    };
    for (final e in values.entries) {
      final f = find.byKey(Key('field-${e.key}'));
      await tester.ensureVisible(f);
      await tester.enterText(f, e.value);
    }
    await tester.tap(find.text('Save'));
    await settle(tester);
    final rows = await tester.runAsync(() => db.select(db.characters).get());
    final c = rows!.single;
    expect([
      c.name,
      c.age,
      c.role,
      c.appearance,
      c.background,
      c.traits,
      c.habits,
      c.wantsNeedsFears,
      c.notes,
    ], values.values.toList());
    final members = await tester.runAsync(
      () => db.select(db.projectCharacters).get(),
    );
    expect(members!.single.characterId, c.id);
    expect(members.single.mode, CharacterMode.linked);
    expect(find.text('Watchman'), findsOneWidget); // back on the list
    await finish(tester, db);
  });

  testWidgets('the pool lists characters from all projects', (tester) async {
    await tester.runAsync(() async {
      await addProject(db, 'a', 'Alpha');
      await addProject(db, 'b', 'Beta');
      for (final (i, n) in ['Kid', 'Watchman'].indexed) {
        await db
            .into(db.characters)
            .insert(
              CharactersCompanion.insert(
                id: 'c$i',
                name: n,
                role: '',
                appearance: '',
                background: '',
                traits: '',
                habits: '',
                wantsNeedsFears: '',
                notes: '',
                createdAt: 1,
                updatedAt: 1,
              ),
            );
        await db
            .into(db.projectCharacters)
            .insert(
              ProjectCharactersCompanion.insert(
                id: 'm$i',
                projectId: i == 0 ? 'a' : 'b',
                characterId: Value(i == 0 ? 'c0' : 'c1'),
                mode: CharacterMode.linked,
                createdAt: 1,
                updatedAt: 1,
              ),
            );
      }
    });
    await pumpAt(tester, '/project/a/characters');
    expect(find.text('Kid'), findsOneWidget);
    expect(find.text('Watchman'), findsNothing); // not in project a
    await tester.tap(find.text('Character pool'));
    await settle(tester);
    expect(find.text('Kid'), findsOneWidget);
    expect(find.text('Watchman'), findsOneWidget);
    await finish(tester, db);
  });
}
