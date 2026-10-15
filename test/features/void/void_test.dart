import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/widgets/transcript_highlight.dart';
import 'package:lynch/features/void/routes.dart';
import 'package:go_router/go_router.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

const raw =
    "Okay so um there's this kid, like eight years old, and he finds a rusty key in the sandbox. Um, and the watchman, the old guy who never sleeps, he sees him.";
const q0 =
    "there's this kid, like eight years old, and he finds a rusty key in the sandbox";
const q1 = 'the old guy who never sleeps';

VoidItemsCompanion item(
  String id,
  VoidType type,
  String summary,
  int at, {
  String rawText = 'raw',
  List<Map<String, int>> spans = const [],
  Map<String, dynamic> structure = const {},
}) => VoidItemsCompanion.insert(
  id: id,
  type: type,
  summary: summary,
  rawTranscript: rawText,
  summarySpans: spans,
  structure: structure,
  tags: [],
  usedInProjectIds: [],
  status: VoidStatus.ready,
  createdAt: at,
  updatedAt: at,
);

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

  Future<void> seed() async {
    db = AppDatabase(NativeDatabase.memory());
    final d = db.voidItemsDao;
    await d.upsert(
      item('a', VoidType.concept, 'Oldest concept about time.', 1),
    );
    await d.upsert(
      item(
        'b',
        VoidType.dialogue,
        'The watchman and the kid argue about the key.',
        2,
        structure: {
          'lines': [
            {'speaker': 'Watchman', 'text': 'Nobody sleeps here.'},
          ],
          'context': '',
        },
      ),
    );
    await d.upsert(
      item(
        'c',
        VoidType.storyIdea,
        'A kid finds a rusty key in the sandbox. The old guy who never sleeps sees him.',
        3,
        rawText: raw,
        spans: [
          {
            'sentence_index': 0,
            'start': raw.indexOf(q0),
            'end': raw.indexOf(q0) + q0.length,
          },
          {
            'sentence_index': 1,
            'start': raw.indexOf(q1),
            'end': raw.indexOf(q1) + q1.length,
          },
        ],
      ),
    );
    await d.upsert(
      item(
        'd',
        VoidType.lyric,
        'Newest line of a song.',
        4,
        structure: {
          'sections': [
            {'kind': 'chorus', 'text': 'Keys in the sand'},
          ],
        },
      ),
    );
  }

  Widget app({String start = '/void'}) => ProviderScope(
    overrides: [dbProvider.overrideWithValue(db)],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: GoRouter(initialLocation: start, routes: voidRoutes),
    ),
  );

  // Drift runs on real async, so let it run outside the fake clock.
  Future<void> size(WidgetTester t) async {
    t.view.physicalSize = const Size(400, 700);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.runAsync(seed);
    addTearDown(() => db.close());
  }

  // Unmount so drift's stream-cleanup timer fires before the test ends.
  Future<void> unmount(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(Duration.zero);
  }

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
    await t.pumpAndSettle();
  }

  testWidgets('grid: newest first with type icons', (t) async {
    await size(t);
    await t.pumpWidget(app());
    await settle(t);
    // Masonry puts newest (d) top-left, next (c) top-right, then b, a.
    final order = ['Newest line', 'A kid finds', 'The watchman and', 'Oldest'];
    final tops = [for (final s in order) t.getTopLeft(find.textContaining(s))];
    expect(tops[0].dy <= tops[2].dy && tops[1].dy <= tops[3].dy, isTrue);
    expect(tops[0].dx, lessThan(tops[1].dx));
    for (final i in [
      LucideIcons.music,
      LucideIcons.sparkles,
      LucideIcons.messageSquare,
      LucideIcons.lightbulb,
    ]) {
      expect(find.byIcon(i), findsOneWidget);
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/grid.png'),
    );
    await unmount(t);
  });

  testWidgets('detail: tapping a summary sentence highlights its span', (
    t,
  ) async {
    await size(t);
    await t.pumpWidget(app());
    await settle(t);
    await t.tap(find.textContaining('A kid finds'));
    await settle(t);
    List<String> lit() {
      final root =
          t
                  .widget<Text>(
                    find.byWidgetPredicate(
                      (w) => w is Text && w.textSpan != null,
                    ),
                  )
                  .textSpan!
              as TextSpan;
      return [
        for (final c in root.children!.cast<TextSpan>())
          if (c.style?.backgroundColor != null) c.text!,
      ];
    }

    expect(find.byType(TranscriptHighlight), findsOneWidget);
    expect(lit(), isEmpty);
    await t.tap(find.text('The old guy who never sleeps sees him.'));
    await settle(t);
    expect(lit(), [q1]);
    await t.tap(find.text('A kid finds a rusty key in the sandbox.'));
    await settle(t);
    expect(lit(), [q0]);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/detail.png'),
    );
    await unmount(t);
  });

  testWidgets('detail shows type structure', (t) async {
    await size(t);
    await t.pumpWidget(app());
    await settle(t);
    await t.tap(find.textContaining('The watchman and'));
    await settle(t);
    expect(find.textContaining('Nobody sleeps here.'), findsOneWidget);
    expect(find.textContaining('Watchman: '), findsOneWidget);
    await unmount(t);
  });
}
