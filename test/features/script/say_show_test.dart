import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/script/screenplay_format.dart';
import 'package:lynch/features/script/script_screen.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  late AppDatabase db;
  setUpAll(() async {
    await loadFont('CourierPrime', 'assets/fonts/CourierPrime-Regular.ttf');
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
  });
  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<void> pump(WidgetTester tester, ProjectType type) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final film = type == ProjectType.shortFilm;
    await tester.runAsync(() async {
      await db.projectsDao.upsert(
        ProjectsCompanion.insert(
          id: 'p',
          title: 'P',
          type: type,
          summary: '',
          aspectRatio: '16:9',
          typeFields: const {},
          aiPermissions: const {},
          createdAt: 1,
          updatedAt: 1,
        ),
      );
      await db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: 'b',
          projectId: 'p',
          position: 0,
          title: 'Opening',
          description: '',
          characterIds: const [],
          blocks: Value(film ? [] : null),
          sayShow: Value(film ? null : []),
          createdAt: 1,
          updatedAt: 1,
        ),
      );
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ScriptScreen(projectId: 'p')),
        ),
      ),
    );
    await tester.runAsync(
      () =>
          ProviderScope.containerOf(tester.element(find.byType(ScriptScreen)))
              .read(screenplayFormatProvider.future),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('adding a row creates Say and Show cells that persist', (
    tester,
  ) async {
    await pump(tester, ProjectType.youtube);
    expect(find.text('Script'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('add-row')));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Say'), 'Hello.');
    await tester.enterText(find.widgetWithText(TextField, 'A-roll'), 'Me');
    await tester.enterText(find.widgetWithText(TextField, 'Graphics'), 'Logo');
    await tester.pumpAndSettle();
    final beats = await tester.runAsync(
      () => db.beatsDao.watchForProject('p').first,
    );
    final rows = beats!.single.sayShow!;
    expect(rows, hasLength(1));
    expect(rows[0]['say'], 'Hello.');
    expect(rows[0]['show'], {
      'a_roll': 'Me',
      'b_roll': '',
      'on_screen_text': '',
      'graphics': 'Logo',
    });
    await finish(tester);
  });

  testWidgets('a YouTube project shows Say/Show', (tester) async {
    await pump(tester, ProjectType.youtube);
    expect(find.byKey(const ValueKey('add-row')), findsOneWidget);
    await finish(tester);
  });

  testWidgets('a film project shows the screenplay editor', (tester) async {
    await pump(tester, ProjectType.shortFilm);
    expect(find.byKey(const ValueKey('add-row')), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
    await finish(tester);
  });
}
