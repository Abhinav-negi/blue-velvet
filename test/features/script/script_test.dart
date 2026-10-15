import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/script/screenplay_format.dart';
import 'package:lynch/features/script/script_screen.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  test('Enter and Tab follow the element order', () {
    expect(nextOnEnter('scene_heading'), 'action');
    expect(nextOnEnter('action'), 'character');
    expect(nextOnEnter('character'), 'dialogue');
    expect(nextOnEnter('dialogue'), 'parenthetical');
    expect(nextOnEnter('parenthetical'), 'dialogue');
    expect(nextOnEnter('transition'), 'scene_heading');
    expect(nextOnTab('scene_heading'), 'action');
    expect(nextOnTab('parenthetical'), 'transition');
    expect(nextOnTab('transition'), 'scene_heading');
  });

  group('editor', () {
    late AppDatabase db;
    setUpAll(() async {
      await loadFont('CourierPrime', 'assets/fonts/CourierPrime-Regular.ttf');
      await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    });
    setUp(() => db = AppDatabase(NativeDatabase.memory()));

    Future<void> pump(
      WidgetTester tester,
      List<Map<String, dynamic>>? blocks,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.runAsync(() async {
        await db.projectsDao.upsert(
          ProjectsCompanion.insert(
            id: 'p',
            title: 'P',
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
            id: 'b',
            projectId: 'p',
            position: 0,
            title: 'Opening',
            description: '',
            characterIds: const [],
            blocks: Value(blocks),
            createdAt: 1,
            updatedAt: 1,
          ),
        );
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dbProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: ThemeData(extensions: const [PaperColors()]),
            home: const Scaffold(body: ScriptScreen(projectId: 'p')),
          ),
        ),
      );
      // Beats stream, then the seed asset: real async, then rebuild.
      await tester.runAsync(
        () =>
            ProviderScope.containerOf(tester.element(find.byType(ScriptScreen)))
                .read(screenplayFormatProvider.future),
      );
      await tester.pumpAndSettle();
    }

    Future<void> finish(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      await tester.runAsync(db.close);
    }

    Future<List<dynamic>?> saved(WidgetTester tester) async {
      final beats = await tester.runAsync(
        () => db.beatsDao.watchForProject('p').first,
      );
      return beats!.single.blocks;
    }

    testWidgets('typing, Enter and Tab are saved as blocks', (tester) async {
      await pump(tester, null);
      expect(find.text('Script'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'int. kitchen - night\n');
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).last, 'Maya enters.');
      await tester.pumpAndSettle();
      // Tab turns the focused block into the next type.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final blocks = await saved(tester);
      expect(
        [for (final b in blocks!) b['type']],
        ['scene_heading', 'character'],
      );
      expect(blocks[0]['text'], 'INT. KITCHEN - NIGHT');
      expect(blocks[1]['text'], 'MAYA ENTERS.');
      await finish(tester);
    });

    testWidgets('tapping the chip changes the element type', (tester) async {
      await pump(tester, [
        {
          'id': 'x',
          'type': 'action',
          'text': 'Rain.',
          'scaffold': false,
          'ai_suggested': false,
        },
      ]);
      expect(find.text('Action'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('chip-x')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Transition'));
      await tester.pumpAndSettle();
      expect(find.text('Transition'), findsOneWidget);
      expect((await saved(tester))![0]['type'], 'transition');
      await finish(tester);
    });

    testWidgets('scene screenshot', (tester) async {
      final b = [
        for (final (i, e) in [
          ('scene_heading', 'EXT. PLAYGROUND - DAY'),
          (
            'action',
            'A KID, 8, kneels in the sandbox. A WATCHMAN stands nearby.',
          ),
          ('character', 'WATCHMAN'),
          ('parenthetical', '(quietly)'),
          ('dialogue', 'Nobody sleeps here, kid.'),
          ('transition', 'CUT TO:'),
        ].indexed)
          {
            'id': 'b$i',
            'type': e.$1,
            'text': e.$2,
            'scaffold': false,
            'ai_suggested': false,
          },
      ];
      await pump(tester, b);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/scene.png'),
      );
      await finish(tester);
    });
  });
}
