import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/export/export_screen.dart';
import 'package:lynch/features/export/pdf_layout.dart';
import 'package:lynch/features/export/screenplay_pdf.dart';

ByteData font() => ByteData.sublistView(
  File('assets/fonts/CourierPrime-Regular.ttf').readAsBytesSync(),
);

ScreenplayLayout layout() => ScreenplayLayout.fromJson(
  File('assets/seed/screenplay_format.json').readAsStringSync(),
);

Map<String, dynamic> b(String type, String text) => {
  'type': type,
  'text': text,
};

void main() {
  test('layout model: Courier 12 pt, Letter margins, element indents', () {
    final l = layout();
    expect(ScreenplayLayout.fontSizePt, 12);
    expect(ScreenplayLayout.linePt, 12);
    expect([l.widthIn, l.heightIn], [8.5, 11.0]);
    expect(
      [l.marginTopIn, l.marginBottomIn, l.marginLeftIn, l.marginRightIn],
      [1.0, 1.0, 1.5, 1.0],
    );
    expect(l.textWidthIn, 6.0);
    expect(l.styles['scene_heading']!.leftIn, 1.5);
    expect(l.styles['character']!.leftIn, 3.7);
    expect(l.styles['dialogue']!.leftIn, 2.5);
    expect(l.widthOf(l.styles['dialogue']!), 3.5);
    expect(l.styles['parenthetical']!.rightIn, 3.0);
    expect(l.styles['transition']!.align, 'right');
  });

  test('layout model: casing, spacing merge, skipping', () {
    final out = layout().layout([
      b('scene_heading', 'ext. yard - day'),
      b('action', 'A kid digs.'),
      b('character', 'kid'),
      b('parenthetical', 'quiet'),
      b('dialogue', 'Hi.'),
      b('action', '  '),
      b('transition', 'cut to:'),
      b('mystery', 'Falls back to action.'),
    ]);
    expect(out.map((e) => e.text), [
      'EXT. YARD - DAY',
      'A kid digs.',
      'KID',
      '(quiet)',
      'Hi.',
      'CUT TO:',
      'Falls back to action.',
    ]);
    // heading first: 0; action after heading: max(1 after, 1 before) = 1;
    // character 1; parenthetical/dialogue 0; transition 1; action after
    // transition: max(1, 1) = 1.
    expect(out.map((e) => e.blankLinesBefore), [0, 1, 1, 0, 0, 1, 1]);
  });

  test('layout model: wraps at 10 characters per inch of column width', () {
    expect(ScreenplayLayout.wrap('aaa bbb ccc', 0.8), ['aaa bbb', 'ccc']);
    final d = layout().layout([b('dialogue', 'x ' * 30)]).single;
    expect(d.lines.every((x) => x.length <= 35), isTrue); // 3.5 in
    expect(d.lines.length, greaterThan(1));
  });

  test('renders a valid multi-page PDF', () async {
    final blocks = [
      for (var i = 0; i < 40; i++) ...[
        b('scene_heading', 'INT. ROOM $i - DAY'),
        b('action', 'Something happens here. ' * 6),
        b('character', 'Maya'),
        b('dialogue', 'Words words words. ' * 5),
      ],
    ];
    final bytes = await screenplayPdf(layout(), font(), [blocks]);
    final s = latin1.decode(bytes);
    expect(s, startsWith('%PDF'));
    expect(RegExp(r'/Type/Page/').allMatches(s).length, greaterThan(1));
    expect(s, contains('CourierPrime'));
  });

  testWidgets('export shares a .pdf file', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.runAsync(() async {
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
      await db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: 'e',
          projectId: 'p',
          position: 0,
          title: 'x',
          description: '',
          characterIds: const [],
          blocks: Value([b('scene_heading', 'EXT. YARD - DAY')]),
          createdAt: 1,
          updatedAt: 1,
        ),
      );
    });
    String? name;
    List<int>? bytes;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          shareBytesProvider.overrideWithValue((n, d) async {
            name = n;
            bytes = d;
          }),
        ],
        child: const MaterialApp(home: ExportScreen(projectId: 'p')),
      ),
    );
    await tester.tap(find.text('Screenplay PDF (.pdf)'));
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 800)),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(name, 'The_Key.pdf');
    expect(latin1.decode(bytes!.take(4).toList()), '%PDF');
  });
}
