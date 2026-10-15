import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/shots/shot_options.dart';

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

void main() {
  late AppDatabase db;
  late List<Uri> calls;
  late AiClient ai;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    calls = [];
    ai = AiClient(
      readStoredKey: () async => 'k',
      client: MockClient((req) async {
        calls.add(req.url);
        if (req.url.host == 'generativelanguage.googleapis.com') {
          final body = req.body;
          if (body.contains('QUESTION:')) {
            return gemini({
              'options': [
                {'shot_id': 'a', 'why': 'Tight on the eyes'},
              ],
              'wants_fetch': ['standoff shot'],
            });
          }
          return gemini({
            'result': 'shot',
            'sources': [
              {'title': 'Standoff', 'url': 'https://en.wikipedia.org/s'},
            ],
            'shot': {
              'name': 'Mexican standoff',
              'category': 'composition',
              'description': 'Three-way framing',
              'when_to_use': 'w',
              'effect': 'e',
              'tags': <String>[],
              'image_candidates': <Object>[],
            },
          });
        }
        if (req.url.host == 'en.wikipedia.org') {
          return http.Response(
            jsonEncode({
              'query': {
                'pages': {
                  '1': {
                    'title': 'Standoff',
                    'fullurl': 'https://en.wikipedia.org/s',
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
  });

  Future<void> pump(WidgetTester tester, Map<String, dynamic> perms) async {
    await tester.runAsync(
      () => db
          .into(db.shots)
          .insert(
            ShotsCompanion.insert(
              id: 'a',
              name: 'Close-up',
              category: ShotCategory.size,
              description: 'd',
              whenToUse: 'w',
              effect: 'e',
              tags: const [],
              sources: const [],
              createdAt: 1,
              updatedAt: 1,
            ),
          ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          shotAiProvider.overrideWithValue(ai),
        ],
        child: MaterialApp(
          home: Scaffold(body: ShotOptionsPanel(permissions: perms)),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('shows library entries and fetched drafts, marked', (
    tester,
  ) async {
    await pump(tester, {'shot_suggestions': true, 'internet_fetch': true});
    await tester.enterText(find.byType(TextField), 'tense standoff');
    await tester.tap(find.text('Ask'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
    expect(find.text('Close-up'), findsOneWidget);
    expect(find.textContaining('From your library'), findsOneWidget);
    expect(find.text('Mexican standoff'), findsOneWidget);
    expect(find.textContaining('Fetched draft, not saved'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('with Shot suggestions off, no request is made', (tester) async {
    await pump(tester, {'internet_fetch': true});
    expect(find.textContaining('suggestions are off'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(calls, isEmpty);
    await finish(tester);
  });

  test('askShotOptions denied without the gate, before any I/O', () async {
    expect(
      () => askShotOptions(ai, 'q', const [], permissions: const {}),
      throwsA(isA<Exception>()),
    );
    expect(calls, isEmpty);
    await db.close();
  });
}
