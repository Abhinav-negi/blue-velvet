import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/home/sample_project.dart';
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

Future<void> addPending(AppDatabase db, String id, String projectId) => db
    .into(db.proposals)
    .insert(
      ProposalsCompanion.insert(
        id: id,
        projectId: projectId,
        status: ProposalStatus.pending,
        summary: 's',
        rawTranscript: 't',
        summarySpans: const [],
        changes: const [],
        createdAt: 1,
        updatedAt: 1,
      ),
    );

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

void main() {
  late AppDatabase db;

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

  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          sampleInitProvider.overrideWith((ref) async {}),
        ],
        child: const LynchApp(),
      ),
    );
    await settle(tester);
  }

  testWidgets('title-only project appears in list and opens its shell', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('New project'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Watchman');
    await tester.tap(find.text('Create'));
    await settle(tester);
    expect(find.byKey(const Key('shell-tabs')), findsOneWidget);
    await tester.tap(find.byTooltip('Home'));
    await settle(tester);
    expect(find.text('Watchman'), findsOneWidget);
    await tester.tap(find.text('Watchman'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('shell-tabs')), findsOneWidget);
    await finish(tester, db);
  });

  testWidgets('badge hidden at 0 pending', (tester) async {
    await tester.runAsync(() => addProject(db, 'a', 'Alpha'));
    await pumpHome(tester);
    expect(find.byKey(const Key('pending-badge')), findsNothing);
    await finish(tester, db);
  });

  testWidgets('badge counts pending proposals across projects', (tester) async {
    await tester.runAsync(() async {
      await addProject(db, 'a', 'Alpha');
      await addProject(db, 'b', 'Beta');
      await addPending(db, 'p1', 'a');
      await addPending(db, 'p2', 'b');
      await addPending(db, 'p3', 'b');
    });
    await pumpHome(tester);
    expect(
      find.descendant(
        of: find.byKey(const Key('pending-badge')),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
    await finish(tester, db);
  });

  testWidgets('golden: Home with projects and badge', (tester) async {
    await tester.runAsync(() async {
      await addProject(db, 'a', 'The Watchman');
      await addProject(db, 'b', 'Playground');
      await addPending(db, 'p1', 'a');
      await addPending(db, 'p2', 'b');
    });
    await pumpHome(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home.png'),
    );
    await finish(tester, db);
  });
}
