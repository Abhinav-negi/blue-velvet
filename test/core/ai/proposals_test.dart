import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/ai/words_check.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/proposal_engine.dart';

const t0 = 1760500000000;
const allOn = {
  'auto_summary': true,
  'character_extraction': true,
  'beat_generation': true,
  'auto_placement': true,
  'screenplay_scaffold': true,
  'grammar_cleanup': false,
};

http.Response ok(Object json) => http.Response(
  jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': jsonEncode(json)},
          ],
        },
      },
    ],
  }),
  200,
);

/// Client that answers with [responses] in order and records request bodies.
({AiClient ai, List<Map<String, dynamic>> sent}) fake(List<Object> responses) {
  final sent = <Map<String, dynamic>>[];
  var i = 0;
  final c = MockClient((req) async {
    sent.add(jsonDecode(req.body));
    return ok(responses[i < responses.length ? i++ : i - 1]);
  });
  return (
    ai: AiClient(
      client: c,
      readStoredKey: () async => 'k',
      retryStep: Duration.zero,
    ),
    sent: sent,
  );
}

Map<String, dynamic> fx(String n) =>
    jsonDecode(File('test/fixtures/ai/proposals/$n.json').readAsStringSync());

const slots = [
  {'slot_id': 's-open', 'seed_id': 'five-point/opening', 'name': 'Opening'},
  {
    'slot_id': 's-inc',
    'seed_id': 'five-point/inciting-moment',
    'name': 'Inciting moment',
  },
];
final context = {
  'project': {'title': 'The Key', 'type': 'short_film', 'summary': 'old'},
  'template': {'id': 'tp', 'name': 'Five-point', 'slots': slots},
  'beats': [
    {'id': 'b-old', 'slot_id': 's-open', 'title': 'Start', 'description': ''},
  ],
  'characters': [
    {'project_character_id': 'pc1', 'name': 'Kid'},
  ],
};

String bodyText(Map<String, dynamic> sent) =>
    sent['contents'][0]['parts'][0]['text'];
List opEnum(Map<String, dynamic> sent) =>
    sent['generationConfig']['responseSchema']['properties']['changes']['items']['properties']['op']['enum'];

