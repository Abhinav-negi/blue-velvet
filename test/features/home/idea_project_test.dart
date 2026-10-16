import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/data/ai_defaults.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/home/idea_project.dart';
import 'package:lynch/features/home/idea_screen.dart';

const _raw = 'A kid, 8, finds a rusty key. The watchman sees him.';

Map<String, dynamic> _reply() => {
  'title': null,
  'changes': [
    {'op': 'setSummary', 'text': 'A kid finds a rusty key.'},
    {
      'op': 'addCharacter',
      'name': 'Kid',
      'fields': {'age': '8'},
    },
    {
      'op': 'addBeat',
      'ref': 'b1',
      'title': 'The kid finds the key',
      'description': 'A kid finds a rusty key.',
      'slot_seed_id': 'five-point/setup',
      'character_names': ['Kid'],
    },
    {
      'op': 'addScaffold',
      'beat_ref': 'b1',
      'blocks': [
        {'type': 'action', 'text': 'A kid finds a rusty key.'},
      ],
    },
  ],
};

AiClient _fake() => AiClient(
  readStoredKey: () async => 'k',
  client: MockClient(
    (_) async => http.Response(
      jsonEncode({
        'candidates': [
          {
            'content': {
              'parts': [
                {'text': jsonEncode(_reply())},
              ],
            },
            'finishReason': 'STOP',
          },
        ],
      }),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ),
  ),
);

const _short = IdeaType(
  id: 'short-film',
  name: 'Short film',
  type: ProjectType.shortFilm,
  aspectRatio: '16:9',
  templateIds: ['five-point'],
);

void main() {
  late AppDatabase db;
  late VoidItem item;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    await SeedLoader(db).load();
    await db.voidItemsDao.upsert(
      VoidItemsCompanion.insert(
        id: 'v1',
        type: VoidType.storyIdea,
        summary: 'A kid finds a key.',
        rawTranscript: _raw,
        summarySpans: const [],
        structure: const {},
        tags: const [],
        usedInProjectIds: const [],
        status: VoidStatus.preProject,
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    item = (await db.voidItemsDao.byId('v1'))!;
  });
  tearDown(() async => db.close());

  test(
    'generation creates summary, characters, beats; storyboards empty',
    () async {
      final type = _short;
      final id = await createProjectFromIdea(
        db,
        _fake(),
        item: item,
        summary: item.summary,
        title: 'The Key',
        type: type,
        templateId: 'five-point',
      );
      final p = (await db.projectsDao.byId(id))!;
      expect(p.summary, 'A kid finds a rusty key.');
      expect(p.templateId, 'five-point');
      expect(p.aspectRatio, '16:9');
      expect(p.aiPermissions, await newProjectAiPermissions(db));
      expect(await db.select(db.projectCharacters).get(), hasLength(1));
      final beats = await db.select(db.beats).get();
      expect(beats, hasLength(1));
      expect(beats.single.blocks, isNotEmpty);
      expect(await db.select(db.frames).get(), isEmpty);
      expect((await db.voidItemsDao.byId('v1'))!.promotedProjectId, id);
      // Can't promote twice.
      final promoted = (await db.voidItemsDao.byId('v1'))!;
      expect(
        () => createProjectFromIdea(
          db,
          _fake(),
          item: promoted,
          summary: 's',
          title: 't',
          type: type,
          templateId: 'five-point',
        ),
        throwsStateError,
      );
    },
  );

  test('beat generation off: no beats', () async {
    await db.settingsDao.put(
      aiDefaultsKey,
      jsonEncode({'beat_generation': false}),
      1,
    );
    final type = _short;
    final id = await createProjectFromIdea(
      db,
      _fake(),
      item: item,
      summary: item.summary,
      title: 'The Key',
      type: type,
      templateId: 'five-point',
    );
    expect(await db.select(db.beats).get(), isEmpty);
    expect((await db.projectsDao.byId(id))!.summary, isNotEmpty);
    expect(await db.select(db.projectCharacters).get(), hasLength(1));
  });

  testWidgets('template options come from project_types.json, default first', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          aiClientProvider.overrideWithValue(_fake()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const IdeaScreen(voidItemId: 'v1'),
        ),
      ),
    );
    Future<void> settle() async {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
    }

    await settle();
    await tester.tap(find.text('YouTube video'));
    await settle();
    final tiles = tester
        .widgetList<RadioListTile<String>>(find.byType(RadioListTile<String>))
        .map((r) => r.value)
        .toList();
    final seed =
        (jsonDecode(
                  File('assets/seed/project_types.json').readAsStringSync(),
                )['items']
                as List)
            .firstWhere((t) => t['id'] == 'youtube-video');
    expect(tiles, (seed['template_options'] as List).cast<String>());
    expect(tiles.first, seed['default_template']);
    expect(find.textContaining('Default.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
