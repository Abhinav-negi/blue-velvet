import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:lynch/core/widgets/diff_view.dart';
import 'package:lynch/core/widgets/suggested_text.dart';
import 'package:lynch/core/widgets/transcript_highlight.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

// AI_CONTRACT 2.3 worked example.
const raw =
    "Okay so um there's this kid, like eight years old, and he finds a rusty key in the sandbox. Um, and the watchman, the old guy who never sleeps, he sees him.";
const quotes = [
  "there's this kid, like eight years old, and he finds a rusty key in the sandbox",
  'the old guy who never sleeps',
  'he sees him',
];

Widget host(ThemeData t, Widget child, {Color? bg}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: t,
  home: Scaffold(
    backgroundColor: bg,
    body: Padding(padding: const EdgeInsets.all(AppSpace.s2), child: child),
  ),
);

Widget demo({required bool paper}) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    DiffView(
      onPaper: paper,
      lines: const [
        DiffLine.added('The watchman never sleeps.'),
        DiffLine.removed('A dog barks outside.'),
        DiffLine.changed(
          before: 'The kid is seven.',
          after: 'The kid is eight.',
        ),
      ],
    ),
    const SizedBox(height: AppSpace.s2),
    SuggestedText('A rusty key glints in the sand.', onPaper: paper),
    const SizedBox(height: AppSpace.s2),
    TranscriptHighlight(
      onPaper: paper,
      transcript: raw,
      spans: [
        for (final q in quotes)
          HighlightRange(raw.indexOf(q), raw.indexOf(q) + q.length),
      ],
    ),
  ],
);

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

  testWidgets('DiffView: added, removed, changed carry icon and word', (
    t,
  ) async {
    await t.pumpWidget(host(AppTheme.dark, demo(paper: false)));
    // added x2 (added + changed.after), removed x2 (removed + changed.before)
    expect(find.byIcon(LucideIcons.plus), findsNWidgets(2));
    expect(find.byIcon(LucideIcons.minus), findsNWidgets(2));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Added',
      ),
      findsNWidgets(2),
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Removed',
      ),
      findsNWidgets(2),
    );
    // changed: removed text sits above added text
    expect(
      t.getTopLeft(find.text('The kid is seven.')).dy <
          t.getTopLeft(find.text('The kid is eight.')).dy,
      isTrue,
    );
    final struck = t.widget<Text>(find.text('A dog barks outside.'));
    expect(struck.style!.decoration, TextDecoration.lineThrough);
    final added = t.widget<Text>(find.text('The watchman never sleeps.'));
    expect(added.style!.decoration, isNot(TextDecoration.lineThrough));
  });

  testWidgets('SuggestedText: italic with amber left rule', (t) async {
    await t.pumpWidget(host(AppTheme.dark, const SuggestedText('Hi')));
    expect(t.widget<Text>(find.text('Hi')).style!.fontStyle, FontStyle.italic);
    final box = t.widget<Container>(find.byType(Container).first);
    final border = (box.decoration! as BoxDecoration).border! as Border;
    expect(border.left.color, AppColors.amber);
  });

  testWidgets('TranscriptHighlight lights exactly the span substrings', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        AppTheme.dark,
        TranscriptHighlight(
          transcript: raw,
          spans: [
            for (final q in quotes)
              HighlightRange(raw.indexOf(q), raw.indexOf(q) + q.length),
          ],
        ),
      ),
    );
    final root = t.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
    final lit = [
      for (final c in root.children!.cast<TextSpan>())
        if (c.style?.backgroundColor != null) c.text,
    ];
    expect(lit, quotes);
    expect(root.children!.map((c) => (c as TextSpan).text).join(), raw);
  });

  test('TranscriptHighlight.merge joins overlaps and drops bad spans', () {
    final m = TranscriptHighlight.merge(10, const [
      HighlightRange(5, 8),
      HighlightRange(0, 3),
      HighlightRange(2, 6),
      HighlightRange(4, 4),
      HighlightRange(9, 99),
      HighlightRange(20, 30),
    ]);
    expect([for (final r in m) (r.start, r.end)], [(0, 8), (9, 10)]);
  });

  testWidgets('golden: demo on dark and on paper', (t) async {
    t.view.physicalSize = const Size(400, 520);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(host(AppTheme.dark, demo(paper: false)));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/widgets_dark.png'),
    );
    // Paper surface under the dark theme: proves onPaper picks paper ink.
    await t.pumpWidget(
      host(AppTheme.dark, demo(paper: true), bg: AppColors.paperBg),
    );
    await t.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/widgets_paper.png'),
    );
  });
}
