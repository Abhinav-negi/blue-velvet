import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/main.dart';
import 'package:lynch/router.dart';

/// Home with one project ('Alpha') in an in-memory DB.
Future<AppDatabase> pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase(NativeDatabase.memory());
  await tester.runAsync(
    () => db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'a',
        title: 'Alpha',
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {},
        createdAt: 1,
        updatedAt: 1,
      ),
    ),
  );
  router.go('/');
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const LynchApp(),
    ),
  );
  await settle(tester);
  return db;
}

/// Drift does real async work; let it finish, then rebuild.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
}

/// Unmount (drift schedules a zero timer on stream cancel), then close the DB.
Future<void> finish(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.runAsync(db.close);
}

Future<void> openProject(WidgetTester tester) async {
  await tester.tap(find.text('Alpha'));
  await tester.pumpAndSettle();
}

/// flutter_test renders Ahem boxes unless fonts are loaded by hand.
Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  setUpAll(() async {
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    await loadFont('Literata', 'assets/fonts/Literata-VF.ttf');
    final lucide = Directory(
      '${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev',
    ).listSync().firstWhere((e) => e.path.contains('lucide_icons_flutter-'));
    await loadFont(
      'packages/lucide_icons_flutter/Lucide',
      '${lucide.path}/assets/lucide.ttf',
    );
  });

  const tabs = [
    'Overview',
    'Characters',
    'Beats',
    'Script',
    'Board',
    'Settings',
  ];

  testWidgets('from Home open a project and visit all 6 tabs', (tester) async {
    final db = await pumpApp(tester, const Size(400, 800));
    await openProject(tester);
    for (final t in tabs) {
      final tab = find.descendant(
        of: find.byKey(const Key('shell-tabs')),
        matching: find.text(t),
      );
      await tester.ensureVisible(tab);
      await tester.tap(tab);
      await tester.pumpAndSettle();
      // The body placeholder shows the tab title as well as the tab label.
      expect(find.text(t), findsNWidgets(2), reason: t);
    }
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    await settle(tester);
    expect(find.text('Projects'), findsOneWidget);
    await finish(tester, db);
  });

  testWidgets('400 dp: tabs on top, 64 dp bottom bar and mic', (tester) async {
    final db = await pumpApp(tester, const Size(400, 800));
    await openProject(tester);
    expect(find.byKey(const Key('shell-tabs')), findsOneWidget);
    expect(find.byKey(const Key('shell-rail')), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('shell-bottom-bar'))).height,
      64,
    );
    expect(
      tester.getSize(find.byKey(const Key('shell-mic'))),
      const Size(64, 64),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/shell_phone_400.png'),
    );
    await finish(tester, db);
  });

  testWidgets('800 dp: left rail, 64 dp bottom bar and mic', (tester) async {
    final db = await pumpApp(tester, const Size(800, 600));
    await openProject(tester);
    expect(find.byKey(const Key('shell-rail')), findsOneWidget);
    expect(find.byKey(const Key('shell-tabs')), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('shell-bottom-bar'))).height,
      64,
    );
    expect(
      tester.getSize(find.byKey(const Key('shell-mic'))),
      const Size(64, 64),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/shell_tablet_800.png'),
    );
    await finish(tester, db);
  });
}
