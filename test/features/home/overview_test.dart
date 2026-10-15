import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/home/sample_project.dart';
import 'package:lynch/main.dart';
import 'package:lynch/router.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<void> seed(
    String type,
    ProjectType t,
    Map<String, dynamic> fields, {
    int snaps = 0,
    int pending = 0,
  }) async {
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'p',
        title: 'P',
        type: t,
        summary: 'A kid finds a key.',
        aspectRatio: '16:9',
        typeFields: fields,
        aiPermissions: const {},
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    for (var i = 0; i < pending; i++) {
      await db
          .into(db.proposals)
          .insert(
            ProposalsCompanion.insert(
              id: 'pp$i',
              projectId: 'p',
              status: ProposalStatus.pending,
              summary: 's',
              rawTranscript: 't',
              summarySpans: const [],
              changes: const [],
              createdAt: 1,
              updatedAt: 1,
            ),
          );
    }
    for (var i = 0; i < snaps; i++) {
      await db
          .into(db.snapshots)
          .insert(
            SnapshotsCompanion.insert(
              id: 's$i',
              projectId: 'p',
              reason: SnapshotReason.values.first,
              label: 'snap $i',
              data: const {},
              createdAt: i + 1,
              proposalId: const Value.absent(),
            ),
          );
    }
  }

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router.go('/project/p/overview');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          sampleInitProvider.overrideWith((ref) async {}),
        ],
        child: const LynchApp(),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('summary, pending count and last 5 snapshots', (tester) async {
    await tester.runAsync(
      () => seed('', ProjectType.shortFilm, const {}, snaps: 7, pending: 2),
    );
    await pump(tester);
    expect(find.text('A kid finds a key.'), findsOneWidget);
    expect(find.text('2 pending'), findsOneWidget);
    for (var i = 2; i < 7; i++) {
      expect(find.text('snap $i'), findsOneWidget);
    }
    expect(find.text('snap 1'), findsNothing);
    expect(find.text('snap 0'), findsNothing);
    await finish(tester);
  });

  testWidgets('youtube shows title and thumbnail ideas', (tester) async {
    await tester.runAsync(
      () => seed('', ProjectType.youtube, const {
        'title_ideas': ['I found a key'],
        'thumbnail_ideas': ['Kid with rusty key'],
      }),
    );
    await pump(tester);
    expect(find.text('I found a key'), findsOneWidget);
    expect(find.text('Kid with rusty key'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('short shows hook text and caption', (tester) async {
    await tester.runAsync(
      () => seed('', ProjectType.short, const {
        'hook_text': 'He finds a key.',
        'caption': 'Wait for it',
      }),
    );
    await pump(tester);
    expect(find.text('He finds a key.'), findsOneWidget);
    expect(find.text('Wait for it'), findsOneWidget);
    await finish(tester);
  });
}
