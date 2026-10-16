import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/permissions.dart';

http.Response ok(String text) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': text}
            ]
          }
        }
      ]
    }),
    200);

AiClient make(MockClient c,
        {String? stored, String define = ''}) =>
    AiClient(
      client: c,
      readStoredKey: () async => stored,
      dartDefineKey: define,
      retryStep: Duration.zero,
    );

void main() {
  const schema = {'type': 'OBJECT'};

  test('success parses JSON and sends key in header only', () async {
    late http.Request seen;
    final ai = make(MockClient((r) async {
      seen = r;
      return ok('{"a":1}');
    }), stored: 'fake-key');
    expect(await ai.generateJson(prompt: 'hi', schema: schema), {'a': 1});
    expect(seen.headers['x-goog-api-key'], 'fake-key');
    expect(seen.url.toString(), isNot(contains('fake-key')));
    expect(seen.url.path, contains(geminiModel));
  });

  test('429 then 200 retries and succeeds', () async {
    var n = 0;
    final ai = make(MockClient((r) async =>
        ++n == 1 ? http.Response('{}', 429) : ok('{"a":2}')), stored: 'k');
    expect(await ai.generateJson(prompt: 'hi', schema: schema), {'a': 2});
    expect(n, 2);
  });

  test('503 forever gives up after 4 tries with AiHttpError', () async {
    var n = 0;
    final ai = make(MockClient((r) async {
      n++;
      return http.Response('{}', 503);
    }), stored: 'k');
    await expectLater(ai.generateJson(prompt: 'hi', schema: schema),
        throwsA(isA<AiHttpError>().having((e) => e.status, 'status', 503)));
    expect(n, 4);
  });

  test('malformed JSON -> AiMalformedResponse', () async {
    final ai = make(MockClient((r) async => ok('not json')), stored: 'k');
    await expectLater(ai.generateJson(prompt: 'hi', schema: schema),
        throwsA(isA<AiMalformedResponse>()));
  });

  test('gated call with permission off never hits the network', () async {
    var n = 0;
    final ai = make(MockClient((r) async {
      n++;
      return ok('{}');
    }), stored: 'k');
    await expectLater(
        ai.generateJson(
            prompt: 'hi',
            schema: schema,
            gate: AiPermission.shotSuggestions,
            permissions: {'shot_suggestions': false}),
        throwsA(isA<AiPermissionDenied>()));
    await expectLater(
        ai.generateJson(
            prompt: 'hi', schema: schema, gate: AiPermission.internetFetch),
        throwsA(isA<AiPermissionDenied>())); // missing key = false
    expect(n, 0);
  });

  test('gated call with permission on goes through', () async {
    final ai = make(MockClient((r) async => ok('{"a":3}')), stored: 'k');
    expect(
        await ai.generateJson(
            prompt: 'hi',
            schema: schema,
            gate: AiPermission.autoSummary,
            permissions: {'auto_summary': true}),
        {'a': 3});
  });

  group('key lookup', () {
    Future<String?> keyUsed({String? stored, String define = ''}) async {
      String? k;
      final ai = make(MockClient((r) async {
        k = r.headers['x-goog-api-key'];
        return ok('{}');
      }), stored: stored, define: define);
      await ai.generateJson(prompt: 'hi', schema: schema);
      return k;
    }

    test('secure storage wins', () async {
      expect(await keyUsed(stored: 'stored', define: 'defined'), 'stored');
    });
    test('falls back to dart-define', () async {
      expect(await keyUsed(define: 'defined'), 'defined');
    });
    test('neither -> AiNoKey, no network', () async {
      await expectLater(keyUsed(), throwsA(isA<AiNoKey>()));
    });
  });

  group('daily-quota fallback (D-23)', () {
    final daily = http.Response(
        '{"error":{"details":[{"violations":[{"quotaId":'
        '"GenerateRequestsPerDayPerProjectPerModel-FreeTier"}]}]}}',
        429);

    test('daily 429 on flash goes straight to lite, no backoff on flash',
        () async {
      final paths = <String>[];
      final ai = make(MockClient((r) async {
        paths.add(r.url.path);
        return r.url.path.contains(geminiModelLite) ? ok('{"a":3}') : daily;
      }), stored: 'k');
      expect(await ai.generateJson(prompt: 'hi', schema: schema), {'a': 3});
      expect(paths.length, 2);
      expect(paths.first, contains('$geminiModel:'));
      expect(paths.last, contains('$geminiModelLite:'));
    });

    test('plain 429 keeps retrying on flash', () async {
      final paths = <String>[];
      final ai = make(MockClient((r) async {
        paths.add(r.url.path);
        return paths.length < 3 ? http.Response('{}', 429) : ok('{"a":4}');
      }), stored: 'k');
      expect(await ai.generateJson(prompt: 'hi', schema: schema), {'a': 4});
      expect(paths.every((p) => p.contains('$geminiModel:')), isTrue);
    });

    test('next call after fallback skips flash', () async {
      final paths = <String>[];
      final ai = make(MockClient((r) async {
        paths.add(r.url.path);
        return r.url.path.contains(geminiModelLite) ? ok('{}') : daily;
      }), stored: 'k');
      await ai.generateJson(prompt: 'hi', schema: schema);
      paths.clear();
      await ai.generateJson(prompt: 'hi', schema: schema);
      expect(paths, hasLength(1));
      expect(paths.single, contains('$geminiModelLite:'));
    });

    test('lite also daily-exhausted -> AiHttpError 429 quota message',
        () async {
      final ai = make(MockClient((r) async => daily), stored: 'k');
      await expectLater(
          ai.generateJson(prompt: 'hi', schema: schema),
          throwsA(isA<AiHttpError>()
              .having((e) => e.status, 'status', 429)
              .having((e) => e.message, 'message', contains("Today's free"))));
    });
  });
}
