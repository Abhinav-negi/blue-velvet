import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/fetch.dart';
import 'package:lynch/core/data/db.dart';

const allow = {'internet_fetch': true, 'shot_suggestions': true};
const wiki = 'https://en.wikipedia.org/wiki/Kish%C5%8Dtenketsu';

Map<String, dynamic> fixture(String n) =>
    jsonDecode(File('test/fixtures/ai/fetch/$n.json').readAsStringSync())
        as Map<String, dynamic>;

http.Response gemini(Object o) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': jsonEncode(o)}
            ]
          }
        }
      ]
    }),
    200);

/// Fake web: records GET hosts; Gemini POSTs get [reply].
({AiClient ai, List<Uri> gets, List<String> prompts}) fake(Object reply,
    {bool wikiEmpty = false}) {
  final gets = <Uri>[];
  final prompts = <String>[];
  final c = MockClient((r) async {
    if (r.method == 'POST') {
      prompts.add(jsonDecode(r.body)['contents'][0]['parts'][0]['text']);
      return gemini(reply);
    }
    gets.add(r.url);
    if (wikiEmpty) return http.Response(jsonEncode({'batchcomplete': ''}), 200);
    final commons = r.url.host.startsWith('commons');
    return http.Response(
        jsonEncode({
          'query': {
            'pages': {
              '1': {
                'title': commons ? 'File:Dz.jpg' : 'Kishotenketsu',
                'fullurl': commons
                    ? 'https://commons.wikimedia.org/wiki/File:Dz.jpg'
                    : wiki,
                'extract': 'Four-part structure: ki, sho, ten, ketsu.',
                'imageinfo': [
                  {'url': 'https://upload.wikimedia.org/dz.jpg'}
                ],
              }
            }
          }
        }),
        200);
  });
  return (
    ai: AiClient(client: c, readStoredKey: () async => 'k', dartDefineKey: ''),
    gets: gets,
    prompts: prompts,
  );
}

void main() {
  test('template draft saves as user rows in templates + slots', () async {
    final f = fake(fixture('kishotenketsu'));
    final out = await FetchConvert(f.ai)
        .run('Kishotenketsu', kind: 'template', permissions: allow);
    final draft = out as TemplateDraft;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final id = await saveFetchDraft(db, draft, now: 5);
    final t = await (db.select(db.templates)).getSingle();
    expect(t.id, id);
    expect(t.builtin, false);
    expect(t.seedId, isNull);
    expect(t.projectTypes, ['short_film', 'short']);
    expect(t.sourceUrl, wiki);
    final slots = await (db.select(db.slots)
          ..orderBy([(s) => OrderingTerm(expression: s.position)]))
        .get();
    expect(slots.map((s) => s.name), ['Ki', 'Sho', 'Ten', 'Ketsu']);
    expect(slots.every((s) => !s.builtin && s.seedId == null), isTrue);
    expect(slots.first.runtimeProportion, 0.25);
  });

  test('shot draft saves into shots with {title,url} sources', () async {
    final f = fake(fixture('dolly_zoom'));
    final out = await FetchConvert(f.ai).run('dolly zoom', permissions: allow);
    final draft = out as ShotDraft;
    expect(draft.imageCandidates.map((c) => c.url),
        ['https://upload.wikimedia.org/dz.jpg']); // evil.example dropped
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await saveFetchDraft(db, draft);
    final s = await (db.select(db.shots)).getSingle();
    expect(s.category, ShotCategory.movement);
    expect(s.builtin, false);
    expect(s.seedId, isNull);
    expect(s.sources.single['title'], 'Wikipedia: Dolly zoom');
  });

  test('cannot_convert is returned, not a made-up format', () async {
    final f = fake({'result': 'cannot_convert', 'sources': [], 'reason': 'Not a format'});
    final out = await FetchConvert(f.ai).run('my feelings', permissions: allow);
    expect((out as CannotConvert).reason, 'Not a format');
  });

  test('no step-1 source: cannotConvert without calling Gemini', () async {
    final f = fake({}, wikiEmpty: true);
    final out = await FetchConvert(f.ai).run('zzz', permissions: allow);
    expect(out, isA<CannotConvert>());
    expect(f.prompts, isEmpty);
  });

  test('every draft carries >=1 source, all from fetched URLs', () async {
    final f = fake(fixture('kishotenketsu'));
    final d = await FetchConvert(f.ai).run('Kishotenketsu', permissions: allow)
        as TemplateDraft;
    expect(d.sources, isNotEmpty);
    expect(d.sources.map((s) => s['url']), [wiki]); // invented URL dropped
    // none of the cited URLs fetched -> cannot convert, not an unsourced draft
    final bad = fixture('kishotenketsu')..['sources'] = [
      {'title': 'x', 'url': 'https://example.com/a'}
    ];
    final f2 = fake(bad);
    expect(await FetchConvert(f2.ai).run('K', permissions: allow),
        isA<CannotConvert>());
  });

  test('no Brave key: only Wikipedia/Commons are searched', () async {
    final f = fake(fixture('kishotenketsu'));
    await FetchConvert(f.ai).run('Kishotenketsu', permissions: allow);
    expect(f.gets.map((u) => u.host).toSet(),
        {'en.wikipedia.org', 'commons.wikimedia.org'});
    final f2 = fake(fixture('kishotenketsu'));
    await FetchConvert(f2.ai, braveKey: 'b')
        .run('Kishotenketsu', permissions: allow);
    expect(f2.gets.map((u) => u.host), contains('api.search.brave.com'));
  });

  test('internet_fetch off: no network at all', () async {
    final f = fake({});
    await expectLater(FetchConvert(f.ai).run('x'),
        throwsA(isA<AiPermissionDenied>()));
    expect(f.gets, isEmpty);
  });

  test('bad proportion sum is rejected', () {
    final j = fixture('kishotenketsu');
    (j['template']['slots'] as List)[0]['runtime_proportion'] = 0.9;
    expect(() => parseFetchResult(j, {wiki}, {}),
        throwsA(isA<AiMalformedResponse>()));
  });

  test('shotOptions drops unknown ids; wants_fetch needs internet_fetch',
      () async {
    final reply = {
      'options': [
        {'shot_id': 'a', 'why': 'Tight.'},
        {'shot_id': 'zzz', 'why': 'Invented.'}
      ],
      'wants_fetch': ['Dutch angle']
    };
    const lib = [LibraryShot('a', 'Close-up', 'size', 'Fills the frame.')];
    final on = await shotOptions(fake(reply).ai, 'standoff', lib,
        permissions: allow);
    expect(on.options.map((o) => o.shotId), ['a']);
    expect(on.wantsFetch, ['Dutch angle']);
    final off = await shotOptions(fake(reply).ai, 'standoff', lib,
        permissions: {'shot_suggestions': true});
    expect(off.wantsFetch, isEmpty);
    await expectLater(shotOptions(fake(reply).ai, 'q', lib),
        throwsA(isA<AiPermissionDenied>()));
  });
}
