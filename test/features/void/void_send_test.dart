import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/void/routes.dart';
import 'package:lynch/features/void/void_send.dart';

class FakeAi extends AiClient {
  FakeAi() : super(readStoredKey: () async => 'k');
  int calls = 0;
  @override
  Future<Map<String, dynamic>> generateJson({
    required String prompt,
    required Map<String, dynamic> schema,
    List<Map<String, dynamic>> extraParts = const [],
    AiPermission? gate,
    Map<String, dynamic> permissions = const {},
  }) async {
    calls++;
    return {
      'summary_sentences': [
        {'text': 'A lighthouse keeper.', 'source_quotes': <String>[]},
      ],
      'changes': <Map<String, dynamic>>[],
    };
  }
}

void main() {
  late AppDatabase db;
  late FakeAi ai;

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
    await t.pumpAndSettle();
  }

  Future<void> boot(WidgetTester t, String at, {VoidType? type}) async {
    t.view.physicalSize = const Size(400, 700);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    ai = FakeAi();
    await t.runAsync(() async {
      db = AppDatabase(NativeDatabase.memory());
      await db.voidItemsDao.upsert(
        VoidItemsCompanion.insert(
          id: 'a',
          type: type ?? VoidType.concept,
          summary: 'A lighthouse keeper.',
          rawTranscript: 'a lighthouse keeper',
          summarySpans: const [],
          structure: {},
          tags: [],
          usedInProjectIds: [],
          status: VoidStatus.ready,
          createdAt: 1,
          updatedAt: 1,
        ),
      );
      await db.projectsDao.upsert(
        ProjectsCompanion.insert(
          id: 'p1',
          title: 'The Key',
          type: ProjectType.shortFilm,
          summary: '',
          aspectRatio: '2.39:1',
          typeFields: const {},
          aiPermissions: const {},
          createdAt: 1,
          updatedAt: 1,
        ),
      );
    });
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          aiClientProvider.overrideWithValue(ai),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            initialLocation: at,
            routes: [
              ...voidRoutes,
              GoRoute(
                path: '/idea/:voidItemId',
                name: 'project-from-idea',
                builder: (_, s) =>
                    Text('review ${s.pathParameters['voidItemId']}'),
              ),
            ],
          ),
        ),
      ),
    );
    await settle(t);
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await t.runAsync(() => db.close());
  }

  Future<void> menu(WidgetTester t, String entry) async {
    await t.tap(find.byIcon(LucideIcons.ellipsis));
    await settle(t);
    await t.tap(find.text(entry));
    await settle(t);
  }

  testWidgets('send to project: pending proposal, item marked used, reusable', (
    t,
  ) async {
    await boot(t, '/void/a');
    for (var n = 1; n <= 2; n++) {
      await menu(t, 'Send to project...');
      await t.tap(find.text('The Key'));
      await settle(t);
      final props = (await t.runAsync(() => db.select(db.proposals).get()))!;
      expect(props, hasLength(n));
      expect(props.every((p) => p.status == ProposalStatus.pending), isTrue);
      expect(props.first.projectId, 'p1');
      expect(props.first.sourceVoidItemId, 'a');
      final it = (await t.runAsync(() => db.voidItemsDao.byId('a')))!;
      expect(it.usedInProjectIds, ['p1']); // once, still in the Void
      expect(it.status, VoidStatus.ready);
    }
    expect(ai.calls, 2);
    await finish(t);
  });

  testWidgets('pull from inside a project sends the picked item', (t) async {
    await boot(t, '/void/pick/p1');
    await t.tap(find.text('A lighthouse keeper.'));
    await settle(t);
    final props = (await t.runAsync(() => db.select(db.proposals).get()))!;
    expect(props.single.projectId, 'p1');
    expect(
      (await t.runAsync(() => db.voidItemsDao.byId('a')))!.usedInProjectIds,
      ['p1'],
    );
    await finish(t);
  });

  testWidgets('promote sets pre-project and opens the review', (t) async {
    await boot(t, '/void/a', type: VoidType.storyIdea);
    await menu(t, 'Promote to project');
    expect(find.text('review a'), findsOneWidget);
    expect(
      (await t.runAsync(() => db.voidItemsDao.byId('a')))!.status,
      VoidStatus.preProject,
    );
    await finish(t);
  });

  testWidgets('promote is only offered on an unpromoted story idea', (t) async {
    await boot(t, '/void/a');
    await t.tap(find.byIcon(LucideIcons.ellipsis));
    await settle(t);
    expect(find.text('Promote to project'), findsNothing);
    await finish(t);
  });

  test('promoteIdea refuses a promoted idea', () async {
    final d = AppDatabase(NativeDatabase.memory());
    addTearDown(d.close);
    final it = VoidItem(
      id: 'x',
      type: VoidType.storyIdea,
      summary: '',
      rawTranscript: '',
      summarySpans: const [],
      structure: const {},
      tags: const [],
      usedInProjectIds: const [],
      promotedProjectId: 'p',
      status: VoidStatus.ready,
      createdAt: 1,
      updatedAt: 1,
    );
    expect(() => promoteIdea(d, it), throwsStateError);
  });
}
