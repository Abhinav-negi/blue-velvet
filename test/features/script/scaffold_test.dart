import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:lynch/features/script/screenplay_format.dart';
import 'package:lynch/features/script/scaffold_suggestions.dart';
import 'package:lynch/features/script/script_screen.dart';

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
      'blocks': [
        {'type': 'scene_heading', 'text': 'INT. KITCHEN - NIGHT'},
        {'type': 'action', 'text': 'Maya waits.'},
      ],
      'rows': <Object>[],
    };
  }
}

void main() {
  late AppDatabase db;
  late FakeAi ai;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    ai = FakeAi();
  });

  Future<void> boot(WidgetTester tester, Map<String, dynamic> perms) async {
    await tester.runAsync(() async {
      await db.projectsDao.upsert(
        ProjectsCompanion.insert(
          id: 'p',
          title: 'P',
          type: ProjectType.shortFilm,
          summary: '',
          aspectRatio: '16:9',
          typeFields: const {},
          aiPermissions: perms,
          createdAt: 1,
          updatedAt: 1,
        ),
      );
      await db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: 'b',
          projectId: 'p',
          position: 0,
          title: 'Kitchen night',
          description: 'Maya waits in the kitchen.',
          characterIds: const [],
          blocks: const Value(null),
          createdAt: 1,
          updatedAt: 1,
        ),
      );
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          scriptAiProvider.overrideWithValue(ai),
        ],
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

  Future<List<dynamic>?> saved(WidgetTester tester) async =>
      (await tester.runAsync(() => db.beatsDao.watchForProject('p').first))!
          .single
          .blocks;

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('new empty beat is scaffolded only when permission is on', (
    tester,
  ) async {
    await boot(tester, const {'screenplay_scaffold': false});
    expect(ai.calls, 0);
    expect(find.byKey(const ValueKey('suggest-structure')), findsNothing);
    await finish(tester);
  });

  testWidgets('suggestions use the proposal style and save only on accept', (
    tester,
  ) async {
    await boot(tester, const {'screenplay_scaffold': true});
    expect(ai.calls, 1);
    final t = tester.widget<Text>(find.text('INT. KITCHEN - NIGHT'));
    expect(t.style, AppType.proposal);
    expect(await saved(tester), isNull);
    Future<List<Proposal>> proposals() => db.select(db.proposals).get();
    expect((await tester.runAsync(proposals))!, isEmpty);

    await tester.tap(find.byKey(const ValueKey('accept-suggestion')));
    await tester.pumpAndSettle();
    final blocks = await saved(tester);
    expect(
      [for (final b in blocks!) b['text']],
      ['INT. KITCHEN - NIGHT', 'Maya waits.'],
    );
    expect(blocks.every((b) => b['scaffold'] == true), isTrue);
    final ps = (await tester.runAsync(proposals))!;
    expect(ps.single.status, ProposalStatus.approved);
    expect(ps.single.changes.single['beat_id'], 'b');
    // The editor now shows the accepted blocks.
    expect(find.text('INT. KITCHEN - NIGHT'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('dismissed suggestion is never saved; button asks again', (
    tester,
  ) async {
    await boot(tester, const {'screenplay_scaffold': true});
    await tester.tap(find.byKey(const ValueKey('dismiss-suggestion')));
    await tester.pumpAndSettle();
    expect(await saved(tester), isNull);
    await tester.tap(find.byKey(const ValueKey('suggest-structure')));
    await tester.pumpAndSettle();
    expect(ai.calls, 2);
    expect(find.byKey(const ValueKey('accept-suggestion')), findsOneWidget);
    await finish(tester);
  });
}
