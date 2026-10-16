import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/export/export_screen.dart';
import 'package:lynch/features/export/fountain.dart';

Map<String, dynamic> b(String type, String text) => {
  'id': type,
  'type': type,
  'text': text,
  'scaffold': false,
  'ai_suggested': false,
};

final fixture = [
  b('scene_heading', 'ext. playground - day'),
  b('action', 'A KID kneels in the sandbox.'),
  b('character', 'Watchman'),
  b('parenthetical', 'gruff'),
  b('dialogue', 'Nobody sleeps here, kid.'),
  b('transition', 'cut to:'),
  b('scene_heading', 'The shed'),
  b('action', ''),
  b('transition', 'Fade out'),
];

const expected = '''Title: The Key

EXT. PLAYGROUND - DAY

A KID kneels in the sandbox.

WATCHMAN
(gruff)
Nobody sleeps here, kid.

CUT TO:

.THE SHED

> FADE OUT
''';

void main() {
  test('every element type exports exactly', () {
    expect(
      toFountain('The Key', [fixture.sublist(0, 5), fixture.sublist(5)]),
      expected,
    );
  });

  testWidgets('export shares a .fountain file', (tester) async {
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
          blocks: Value(fixture.sublist(0, 2)),
          createdAt: 1,
          updatedAt: 1,
        ),
      );
    });
    String? name, content;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          shareFileProvider.overrideWithValue((n, c) async {
            name = n;
            content = c;
          }),
        ],
        child: const MaterialApp(home: ExportScreen(projectId: 'p')),
      ),
    );
    await tester.tap(find.text('Fountain (.fountain)'));
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(name, 'The_Key.fountain');
    expect(content, startsWith('Title: The Key\n\nEXT. PLAYGROUND - DAY'));
  });
}
