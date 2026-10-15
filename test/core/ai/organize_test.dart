import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/organize.dart';
import 'package:lynch/core/ai/words_check.dart';

http.Response ok(Object json) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': jsonEncode(json)}
            ]
          }
        }
      ]
    }),
    200);

AiClient make(MockClient c) => AiClient(
    client: c, readStoredKey: () async => 'k', retryStep: Duration.zero);

Map<String, dynamic> fixture(String type) => jsonDecode(
    File('test/fixtures/ai/organize/$type.json').readAsStringSync());

void main() {
  group('organize: one recorded response per item type', () {
    for (final type in itemTypes) {
      test(type, () async {
        final f = fixture(type);
        final raw = f['raw_transcript'] as String;
        final ai = make(MockClient((_) async => ok(f['response'])));
        final d = await organize(ai, raw);
        expect(d.type, type);
        expect(d.summary, isNotEmpty);
        expect(d.spans, isNotEmpty);
        for (final s in d.spans) {
          expect(s.start, lessThan(s.end));
          expect(raw.substring(s.start, s.end), isNotEmpty);
        }
        expect(wordsCheck(d.summary, raw), isEmpty);
      });
    }
  });

  test('worked example from AI_CONTRACT 2.3 gives the documented offsets', () {
    const raw =
        "Okay so um there's this kid, like eight years old, and he finds a rusty key in the sandbox. Um, and the watchman, the old guy who never sleeps, he sees him.";
    final spans = computeSpans(raw, [
      ["there's this kid, like eight years old, and he finds a rusty key in the sandbox"],
      ['the old guy who never sleeps', 'he sees him'],
    ]);
    expect(spans, const [
      SummarySpan(0, 11, 90),
      SummarySpan(1, 114, 142),
      SummarySpan(1, 144, 155),
    ]);
  });

  test('span falls back to normalised match, drops unlocatable quotes', () {
    const raw = 'He said  “Hello”\nthere.';
    final spans = computeSpans(raw, [
      ['HELLO" there'],
      ['not in the text'],
    ]);
    expect(spans.length, 1);
    expect(raw.substring(spans[0].start, spans[0].end), 'Hello”\nthere');
  });

  test('invented dialogue line is rejected after one retry', () async {
    final f = fixture('dialogue');
    final bad = jsonDecode(jsonEncode(f['response']));
    bad['structure']['lines'][0]['text'] = 'Go home, boy.';
    var n = 0;
    final ai = make(MockClient((_) async {
      n++;
      return ok(bad);
    }));
    await expectLater(organize(ai, f['raw_transcript']),
        throwsA(isA<AiMalformedResponse>()));
    expect(n, 2);
  });

  test('retry succeeds when second answer is valid, note is in the prompt',
      () async {
    final f = fixture('dialogue');
    final bad = jsonDecode(jsonEncode(f['response']));
    bad['structure']['lines'][0]['text'] = 'Go home, boy.';
    final prompts = <String>[];
    final ai = make(MockClient((r) async {
      prompts.add(r.body);
      return ok(prompts.length == 1 ? bad : f['response']);
    }));
    final d = await organize(ai, f['raw_transcript']);
    expect(d.type, 'dialogue');
    expect(prompts.last, contains('Your last output broke rule 2'));
  });

  test('sentence count mismatch keeps summary, drops spans', () async {
    final f = fixture('story_idea');
    final r = jsonDecode(jsonEncode(f['response']));
    r['summary_sentences'][0]['text'] = 'A kid finds a key. He is eight.';
    final d = await organize(
        make(MockClient((_) async => ok(r))), f['raw_transcript']);
    expect(d.spans, isEmpty);
    expect(d.summary, contains('He is eight.'));
  });

  group('editItem', () {
    final f = fixture('story_idea');
    final raw = f['raw_transcript'] as String;
    Future<ItemEdit> run(Map<String, dynamic> resp) => editItem(
          make(MockClient((_) async => ok(resp))),
          type: 'story_idea',
          summary: 'x',
          rawTranscript: raw,
          structure: {},
          tags: [],
          instruction: 'remove the watchman part',
        );

    test('item_patch returns a draft with spans', () async {
      final r = jsonDecode(jsonEncode(f['response']));
      r['summary_sentences'].removeAt(1);
      final e = await run({'outcome': 'item_patch', 'item': r});
      expect(e.item!.summary,
          "There's a kid, about eight years old, who finds a rusty key in the sandbox.");
      expect(e.item!.spans.length, 1);
    });

    test('cannot_do carries the note', () async {
      final e = await run({'outcome': 'cannot_do', 'note': 'Needs new content'});
      expect(e.item, isNull);
      expect(e.note, 'Needs new content');
    });
  });

  group('wordsCheck', () {
    const transcript =
        "there's a kid, eight years old, finds a key. The old watchman sees him";
    test('flags a capitalised name absent from the transcript', () {
      expect(
          wordsCheck('The kid finds a key. Then Marcus sees him.', transcript),
          ['Marcus']);
    });
    test('passes a clean summary', () {
      expect(
          wordsCheck('A kid, 8, finds a key. The watchman sees him.', transcript),
          isEmpty);
    });
    test('flags an absent number and an absent quote', () {
      expect(wordsCheck('The kid is 9.', transcript), ['9']);
      expect(wordsCheck('He says "run away".', transcript), ['"run away"']);
    });
  });
}
