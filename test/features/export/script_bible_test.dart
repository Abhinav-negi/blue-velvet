import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/tables.dart';
import 'package:lynch/features/export/bible_pdf.dart';
import 'package:lynch/features/export/script_pdf.dart';

ByteData font(String n) =>
    ByteData.sublistView(File('assets/fonts/$n').readAsBytesSync());

int pages(List<int> b) =>
    RegExp(r'/Type/Page/').allMatches(latin1.decode(b)).length;

void main() {
  test('script model keeps filled rows and fields only', () {
    final m = ScriptModel.from(' Vid ', [
      [
        {
          'say': 'Hello.',
          'show': {'a_roll': 'Me', 'b_roll': '', 'graphics': 'Logo'},
        },
        {'say': ' ', 'show': {}},
      ],
    ]);
    expect(m.rows.length, 1);
    expect(m.rows.single.show, [('A-roll', 'Me'), ('Graphics', 'Logo')]);
  });

  test(
    'bible includes every non-empty field of every project character',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.projectsDao.upsert(
        ProjectsCompanion.insert(
          id: 'p',
          title: 'The Key',
          type: ProjectType.shortFilm,
          summary: 'A kid finds a key.',
          aspectRatio: '16:9',
          typeFields: const {},
          aiPermissions: const {},
          createdAt: 1,
          updatedAt: 1,
        ),
      );
      await db
          .into(db.characters)
          .insert(
            CharactersCompanion.insert(
              id: 'c1',
              name: 'Kid',
              age: const Value('8'),
              role: 'Lead',
              appearance: 'Small',
              background: '',
              traits: 'Curious',
              habits: 'Digs',
              wantsNeedsFears: 'Fears the watchman',
              notes: '',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await db
          .into(db.projectCharacters)
          .insert(
            ProjectCharactersCompanion.insert(
              id: 'm1',
              projectId: 'p',
              characterId: const Value('c1'),
              mode: CharacterMode.linked,
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      // Forked member whose own values override its origin's.
      await db
          .into(db.projectCharacters)
          .insert(
            ProjectCharactersCompanion.insert(
              id: 'm2',
              projectId: 'p',
              characterId: const Value('c1'),
              mode: CharacterMode.forked,
              name: const Value('Older Kid'),
              age: const Value('12'),
              notes: const Value('Forked note'),
              createdAt: 2,
              updatedAt: 2,
            ),
          );
      final m = (await BibleModel.load(db, 'p'))!;
      expect(m.summary, 'A kid finds a key.');
      expect(m.characters.length, 2);
      final text = m.characters
          .map(
            (c) => [
              c.name,
              for (final f in c.fields) ...[f.$1, f.$2],
            ],
          )
          .toList();
      expect(text[0], [
        'Kid',
        'Age',
        '8',
        'Role in story',
        'Lead',
        'Appearance',
        'Small',
        'Personality traits',
        'Curious',
        'Habits',
        'Digs',
        'Wants / needs / fears',
        'Fears the watchman',
      ]);
      expect(m.characters[1].name, 'Older Kid');
      expect(m.characters[1].fields.firstWhere((f) => f.$1 == 'Age').$2, '12');
      expect(
        m.characters[1].fields.firstWhere((f) => f.$1 == 'Notes').$2,
        'Forked note',
      );
      expect(
        m.characters[1].fields.firstWhere((f) => f.$1 == 'Habits').$2,
        'Digs',
      );
      final bytes = await biblePdf(
        m,
        font('Literata-VF.ttf'),
        font('Inter-VF.ttf'),
      );
      expect(latin1.decode(bytes.take(4).toList()), '%PDF');
    },
  );

  test('sample PDFs written to build/', () async {
    final doc = jsonDecode(
      File('assets/seed/sample_project.json').readAsStringSync(),
    );
    final p = doc['project'] as Map;
    final chars = [
      for (final c in doc['characters'] as List)
        <String?>[
          c['name'],
          c['age'],
          c['role'],
          c['appearance'],
          c['background'],
          c['traits'],
          c['habits'],
          c['wants_needs_fears'],
          c['notes'],
        ],
    ];
    final bible = BibleModel.from(p['title'], p['summary'], chars);
    for (final c in bible.characters) {
      final all = [for (final f in c.fields) f.$2, c.name];
      expect(all.length, greaterThan(1));
    }
    // Sample is a screenplay, so the script PDF uses a small Say/Show fixture.
    final script = ScriptModel.from('Key hunt', [
      [
        for (var i = 0; i < 12; i++)
          {
            'say': 'I found a rusty key in a sandbox. ' * 3,
            'show': {
              'a_roll': 'Me to camera',
              'b_roll': 'Close-up of the key',
              'on_screen_text': 'Day $i',
              'graphics': '',
            },
          },
      ],
    ]);
    final sBytes = await scriptPdf(
      script,
      font('Literata-VF.ttf'),
      font('Inter-VF.ttf'),
    );
    final bBytes = await biblePdf(
      bible,
      font('Literata-VF.ttf'),
      font('Inter-VF.ttf'),
    );
    Directory('build').createSync();
    File('build/exp04_script.pdf').writeAsBytesSync(sBytes);
    File('build/exp04_bible.pdf').writeAsBytesSync(bBytes);
    // ignore: avoid_print
    print('PAGES script=${pages(sBytes)} bible=${pages(bBytes)}');
    expect(pages(sBytes), greaterThan(0));
    expect(pages(bBytes), greaterThan(0));
  });
}
