import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/shots/fetch_screen.dart';

http.Response gemini(Object o) => http.Response(
  jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': jsonEncode(o)},
          ],
        },
      },
    ],
  }),
  200,
);

const src = {'title': 'Dolly zoom', 'url': 'https://en.wikipedia.org/d'};
final shotReply = {
  'result': 'shot',
  'sources': [src],
  'shot': {
    'name': 'Dolly zoom',
    'category': 'movement',
    'description': 'Push in, zoom out',
    'when_to_use': 'w',
    'effect': 'e',
    'tags': <String>[],
    'image_candidates': <Object>[],
  },
};

void main() {
  late AppDatabase db;
  late List<Uri> calls;

  AiClient fake(Map<String, Object> reply) {
    calls = [];
    return AiClient(
      readStoredKey: () async => 'k',
      client: MockClient((req) async {
        calls.add(req.url);
        if (req.url.host == 'generativelanguage.googleapis.com') {
          return gemini(reply);
        }
        if (req.url.host == 'en.wikipedia.org') {
          return http.Response(
            jsonEncode({
              'query': {
                'pages': {
                  '1': {
                    'title': 'Dolly zoom',
                    'fullurl': 'https://en.wikipedia.org/d',
                    'extract': 'text',
                  },
                },
              },
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      }),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    AiClient ai,
    Map<String, dynamic> perms,
  ) async {
    db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          aiClientProvider.overrideWithValue(ai),
        ],
        child: MaterialApp(home: FetchScreen(permissions: perms)),
      ),
    );
  }

  Future<void> fetch(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).first, 'dolly zoom');
    await tester.tap(find.text('Fetch'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }

  Future<int> shotCount(WidgetTester tester) async =>
      (await tester.runAsync(() => db.select(db.shots).get()))!.length;

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  const on = {'internet_fetch': true};

  testWidgets('preview shows sources; Save adds to library', (tester) async {
    await pump(tester, fake(shotReply), on);
    await fetch(tester);
    expect(find.text('Dolly zoom'), findsOneWidget);
    expect(find.textContaining('https://en.wikipedia.org/d'), findsOneWidget);
    expect(await shotCount(tester), 0);
    await tester.tap(find.text('Save'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    final rows = (await tester.runAsync(() => db.select(db.shots).get()))!;
    expect(rows.single.name, 'Dolly zoom');
    expect(rows.single.builtin, isFalse);
    expect(rows.single.sources.first['url'], 'https://en.wikipedia.org/d');
    expect(find.text('Saved to your library.'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('Cancel adds nothing', (tester) async {
    await pump(tester, fake(shotReply), on);
    await fetch(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(find.text('Save'), findsNothing);
    expect(await shotCount(tester), 0);
    await finish(tester);
  });

  testWidgets('cannotConvert explains and saves nothing', (tester) async {
    await pump(
      tester,
      fake({
        'result': 'cannot_convert',
        'sources': [src],
        'reason': 'Not a film technique',
      }),
      on,
    );
    await fetch(tester);
    expect(find.textContaining('Not a film technique'), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    expect(await shotCount(tester), 0);
    await finish(tester);
  });

  testWidgets('with Internet fetch off the action is disabled', (tester) async {
    final ai = fake(shotReply);
    await pump(tester, ai, const {});
    expect(find.textContaining('Internet fetch is off'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(calls, isEmpty);
    await finish(tester);
  });
}
