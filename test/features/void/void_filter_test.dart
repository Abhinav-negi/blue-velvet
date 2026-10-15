import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/void/routes.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.now().millisecondsSinceEpoch;
  const day = 86400000;

  VoidItemsCompanion item(
    String id,
    VoidType type,
    String summary,
    int at, {
    String raw = 'raw',
    List<String> tags = const [],
    List<String> used = const [],
  }) => VoidItemsCompanion.insert(
    id: id,
    type: type,
    summary: summary,
    rawTranscript: raw,
    summarySpans: [],
    structure: {},
    tags: tags,
    usedInProjectIds: used,
    status: VoidStatus.ready,
    createdAt: at,
    updatedAt: at,
  );

  Future<void> seed() async {
    db = AppDatabase(NativeDatabase.memory());
    final d = db.voidItemsDao;
    await d.upsert(
      item('a', VoidType.concept, 'Alpha', now - 40 * day, tags: ['sea']),
    );
    await d.upsert(
      item(
        'b',
        VoidType.concept,
        'Bravo',
        now - 2 * day,
        tags: ['sea'],
        raw: 'zeppelin overhead',
      ),
    );
    await d.upsert(
      item('c', VoidType.lyric, 'Charlie', now - 2 * day, tags: ['sea', 'sad']),
    );
    await d.upsert(
      item(
        'd',
        VoidType.concept,
        'Delta',
        now - 20 * day,
        tags: ['sad'],
        used: ['p1'],
      ),
    );
  }

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
  }

  Future<void> pumpApp(WidgetTester t) async {
    t.view.physicalSize = const Size(400, 700);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.runAsync(seed);
    addTearDown(() => db.close());
    await t.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(initialLocation: '/void', routes: voidRoutes),
        ),
      ),
    );
    await settle(t);
  }

  Future<void> unmount(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
  }

  Future<void> chip(WidgetTester t, String label) async {
    await t.ensureVisible(find.widgetWithText(FilterChip, label));
    await t.tap(find.widgetWithText(FilterChip, label));
    await settle(t);
  }

  Set<String> shown(WidgetTester t) => {
    for (final s in ['Alpha', 'Bravo', 'Charlie', 'Delta'])
      if (find.text(s).evaluate().isNotEmpty) s,
  };

  testWidgets('each filter narrows, and filters combine', (t) async {
    await pumpApp(t);
    expect(shown(t), {'Alpha', 'Bravo', 'Charlie', 'Delta'});

    await chip(t, 'Lyric');
    expect(shown(t), {'Charlie'});
    await chip(t, 'Lyric'); // toggle off

    await chip(t, '#sad');
    expect(shown(t), {'Charlie', 'Delta'});
    await chip(t, '#sad');

    await chip(t, 'Last 7 days');
    expect(shown(t), {'Bravo', 'Charlie'});
    await chip(t, 'Last 7 days');

    await chip(t, 'Used');
    expect(shown(t), {'Delta'});
    await chip(t, 'Unused');
    expect(shown(t), {'Alpha', 'Bravo', 'Charlie'});
    await chip(t, 'Unused');

    // Combine: concept + #sea + last 30 days + unused -> Bravo only.
    await chip(t, 'Concept');
    await chip(t, '#sea');
    await chip(t, 'Last 30 days');
    await chip(t, 'Unused');
    expect(shown(t), {'Bravo'});
    await unmount(t);
  });

  testWidgets('search finds an item by a transcript-only word', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextField), 'zeppelin');
    await settle(t);
    expect(shown(t), {'Bravo'});
    await chip(t, 'Lyric'); // combined with a filter: no overlap
    expect(find.text('No matches.'), findsOneWidget);
    await unmount(t);
  });
}