void main() {
  late AppDatabase db;
  late ProposalEngine eng;
  var n = 0;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    n = 0;
    eng = ProposalEngine(db, clock: () => t0, newId: () => 'id${++n}');
    await db
        .into(db.templates)
        .insert(
          TemplatesCompanion.insert(
            id: 'tp',
            name: 'T',
            description: '',
            projectTypes: [],
            createdAt: t0,
            updatedAt: t0,
            seedId: const Value('five-point'),
          ),
        );
    for (final s in [
      ('s-open', 'five-point/opening', 0),
      ('s-inc', 'five-point/inciting-moment', 1),
    ]) {
      await db
          .into(db.slots)
          .insert(
            SlotsCompanion.insert(
              id: s.$1,
              templateId: 'tp',
              position: s.$3,
              name: s.$1,
              description: '',
              createdAt: t0,
              updatedAt: t0,
              seedId: Value(s.$2),
            ),
          );
    }
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'p',
        title: 'P',
        type: ProjectType.shortFilm,
        summary: 'old',
        aspectRatio: '16:9',
        typeFields: {},
        aiPermissions: {},
        templateId: const Value('tp'),
        createdAt: t0,
        updatedAt: t0,
      ),
    );
    await db
        .into(db.characters)
        .insert(
          CharactersCompanion.insert(
            id: 'g1',
            name: 'Kid',
            role: '',
            appearance: '',
            background: '',
            traits: '',
            habits: '',
            wantsNeedsFears: '',
            notes: '',
            createdAt: t0,
            updatedAt: t0,
          ),
        );
    await db
        .into(db.projectCharacters)
        .insert(
          ProjectCharactersCompanion.insert(
            id: 'pc1',
            projectId: 'p',
            mode: CharacterMode.linked,
            characterId: const Value('g1'),
            createdAt: t0,
            updatedAt: t0,
          ),
        );
    await db
        .into(db.beats)
        .insert(
          BeatsCompanion.insert(
            id: 'b-old',
            projectId: 'p',
            position: 0,
            title: 'Start',
            description: '',
            characterIds: [],
            slotId: const Value('s-open'),
            blocks: const Value([]),
            createdAt: t0,
            updatedAt: t0,
          ),
        );
  });
  tearDown(() => db.close());

  Future<List<String>> approve(List<Map<String, dynamic>> changes) async {
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: 'pr',
            projectId: 'p',
            status: ProposalStatus.pending,
            summary: 's',
            rawTranscript: '',
            summarySpans: [],
            changes: changes,
            createdAt: t0,
            updatedAt: t0,
          ),
        );
    return eng.approve('pr');
  }

  test('buildProposal fixture parses and the engine applies it', () async {
    final f = fx('build');
    final raw = f['raw_transcript'] as String;
    final c = fake([f['response']]);
    final d = await buildProposal(
      c.ai,
      rawTranscript: raw,
      context: context,
      permissions: allOn,
    );
    expect(d.spans, isNotEmpty);
    expect(wordsCheck(d.summary, raw), isEmpty);
    expect(d.changes.map((o) => o['op']), [
      'editCharacter',
      'addCharacter',
      'addBeat',
      'addScaffold',
      'setSummary',
    ]);
    expect(d.changes.every((o) => o['accepted'] == true), isTrue);
    expect(d.changes.every((o) => o['id'] is String), isTrue);
    await approve(d.changes);
    final beats = await db.select(db.beats).get();
    expect(beats.map((b) => b.title), contains('The watchman notices'));
    final nb = beats.firstWhere((b) => b.title == 'The watchman notices');
    expect(nb.blocks, hasLength(2));
    expect(nb.slotId, 's-inc');
  });

  test('generateProject fixture parses and the engine applies it', () async {
    final f = fx('generate');
    final c = fake([f['response']]);
    final d = await generateProject(
      c.ai,
      summary: f['summary'],
      rawTranscript: f['raw_transcript'],
      projectType: 'short_film',
      template: {'id': 'tp', 'name': 'T', 'slots': slots},
      permissions: allOn,
    );
    expect(d.title, isNull);
    expect(d.changes, hasLength(5));
    expect(d.changes.every((o) => o['accepted'] == true), isTrue);
    await approve(d.changes);
    final p = await (db.select(
      db.projects,
    )..where((t) => t.id.equals('p'))).getSingle();
    expect(p.summary, startsWith('A kid finds'));
  });

  test(
    'character extraction off: not requested, and dropped if returned',
    () async {
      final f = fx('build');
      final c = fake([f['response']]);
      final perms = {...allOn, 'character_extraction': false};
      final d = await buildProposal(
        c.ai,
        rawTranscript: f['raw_transcript'],
        context: context,
        permissions: perms,
      );
      expect(opEnum(c.sent.first), isNot(contains('addCharacter')));
      expect(opEnum(c.sent.first), isNot(contains('editCharacter')));
      expect(d.changes.map((o) => o['op']), isNot(contains('addCharacter')));
      expect(d.changes.map((o) => o['op']), isNot(contains('editCharacter')));
      expect(d.notes, hasLength(2));
      // Watchman is not an existing character, so it is no longer named.
      final beat = d.changes.firstWhere((o) => o['op'] == 'addBeat');
      expect(beat['character_names'], ['Kid']);

      final g = fx('generate');
      final c2 = fake([g['response']]);
      final gd = await generateProject(
        c2.ai,
        summary: g['summary'],
        rawTranscript: g['raw_transcript'],
        projectType: 'short_film',
        template: null,
        permissions: perms,
      );
      expect(opEnum(c2.sent.first), isNot(contains('addCharacter')));
      expect(gd.changes.map((o) => o['op']), isNot(contains('addCharacter')));
    },
  );

  test('beat generation off drops addBeat and the scaffold on it', () async {
    final f = fx('build');
    final c = fake([f['response']]);
    final d = await buildProposal(
      c.ai,
      rawTranscript: f['raw_transcript'],
      context: context,
      permissions: {...allOn, 'beat_generation': false},
    );
    expect(d.changes.map((o) => o['op']), isNot(contains('addBeat')));
    expect(d.changes.map((o) => o['op']), isNot(contains('addScaffold')));
  });

  test('auto placement off strips slot fields', () async {
    final f = fx('build');
    final c = fake([f['response']]);
    final d = await buildProposal(
      c.ai,
      rawTranscript: f['raw_transcript'],
      context: context,
      permissions: {...allOn, 'auto_placement': false},
    );
    final beat = d.changes.firstWhere((o) => o['op'] == 'addBeat');
    expect(beat.containsKey('slot_seed_id'), isFalse);
  });

  test('ungrounded op defaults accepted to false', () async {
    final f = fx('build');
    final r = jsonDecode(jsonEncode(f['response'])) as Map<String, dynamic>;
    (r['changes'] as List)[3]['blocks'][0]['text'] = 'EXT. PLAYGROUND - DAY';
    final d = await buildProposal(
      fake([r]).ai,
      rawTranscript: f['raw_transcript'],
      context: context,
      permissions: allOn,
    );
    expect(
      d.changes.firstWhere((o) => o['op'] == 'addScaffold')['accepted'],
      isFalse,
    );
    expect(
      d.changes.firstWhere((o) => o['op'] == 'addBeat')['accepted'],
      isTrue,
    );
  });

  test(
    'dialogue block is rejected, retry note is sent, then it fails',
    () async {
      final f = fx('build');
      final r = {
        'summary_sentences': [],
        'changes': [
          {'op': 'addBeat', 'ref': 'b1', 'title': 'x'},
          {
            'op': 'addScaffold',
            'beat_ref': 'b1',
            'blocks': [
              {'type': 'dialogue', 'text': 'Hi.'},
            ],
          },
        ],
      };
      final c = fake([r]);
      await expectLater(
        buildProposal(
          c.ai,
          rawTranscript: f['raw_transcript'],
          context: context,
          permissions: allOn,
        ),
        throwsA(isA<AiMalformedResponse>()),
      );
      expect(c.sent, hasLength(2));
      expect(bodyText(c.sent[1]), contains('Your last output broke rule 5'));
    },
  );

  test('bad reference retries once and recovers', () async {
    final f = fx('build');
    final bad = {
      'summary_sentences': [],
      'changes': [
        {'op': 'editBeat', 'beat_id': 'nope', 'title': 'x'},
      ],
    };
    final c = fake([bad, f['response']]);
    final d = await buildProposal(
      c.ai,
      rawTranscript: f['raw_transcript'],
      context: context,
      permissions: allOn,
    );
    expect(c.sent, hasLength(2));
    expect(d.changes, isNotEmpty);
  });

  test('quoted text the user never said is rejected', () async {
    final r = {
      'summary_sentences': [],
      'changes': [
        {
          'op': 'addCharacter',
          'name': 'Kid',
          'fields': {'habits': 'says "never again"'},
        },
      ],
    };
    await expectLater(
      buildProposal(
        fake([r]).ai,
        rawTranscript: 'a kid',
        context: context,
        permissions: allOn,
      ),
      throwsA(isA<AiMalformedResponse>()),
    );
  });

  test('reviseProposal keeps ids and flags, and removes omitted ops', () async {
    final f = fx('revise');
    final proposal = f['proposal'] as Map<String, dynamic>;
    final c = fake([f['response']]);
    final d = await reviseProposal(
      c.ai,
      proposal: proposal,
      instruction: f['instruction'],
      context: context,
      permissions: allOn,
    );
    expect(d.changes.map((o) => o['id']), ['op-beat', 'op-sum']);
    expect(d.changes[1]['accepted'], isFalse); // user's earlier choice kept
    expect(bodyText(c.sent.first), isNot(contains('"accepted"')));
    // the id field is part of the revise schema only
    expect(
      c
          .sent
          .first['generationConfig']['responseSchema']['properties']['changes']['items']['properties'],
      contains('id'),
    );
  });

  group('detectProjectMention', () {
    final f = fx('detect');
    for (final k in f['cases'] as List) {
      test(k['name'], () async {
        final d = await detectProjectMention(
          fake([k['response']]).ai,
          rawTranscript: k['raw'],
          projects: (f['projects'] as List).cast<Map<String, dynamic>>(),
        );
        expect(d?.projectId, k['expect']);
      });
    }
    test('no projects: no call', () async {
      final c = fake([{}]);
      expect(
        await detectProjectMention(c.ai, rawTranscript: 'x', projects: []),
        isNull,
      );
      expect(c.sent, isEmpty);
    });
  });
}
