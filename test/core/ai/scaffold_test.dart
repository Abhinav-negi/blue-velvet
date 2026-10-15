import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/remap.dart';
import 'package:lynch/core/ai/scaffold.dart';

/// Serves [replies] in order (last one repeats) and counts calls.
({AiClient ai, List<String> prompts}) fake(List<Map<String, dynamic>> replies) {
  final prompts = <String>[];
  final c = MockClient((r) async {
    final n = prompts.length;
    prompts.add(
      (jsonDecode(r.body)['contents'][0]['parts'][0]['text']) as String,
    );
    final reply = replies[n < replies.length ? n : replies.length - 1];
    return http.Response(
      jsonEncode({
        'candidates': [
          {
            'content': {
              'parts': [
                {'text': jsonEncode(reply)},
              ],
            },
          },
        ],
      }),
      200,
    );
  });
  return (
    ai: AiClient(
      client: c,
      readStoredKey: () async => 'k',
      retryStep: Duration.zero,
    ),
    prompts: prompts,
  );
}

const on = {'screenplay_scaffold': true, 'auto_placement': true};
const beat = {
  'id': 'b1',
  'title': 'The kid finds the key',
  'description': 'The Kid finds a rusty key in the Playground sandbox.',
  'character_names': ['Kid'],
  'project_type': 'short_film',
};

void main() {
  group('scaffold', () {
    test('valid film scaffold parses', () async {
      final f = fake([
        {
          'blocks': [
            {'type': 'scene_heading', 'text': 'EXT. PLAYGROUND'},
            {'type': 'action', 'text': 'The Kid kneels in the sandbox.'},
          ],
          'rows': [],
        },
      ]);
      final d = await scaffoldBeat(
        f.ai,
        beat: beat,
        facts: beat['description'] as String,
        permissions: on,
      );
      expect(d.blocks.length, 2);
      expect(d.ungrounded, isFalse);
    });

    test('dialogue element is rejected (retry once, then fail)', () async {
      final f = fake([
        {
          'blocks': [
            {'type': 'dialogue', 'text': 'Where did this come from?'},
          ],
          'rows': [],
        },
      ]);
      await expectLater(
        scaffoldBeat(f.ai, beat: beat, facts: 'x', permissions: on),
        throwsA(isA<AiMalformedResponse>()),
      );
      expect(f.prompts.length, 2);
      expect(f.prompts[1], contains('broke the rules'));
    });

    test('retry recovers when second reply is clean', () async {
      final f = fake([
        {
          'blocks': [
            {'type': 'character', 'text': 'KID'},
          ],
          'rows': [],
        },
        {
          'blocks': [
            {'type': 'action', 'text': 'The Kid kneels.'},
          ],
          'rows': [],
        },
      ]);
      final d = await scaffoldBeat(
        f.ai,
        beat: beat,
        facts: beat['description'] as String,
        permissions: on,
      );
      expect(d.blocks.single.type, 'action');
    });

    test('non-empty say is rejected for video types', () async {
      final f = fake([
        {
          'blocks': [],
          'rows': [
            {
              'say': 'Hello!',
              'show': {
                'a_roll': '',
                'b_roll': '',
                'on_screen_text': '',
                'graphics': '',
              },
            },
          ],
        },
      ]);
      await expectLater(
        scaffoldBeat(
          f.ai,
          beat: {...beat, 'project_type': 'youtube'},
          facts: 'x',
          permissions: on,
        ),
        throwsA(isA<AiMalformedResponse>()),
      );
    });

    test('invented proper noun is flagged ungrounded', () async {
      final f = fake([
        {
          'blocks': [
            {'type': 'action', 'text': 'The Kid meets Marcus.'},
          ],
          'rows': [],
        },
      ]);
      final d = await scaffoldBeat(
        f.ai,
        beat: beat,
        facts: beat['description'] as String,
        permissions: on,
      );
      expect(d.ungrounded, isTrue);
    });

    test('permission off: no network', () async {
      final f = fake([{}]);
      await expectLater(
        scaffoldBeat(f.ai, beat: beat, facts: 'x'),
        throwsA(isA<AiPermissionDenied>()),
      );
      expect(f.prompts, isEmpty);
    });
  });

  group('remap', () {
    final beats = [
      {'id': 'b1', 'title': 'A', 'description': 'a', 'current_slot_name': 'x'},
      {'id': 'b2', 'title': 'B', 'description': 'b', 'current_slot_name': 'y'},
    ];
    final tpl = {
      'slots': [
        {'slot_id': 's1', 'seed_id': 'three-act/act-1', 'name': 'Act 1'},
        {'slot_id': 's2', 'seed_id': null, 'name': 'Mine'},
      ],
    };

    test('returns a placement for every beat, unplaced allowed', () async {
      final f = fake([
        {
          'placements': [
            {'beat_id': 'b1', 'slot_seed_id': 'three-act/act-1', 'position': 0},
            {
              'beat_id': 'b2',
              'slot_seed_id': null,
              'slot_id': null,
              'position': 0,
            },
          ],
        },
      ]);
      final r = await remapTemplate(
        f.ai,
        beats: beats,
        newTemplate: tpl,
        permissions: on,
      );
      expect(r.map((p) => p.beatId), ['b1', 'b2']);
      expect(r[1].slotSeedId, isNull);
    });

    test('dropped beat is rejected, never accepted', () async {
      final f = fake([
        {
          'placements': [
            {'beat_id': 'b1', 'slot_id': 's2', 'position': 0},
          ],
        },
      ]);
      await expectLater(
        remapTemplate(f.ai, beats: beats, newTemplate: tpl, permissions: on),
        throwsA(isA<AiMalformedResponse>()),
      );
      expect(f.prompts.length, 2);
    });

    test('unknown slot id is rejected', () async {
      final f = fake([
        {
          'placements': [
            {'beat_id': 'b1', 'slot_id': 'nope', 'position': 0},
            {'beat_id': 'b2', 'position': 0},
          ],
        },
      ]);
      await expectLater(
        remapTemplate(f.ai, beats: beats, newTemplate: tpl, permissions: on),
        throwsA(isA<AiMalformedResponse>()),
      );
    });
  });

  group('suggestStructure', () {
    test(
      'results are flagged suggestions, not ops, and need no gate',
      () async {
        final f = fake([
          {
            'suggestions': [
              {'label': 'Open on the key', 'idea': 'Start on the key first.'},
            ],
          },
        ]);
        final r = await suggestStructure(
          f.ai,
          beat: beat,
          projectContext: {},
          question: 'other ways to open?',
        );
        expect(r.single.isSuggestion, isTrue);
        expect(r.single, isA<StructureSuggestion>());
        expect(r.single.label, 'Open on the key');
      },
    );
  });
}
