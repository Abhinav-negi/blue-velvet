import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/proposal_engine.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/proposals/routes.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

const raw = 'A kid finds a key. The watchman sees him.';

Map<String, dynamic> addBeat(String title) => {
  'op': 'addBeat',
  'id': title,
  'accepted': true,
  'title': title,
  'description': 'd',
  'character_names': <String>[],
};

void main() {
  late AppDatabase db;
  final haptics = <String>[];

  setUpAll(() async {
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    await loadFont('Literata', 'assets/fonts/Literata-VF.ttf');
  });

  Future<void> seed() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'p',
        title: 'The Key',
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {},
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: 'pr',
            projectId: 'p',
            status: ProposalStatus.pending,
            summary: 'A kid finds a key.',
            rawTranscript: raw,
            summarySpans: [
              {'sentence_index': 0, 'start': 0, 'end': 18},
            ],
            changes: [addBeat('One'), addBeat('Two'), addBeat('Three')],
            createdAt: 1,
            updatedAt: 1,
          ),
        );
  }

  Future<void> open(WidgetTester t, {String at = '/proposals/pr'}) async {
    t.view.physicalSize = const Size(400, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    haptics.clear();
    t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (c) async {
        if (c.method == 'HapticFeedback.vibrate') haptics.add('${c.arguments}');
        return null;
      },
    );
    addTearDown(
      () => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await t.runAsync(seed);
    await t.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(initialLocation: at, routes: proposalsRoutes),
        ),
      ),
    );
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await t.pump();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await t.runAsync(db.close);
  }

  Future<int> beatCount() async => (await db.select(db.beats).get()).length;

  testWidgets('accepting 2 of 3 applies only those, haptic fires', (t) async {
    await open(t);
    expect(find.text('Approve all'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('accept-1')));
    await t.pump();
    expect(find.text('Approve 2 of 3'), findsOneWidget);
    await t.tap(find.text('Approve 2 of 3'));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    final titles = await t.runAsync(
      () async => [for (final b in await db.select(db.beats).get()) b.title],
    );
    expect(titles!.toSet(), {'One', 'Three'});
    final p = await t.runAsync(() => db.select(db.proposals).getSingle());
    expect(p!.status, ProposalStatus.approved);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
    await finish(t);
  });

  testWidgets('Reject to Void files the transcript', (t) async {
    await open(t);
    await t.tap(find.text('Reject'));
    await t.pumpAndSettle();
    await t.tap(find.text('Send to the Void'));
    await t.pump();
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    final items = await t.runAsync(() => db.select(db.voidItems).get());
    expect(items!.single.rawTranscript, raw);
    final p = await t.runAsync(() => db.select(db.proposals).getSingle());
    expect(p!.status, ProposalStatus.rejected);
    expect(p.rejectedToVoidItemId, items.single.id);
    expect(await t.runAsync(beatCount), 0);
    await finish(t);
  });

  testWidgets('Defer leaves it pending, nothing applied, no haptic', (t) async {
    await open(t);
    await t.tap(find.text('Defer'));
    await t.pump();
    final p = await t.runAsync(() => db.select(db.proposals).getSingle());
    expect(p!.status, ProposalStatus.pending);
    expect(await t.runAsync(beatCount), 0);
    expect(haptics, isEmpty);
    await finish(t);
  });

  testWidgets('after approve an Undo bar shows; Undo restores', (t) async {
    await open(t);
    await t.tap(find.text('Approve all'));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    expect(find.text('Undo'), findsOneWidget);
    expect(await t.runAsync(beatCount), 3);
    await t.pump(const Duration(milliseconds: 500));
    await t.tap(find.text('Undo'));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    expect(await t.runAsync(beatCount), 0);
    final p = await t.runAsync(() => db.select(db.proposals).getSingle());
    expect(p!.status, ProposalStatus.pending);
    await finish(t);
  });

  testWidgets('restoring a snapshot adds history entries', (t) async {
    await open(t, at: '/project/p/history');
    await t.runAsync(
      () =>
          ProposalEngine(db).snapshots
              .create('p', SnapshotReason.manual, 'Start'),
    );
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await t.pump();
    final before = (await t.runAsync(() => db.select(db.snapshots).get()))!;
    expect(find.text('Start'), findsOneWidget);
    await t.tap(find.text('Start'));
    await t.pumpAndSettle();
    await t.tap(find.text('Restore this version'));
    await t.pumpAndSettle();
    expect(find.textContaining('shared sheets'), findsNothing);
    await t.tap(find.text('Restore'));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await t.pumpAndSettle();
    final after = (await t.runAsync(() => db.select(db.snapshots).get()))!;
    expect(after.length, before.length + 2);
    expect(find.text('Restored: Start'), findsOneWidget);
    await finish(t);
  });

  testWidgets('restore dialog warns about linked characters', (t) async {
    await open(t, at: '/project/p/history');
    await t.runAsync(() async {
      await db
          .into(db.characters)
          .insert(
            CharactersCompanion.insert(
              id: 'c',
              name: 'Kid',
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
              id: 'pc',
              projectId: 'p',
              characterId: const Value('c'),
              mode: CharacterMode.linked,
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await ProposalEngine(db).snapshots
          .create('p', SnapshotReason.manual, 'Linked');
    });
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await t.pump();
    await t.tap(find.text('Linked'));
    await t.pumpAndSettle();
    await t.tap(find.text('Restore this version'));
    await t.pumpAndSettle();
    expect(find.textContaining('shared sheets'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    await finish(t);
  });
}
