import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/widgets/diff_view.dart';
import 'package:lynch/features/void/routes.dart';
import 'package:lynch/features/void/void_actions.dart';

class FakeAi extends AiClient {
  FakeAi(this.reply) : super(readStoredKey: () async => 'k');
  final Map<String, dynamic> reply;
  final prompts = <String>[];
  @override
  Future<Map<String, dynamic>> generateJson({
    required String prompt,
    required Map<String, dynamic> schema,
    List<Map<String, dynamic>> extraParts = const [],
    AiPermission? gate,
    Map<String, dynamic> permissions = const {},
  }) async {
    prompts.add(prompt);
    return reply;
  }
}

VoidItemsCompanion row(
  String id,
  String summary,
  String raw,
  int at, {
  VoidType type = VoidType.concept,
  List<Map<String, int>> spans = const [],
}) => VoidItemsCompanion.insert(
  id: id,
  type: type,
  summary: summary,
  rawTranscript: raw,
  summarySpans: spans,
  structure: {},
  tags: [],
  usedInProjectIds: [],
  status: VoidStatus.ready,
  createdAt: at,
  updatedAt: at,
);

void main() {
  late AppDatabase db;

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
    await t.pumpAndSettle();
  }

  Future<void> boot(WidgetTester t, FakeAi ai) async {
    t.view.physicalSize = const Size(400, 700);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.runAsync(() async {
      db = AppDatabase(NativeDatabase.memory());
      await db.voidItemsDao.upsert(
        row('a', 'First part. Second part.', 'raw one', 1),
      );
      await db.voidItemsDao.upsert(
        row(
          'b',
          'Other idea.',
          'raw two',
          2,
          spans: [
            {'sentence_index': 0, 'start': 0, 'end': 3},
          ],
        ),
      );
    });
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          voidAiProvider.overrideWithValue(ai),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            initialLocation: '/void/a',
            routes: voidRoutes,
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

  Map<String, dynamic> patch(String type, String text) => {
    'outcome': 'item_patch',
    'item': {
      'type': type,
      'summary_sentences': [
        {'text': text, 'source_quotes': <String>[]},
      ],
      'structure': <String, dynamic>{},
      'tags': <String>[],
    },
  };

  testWidgets('merge keeps both transcripts in one item', (t) async {
    await boot(t, FakeAi({}));
    await menu(t, 'Merge with...');
    await t.tap(find.byType(CheckboxListTile));
    await t.tap(find.text('Merge'));
    await settle(t);
    final all = await t.runAsync(() => db.voidItemsDao.watchAll().first);
    expect(all!.length, 1);
    expect(all.single.rawTranscript, 'raw one\n\nraw two');
    expect(all.single.summary, 'First part. Second part. Other idea.');
    // b's span moved past a's two sentences and its 'raw one\n\n' prefix.
    expect(all.single.summarySpans.single, {
      'sentence_index': 2,
      'start': 9,
      'end': 12,
    });
    await finish(t);
  });

  testWidgets('AI edit shows a diff and only applies on approve', (t) async {
    await boot(t, FakeAi(patch('concept', 'First part.')));
    await menu(t, 'Edit with AI');
    await t.enterText(find.byType(TextField), 'remove the second part');
    await t.tap(find.text('OK'));
    await settle(t);
    expect(find.byType(DiffView), findsOneWidget);
    Future<String> stored() async =>
        (await t.runAsync(() => db.voidItemsDao.byId('a')))!.summary;
    expect(await stored(), 'First part. Second part.');
    await t.tap(find.text('Reject'));
    await settle(t);
    expect(await stored(), 'First part. Second part.');

    await menu(t, 'Edit with AI');
    await t.enterText(find.byType(TextField), 'remove the second part');
    await t.tap(find.text('OK'));
    await settle(t);
    await t.tap(find.text('Approve'));
    await settle(t);
    expect(await stored(), 'First part.');
    await finish(t);
  });

  testWidgets('change type re-runs structure for the new type', (t) async {
    final ai = FakeAi({
      'outcome': 'item_patch',
      'item': {
        'type': 'character',
        'summary_sentences': [
          {'text': 'First part. Second part.', 'source_quotes': <String>[]},
        ],
        'structure': {'name': 'Kid'},
        'tags': <String>[],
      },
    });
    await boot(t, ai);
    await menu(t, 'Change type');
    await t.tap(find.text('Character').last);
    await settle(t);
    expect(
      ai.prompts.single,
      contains('Change this item\'s type to Character'),
    );
    await t.tap(find.text('Approve'));
    await settle(t);
    final it = await t.runAsync(() => db.voidItemsDao.byId('a'));
    expect(it!.type, VoidType.character);
    expect(it.structure, {'name': 'Kid'});
    await finish(t);
  });
}
