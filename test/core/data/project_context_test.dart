import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/project_context.dart';
import 'package:lynch/features/proposals/proposals_providers.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db
        .into(db.templates)
        .insert(
          TemplatesCompanion.insert(
            id: 't',
            name: 'Tpl',
            description: 'd',
            projectTypes: const ['short_film'],
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    for (final (id, pos) in [('s2', 1), ('s1', 0)]) {
      await db
          .into(db.slots)
          .insert(
            SlotsCompanion.insert(
              id: id,
              templateId: 't',
              position: pos,
              name: 'Slot $pos',
              description: 'd',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
    }
    await db
        .into(db.characters)
        .insert(
          CharactersCompanion.insert(
            id: 'g',
            name: 'Global Ann',
            role: 'global role',
            appearance: '',
            background: '',
            traits: '',
            habits: '',
            wantsNeedsFears: '',
            notes: '',
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'p',
        title: 'P',
        type: ProjectType.shortFilm,
        summary: 'sum',
        templateId: const Value('t'),
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {'beat_generation': true},
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    Future<void> member(String id, CharacterMode mode, String name) => db
        .into(db.projectCharacters)
        .insert(
          ProjectCharactersCompanion.insert(
            id: id,
            projectId: 'p',
            characterId: const Value('g'),
            mode: mode,
            name: Value(name),
            role: Value('$name role'),
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    // Linked row keeps stale local fields; the global sheet wins.
    await member('pcL', CharacterMode.linked, 'Stale');
    await member('pcF', CharacterMode.forked, 'Forked Bo');
  });

  tearDown(() => db.close());

  test(
    'template slots in order; linked from global, forked from project',
    () async {
      final p = await db.projectsDao.byId('p');
      final c = await projectContext(db, p!);
      final tpl = c['template'] as Map;
      expect([for (final s in tpl['slots']) s['slot_id']], ['s1', 's2']);
      final chars = {
        for (final x in c['characters'] as List) x['project_character_id']: x,
      };
      expect(chars['pcL']['name'], 'Global Ann');
      expect(chars['pcL']['role'], 'global role');
      expect(chars['pcF']['name'], 'Forked Bo');
      expect(chars['pcF']['role'], 'Forked Bo role');
    },
  );

  test('revise sends the template block', () async {
    String? body;
    final ai = AiClient(
      readStoredKey: () async => 'k',
      client: MockClient((r) async {
        body = r.body;
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': jsonEncode({
                        'summary_sentences': <Object>[],
                        'changes': <Object>[],
                      }),
                    },
                  ],
                },
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: 'pr',
            projectId: 'p',
            status: ProposalStatus.pending,
            summary: 'A kid.',
            rawTranscript: 'a kid',
            summarySpans: const [],
            changes: const [],
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await ProposalActions(db).revise('pr', 'tweak', ai);
    expect(body, contains('slot_id'));
    expect(body, contains('Slot 1'));
  });
}
