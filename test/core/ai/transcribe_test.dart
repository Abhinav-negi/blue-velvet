import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/transcribe.dart';

http.Response ok(String t) => http.Response(
  jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {
              'text': jsonEncode({'transcript': t}),
            },
          ],
        },
      },
    ],
  }),
  200,
);

AiClient make(MockClient c) => AiClient(
  client: c,
  readStoredKey: () async => 'k',
  dartDefineKey: '',
  retryStep: Duration.zero,
);

Map inline(http.Request r) =>
    (jsonDecode(r.body)['contents'][0]['parts'] as List)[1]['inlineData'];

void main() {
  test('request carries mime type and base64 body; reply parses', () async {
    late http.Request seen;
    final audio = Uint8List.fromList([1, 2, 3, 4]);
    final t = await transcribe(
      make(
        MockClient((r) async {
          seen = r;
          return ok(' um hello ');
        }),
      ),
      audio,
      mimeType: 'audio/wav',
    );
    expect(t, 'um hello');
    expect(inline(seen)['mimeType'], 'audio/wav');
    expect(inline(seen)['data'], base64Encode(audio));
  });

  test('audio over the limit is chunked and joined in order', () async {
    final bodies = <String>[];
    final audio = Uint8List.fromList(List.generate(10, (i) => i));
    final t = await transcribe(
      make(
        MockClient((r) async {
          bodies.add(inline(r)['data'] as String);
          return ok('part${bodies.length}');
        }),
      ),
      audio,
      maxChunkBytes: 4,
    );
    expect(t, 'part1 part2 part3');
    expect(bodies, [
      base64Encode([0, 1, 2, 3]),
      base64Encode([4, 5, 6, 7]),
      base64Encode([8, 9]),
    ]);
  });

  test('default limit keeps base64 request under 20 MB', () {
    expect(maxInlineAudioBytes * 4 / 3, lessThan(20 * 1024 * 1024));
  });

  test('empty transcript is "nothing heard"', () {
    expect(
      transcribe(make(MockClient((r) async => ok('  '))), Uint8List(3)),
      throwsA(isA<AiMalformedResponse>()),
    );
  });
}
