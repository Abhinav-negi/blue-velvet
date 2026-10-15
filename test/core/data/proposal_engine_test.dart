import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/proposal_engine.dart';

const t0 = 1760500000000;

void main() {
  late AppDatabase db;
  late ProposalEngine eng;
  late Directory dir;
  late File strokeA, strokeB;
  var n = 0;
  var clock = t0;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    n = 0;
    clock = t0;
    eng = ProposalEngine(db, clock: () => ++clock, newId: () => 'id${++n}');
    dir = Directory.systemTemp.createTempSync('lynch_strokes');
    strokeA = File('${dir.path}/fa.json')..writeAsStringSync('{"a":1}');
    strokeB = File('${dir.path}/fb.json')..writeAsStringSync('{"b":2}');

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
            seedId: const Value('five'),
          ),
        );
    for (final s in [('s1', 'five/one'), ('s2', 'five/two')]) {
      await db
          .into(db.slots)
          .insert(
            SlotsCompanion.insert(
              id: s.$1,
              templateId: 'tp',
              position: 0,
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
        .into(db.projectCharacters)
        .insert(
          ProjectCharactersCompanion.insert(
            id: 'pc2',
            projectId: 'p',
            mode: CharacterMode.forked,
            name: const Value('Fork'),
            role: const Value('r'),
            createdAt: t0,
            updatedAt: t0,
          ),
        );
    for (final b in [('b1', 's1', 0), ('b2', 's1', 1), ('b3', null, 0)]) {
      await db
          .into(db.beats)
          .insert(
            BeatsCompanion.insert(
              id: b.$1,
              projectId: 'p',
              position: b.$3,
              title: b.$1,
              description: '',
              characterIds: [],
              slotId: Value(b.$2),
              blocks: Value([
                {
                  'id': 'blk-${b.$1}',
                  'type': 'action',
                  'text': 'user ${b.$1}',
                  'scaffold': false,
                  'ai_suggested': false,
                },
              ]),
              createdAt: t0,
              updatedAt: t0,
            ),
          );
    }
    for (final f in [('fa', 'b1', strokeA), ('fb', 'b2', strokeB)]) {
      await db
          .into(db.frames)
          .insert(
            FramesCompanion.insert(
              id: f.$1,
              beatId: f.$2,
              position: 0,
              notes: 'n',
              characterIds: [],
              referenceImages: [],
              strokesPath: Value(f.$3.path),
              thumbnailPath: const Value('thumb.png'),
              createdAt: t0,
              updatedAt: t0,
            ),
          );
    }
  });
  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });

  Future<String> propose(
    List<Map<String, dynamic>> ops, [
    String id = 'pr',
  ]) async {
    await db
        .into(db.proposals)
        .insert(
          ProposalsCompanion.insert(
            id: id,
            projectId: 'p',
            status: ProposalStatus.pending,
            summary: 'sum',
            rawTranscript: '',
            summarySpans: [],
            changes: [
              for (final o in ops) {'id': 'x', 'accepted': true, ...o},
            ],
            createdAt: t0,
            updatedAt: t0,
          ),
        );
    return id;
  }

  Future<List<Beat>> beats([String? slot]) =>
      (db.select(db.beats)
            ..where(
              (b) => slot == null ? b.slotId.isNull() : b.slotId.equals(slot),
            )
            ..orderBy([(b) => OrderingTerm.asc(b.position)]))
          .get();
  Future<Beat> beat(String id) =>
      (db.select(db.beats)..where((b) => b.id.equals(id))).getSingle();
  Future<List<Frame>> frames() =>
      (db.select(db.frames)..orderBy([(f) => OrderingTerm.asc(f.id)])).get();
  // Frame has list fields, so compare by JSON text, not identity.
  List<String> fj(List<Frame> fs) => [
    for (final f in fs) f.toJson().toString(),
  ];

  group('ops', () {
    test(
      'addBeat: slot by seed id, position, characters, soft unmatched name',
      () async {
        final notes = await eng.approve(
          await propose([
            {
              'op': 'addBeat',
              'ref': 'n',
              'title': 'New',
              'description': 'd',
              'slot_seed_id': 'five/one',
              'position': 1,
              'character_names': ['kid', 'Ghost'],
            },
          ]),
        );
        expect(notes, hasLength(1));
        final bs = await beats('s1');
        expect(bs.map((b) => b.title), ['b1', 'New', 'b2']);
        expect(bs.map((b) => b.position), [0, 1, 2]);
        expect(bs[1].characterIds, ['pc1']);
        expect(bs[1].blocks, isEmpty);
      },
    );

    test('editBeat: only non-null fields, add/remove characters', () async {
      await db
          .update(db.beats)
          .write(const BeatsCompanion(characterIds: Value(['pc1'])));
      await eng.approve(
        await propose([
          {
            'op': 'editBeat',
            'beat_id': 'b1',
            'title': null,
            'description': 'new d',
            'character_names_add': ['Fork'],
            'character_names_remove': ['Kid'],
          },
        ]),
      );
      final b = await beat('b1');
      expect(
        [b.title, b.description, b.characterIds],
        [
          'b1',
          'new d',
          ['pc2'],
        ],
      );
      expect(b.blocks, hasLength(1));
    });

    test('splitBeat: first part overwrites, others follow in slot', () async {
      await eng.approve(
        await propose([
          {
            'op': 'splitBeat',
            'beat_id': 'b1',
            'parts': [
              {
                'title': 'A',
                'description': 'a',
                'character_names': ['Kid'],
              },
              {'title': 'B', 'description': 'b', 'character_names': []},
              {'title': 'C', 'description': 'c', 'character_names': []},
            ],
          },
        ]),
      );
      expect((await beats('s1')).map((b) => b.title), ['A', 'B', 'C', 'b2']);
      expect((await beat('b1')).blocks, hasLength(1));
      expect((await frames()).firstWhere((f) => f.id == 'fa').beatId, 'b1');
    });

    test(
      'mergeBeats: appends blocks, re-parents frames, deletes others',
      () async {
        await eng.approve(
          await propose([
            {
              'op': 'mergeBeats',
              'beat_ids': ['b1', 'b2'],
              'title': 'M',
              'description': 'md',
              'character_names': ['Kid'],
            },
          ]),
        );
        final b = await beat('b1');
        expect(
          [b.title, b.characterIds],
          [
            'M',
            ['pc1'],
          ],
        );
        expect(b.blocks!.map((x) => x['id']), ['blk-b1', 'blk-b2']);
        expect((await beats('s1')).map((x) => x.id), ['b1']);
        final fs = await frames();
        expect(fs.map((f) => f.beatId), ['b1', 'b1']);
        expect(fs.map((f) => f.position), [0, 1]);
      },
    );

    test('moveBeat: reindexes old and new slot', () async {
      await eng.approve(
        await propose([
          {
            'op': 'moveBeat',
            'beat_id': 'b1',
            'slot_seed_id': 'five/two',
            'position': 0,
          },
        ]),
      );
      expect((await beats('s2')).map((b) => b.id), ['b1']);
      final old = await beats('s1');
      expect([old.single.id, old.single.position], ['b2', 0]);
    });

    test('placeBeatInSlot: unplaced only', () async {
      await eng.approve(
        await propose([
          {'op': 'placeBeatInSlot', 'beat_id': 'b3', 'slot_id': 's1'},
        ]),
      );
      expect((await beats('s1')).map((b) => b.id), ['b1', 'b2', 'b3']);
      expect(
        eng.approve(
          await propose([
            {'op': 'placeBeatInSlot', 'beat_id': 'b1', 'slot_id': 's2'},
          ], 'pr2'),
        ),
        throwsA(isA<ProposalException>()),
      );
    });

    test('addCharacter: creates linked row; same name is a no-op', () async {
      await eng.approve(
        await propose([
          {
            'op': 'addCharacter',
            'name': 'Watchman',
            'fields': {'appearance': 'old'},
          },
          {
            'op': 'addCharacter',
            'name': 'kid',
            'fields': {'appearance': 'x'},
          },
        ]),
      );
      final pcs = await db.select(db.projectCharacters).get();
      expect(pcs, hasLength(3));
      final w = (await db.select(db.characters).get()).firstWhere(
        (c) => c.name == 'Watchman',
      );
      expect(w.appearance, 'old');
      expect((await db.select(db.characters).get()), hasLength(2));
    });

    test(
      'editCharacter: writes global row if linked, own columns if forked',
      () async {
        await eng.approve(
          await propose([
            {
              'op': 'editCharacter',
              'project_character_id': 'pc1',
              'fields': {'age': '8'},
            },
            {
              'op': 'editCharacter',
              'project_character_id': 'pc2',
              'fields': {'role': 'new'},
            },
          ]),
        );
        expect(
          (await (db.select(
            db.characters,
          )..where((c) => c.id.equals('g1'))).getSingle()).age,
          '8',
        );
        final f = await (db.select(
          db.projectCharacters,
        )..where((c) => c.id.equals('pc2'))).getSingle();
        expect([f.role, f.age], ['new', null]);
      },
    );

    test('setSummary', () async {
      await eng.approve(
        await propose([
          {'op': 'setSummary', 'text': 'fresh'},
        ]),
      );
      expect((await db.projectsDao.byId('p'))!.summary, 'fresh');
    });

    test(
      'addScaffold: appends flagged blocks; dialogue rejected atomically',
      () async {
        await eng.approve(
          await propose([
            {
              'op': 'addScaffold',
              'beat_id': 'b1',
              'blocks': [
                {'type': 'scene_heading', 'text': 'EXT. X'},
              ],
            },
          ]),
        );
        final bl = (await beat('b1')).blocks!;
        expect(bl.map((x) => x['text']), ['user b1', 'EXT. X']);
        expect([bl[1]['scaffold'], bl[1]['ai_suggested']], [true, false]);
        await expectLater(
          eng.approve(
            await propose([
              {'op': 'setSummary', 'text': 'half'},
              {
                'op': 'addScaffold',
                'beat_id': 'b1',
                'blocks': [
                  {'type': 'dialogue', 'text': 'hi'},
                ],
              },
            ], 'pr2'),
          ),
          throwsA(isA<ProposalException>()),
        );
        expect((await db.projectsDao.byId('p'))!.summary, 'old'); // rolled back
      },
    );

    test('addScaffold rows for a YouTube beat', () async {
      await db
          .update(db.projects)
          .write(const ProjectsCompanion(type: Value(ProjectType.youtube)));
      await db.update(db.beats).write(const BeatsCompanion(sayShow: Value([])));
      await eng.approve(
        await propose([
          {
            'op': 'addScaffold',
            'beat_ref': null,
            'beat_id': 'b1',
            'rows': [
              {
                'say': '',
                'show': {
                  'a_roll': 'x',
                  'b_roll': '',
                  'on_screen_text': '',
                  'graphics': '',
                },
              },
            ],
          },
        ]),
      );
      expect((await beat('b1')).sayShow!.single['say'], '');
    });

    test(
      'beat_ref resolves a beat created earlier in the same proposal',
      () async {
        await eng.approve(
          await propose([
            {'op': 'addBeat', 'ref': 'n', 'title': 'N', 'description': ''},
            {
              'op': 'addScaffold',
              'beat_ref': 'n',
              'blocks': [
                {'type': 'action', 'text': 'A'},
              ],
            },
          ]),
        );
        final nb = (await beats()).firstWhere((b) => b.title == 'N');
        expect(nb.blocks!.single['text'], 'A');
      },
    );
  });

  test('subset: only accepted ops run', () async {
    final id = await propose([
      {'op': 'setSummary', 'text': 'yes'},
      {
        'op': 'addBeat',
        'title': 'Skipped',
        'description': '',
        'accepted': false,
      },
    ]);
    await eng.approve(id);
    expect((await db.projectsDao.byId('p'))!.summary, 'yes');
    expect(
      (await db.select(db.beats).get()).map((b) => b.title),
      isNot(contains('Skipped')),
    );
  });

  test('approve snapshots pre-state; restore equals snapshot and snapshots itself; undo', () async {
    final before = await eng.snapshots.capture('p');
    final id = await propose([
      {'op': 'setSummary', 'text': 'changed'},
      {'op': 'moveBeat', 'beat_id': 'b1', 'slot_id': 's2'},
    ]);
    await eng.approve(id);
    final pr = await (db.select(
      db.proposals,
    )..where((p) => p.id.equals(id))).getSingle();
    expect(pr.status, ProposalStatus.approved);
    final snap = await (db.select(
      db.snapshots,
    )..where((s) => s.id.equals(pr.snapshotId!))).getSingle();
    expect(snap.reason, SnapshotReason.proposalApproved);
    expect(snap.proposalId, id);
    expect(snap.data, before);
    final after = await eng.snapshots.capture('p');
    expect(after, isNot(before));

    // restore: state == snapshot; a `restored` snapshot is created
    final r = await eng.snapshots.restore(snap.id);
    expect(r.reason, SnapshotReason.restored);
    expect(r.restoredFromSnapshotId, snap.id);
    expect(await eng.snapshots.capture('p'), before);
    expect(r.data, before);

    // undo: approve again, then undo returns to the pre-approve state
    final id2 = await propose([
      {'op': 'setSummary', 'text': 'again'},
    ], 'pr2');
    await eng.approve(id2);
    expect((await db.projectsDao.byId('p'))!.summary, 'again');
    final preUndo = (await eng.snapshots.capture('p'));
    expect(preUndo, isNot(before));
    await eng.undoLastApprove('p');
    expect(await eng.snapshots.capture('p'), before);
    final p2 = await (db.select(
      db.proposals,
    )..where((p) => p.id.equals(id2))).getSingle();
    expect(p2.status, ProposalStatus.pending);
    expect(p2.snapshotId, isNull);
  });

  test('restore survives deleted template/slot references', () async {
    final s = await eng.snapshots.create('p', SnapshotReason.manual, 'm');
    await (db.delete(db.templates)..where((t) => t.id.equals('tp'))).go();
    await eng.snapshots.restore(s.id);
    expect((await db.projectsDao.byId('p'))!.templateId, isNull);
    expect((await beat('b1')).slotId, isNull);
  });

  test('frames metadata and stroke files untouched by ops and restore', () async {
    final framesBefore = await frames();
    final bytes = [strokeA.readAsStringSync(), strokeB.readAsStringSync()];
    await eng.approve(
      await propose([
        {
          'op': 'addBeat',
          'title': 'N',
          'description': '',
          'slot_id': 's1',
          'position': 0,
        },
        {'op': 'editBeat', 'beat_id': 'b1', 'title': 'E'},
        {
          'op': 'splitBeat',
          'beat_id': 'b1',
          'parts': [
            {'title': 'a', 'description': '', 'character_names': []},
            {'title': 'b', 'description': '', 'character_names': []},
          ],
        },
        {'op': 'moveBeat', 'beat_id': 'b3', 'slot_id': 's2'},
        {'op': 'addCharacter', 'name': 'Z', 'fields': {}},
        {
          'op': 'editCharacter',
          'project_character_id': 'pc1',
          'fields': {'age': '1'},
        },
        {'op': 'setSummary', 'text': 's'},
        {
          'op': 'addScaffold',
          'beat_id': 'b1',
          'blocks': [
            {'type': 'action', 'text': 'x'},
          ],
        },
      ]),
    );
    expect(fj(await frames()), fj(framesBefore));

    // merge only re-parents frames (beat_id/position); drawings stay intact
    await eng.approve(
      await propose([
        {
          'op': 'mergeBeats',
          'beat_ids': ['b1', 'b2'],
          'title': 'M',
          'description': '',
          'character_names': [],
        },
      ], 'pr2'),
    );
    for (final f in await frames()) {
      final o = framesBefore.firstWhere((x) => x.id == f.id);
      expect(
        [f.strokesPath, f.thumbnailPath, f.notes, f.updatedAt],
        [o.strokesPath, o.thumbnailPath, o.notes, o.updatedAt],
      );
    }
    await eng.undoLastApprove('p');
    await eng.undoLastApprove('p');
    // restore never edits frame rows; the merged-in frame keeps its new parent
    final fb = (await frames()).firstWhere((f) => f.id == 'fb');
    expect(fb.beatId, 'b1');
    expect(fj([(await frames()).first]), fj([framesBefore.first]));
    expect([strokeA.readAsStringSync(), strokeB.readAsStringSync()], bytes);
  });

  Future<List<Snapshot>> snaps(SnapshotReason r) =>
      (db.select(db.snapshots)
            ..where((s) => s.reason.equalsValue(r))
            ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
          .get();

  group('fix round', () {
    test('mergeBeats rejects duplicate ids and keeps the survivor', () async {
      for (final ids in [
        ['b1', 'b1'],
        ['b1', 'b2', 'b1'],
      ]) {
        await expectLater(
          eng.approve(
            await propose([
              {
                'op': 'mergeBeats',
                'beat_ids': ids,
                'title': 'M',
                'description': '',
                'character_names': [],
              },
            ], 'pr${ids.length}'),
          ),
          throwsA(isA<ProposalException>()),
        );
      }
      expect(
        (await db.select(db.beats).get()).map((b) => b.id),
        containsAll(['b1', 'b2']),
      );
      expect(await frames(), hasLength(2));
    });

    test(
      'restore first snapshots the current state ("Before restore")',
      () async {
        final id = await propose([
          {'op': 'setSummary', 'text': 'ai'},
        ]);
        await eng.approve(id);
        await db
            .update(db.beats)
            .write(const BeatsCompanion(title: Value('user edit')));
        await eng.undoLastApprove('p');
        final before = (await snaps(SnapshotReason.manual)).single;
        expect(before.label, 'Before restore');
        expect(
          (before.data['beats'] as List).map((b) => b['title']),
          everyElement('user edit'),
        );
        expect((before.data['project'] as Map)['summary'], 'ai');
        expect((await beat('b1')).title, 'b1'); // pre-approve state back
      },
    );

    test('restore leaves new and edited frames untouched', () async {
      await eng.approve(
        await propose([
          {'op': 'setSummary', 'text': 'ai'},
        ]),
      );
      await db
          .into(db.frames)
          .insert(
            FramesCompanion.insert(
              id: 'fnew',
              beatId: 'b3',
              position: 0,
              notes: 'new',
              characterIds: [],
              referenceImages: [],
              createdAt: t0,
              updatedAt: t0,
            ),
          );
      await (db.update(db.frames)..where((f) => f.id.equals('fa'))).write(
        const FramesCompanion(notes: Value('edited')),
      );
      final fsBefore = fj(await frames());
      await eng.undoLastApprove('p');
      expect(fj(await frames()), fsBefore);
    });

    test(
      'restore keeps a beat that is not in the snapshot but owns frames',
      () async {
        final s = await eng.snapshots.create('p', SnapshotReason.manual, 'm');
        for (final b in ['bx', 'by']) {
          await db
              .into(db.beats)
              .insert(
                BeatsCompanion.insert(
                  id: b,
                  projectId: 'p',
                  position: 0,
                  title: b,
                  description: '',
                  characterIds: [],
                  slotId: const Value('s1'),
                  createdAt: t0,
                  updatedAt: t0,
                ),
              );
        }
        await db
            .into(db.frames)
            .insert(
              FramesCompanion.insert(
                id: 'fx',
                beatId: 'bx',
                position: 0,
                notes: '',
                characterIds: [],
                referenceImages: [],
                createdAt: t0,
                updatedAt: t0,
              ),
            );
        await eng.snapshots.restore(s.id);
        final ids = (await beats('s1')).map((b) => b.id).toList();
        expect(ids, [
          'b1',
          'b2',
          'bx',
        ]); // by (no frames) dropped, bx kept at end
        expect((await frames()).map((f) => f.id), contains('fx'));
      },
    );

    test('restore re-inserts a deleted frame as metadata', () async {
      final s = await eng.snapshots.create('p', SnapshotReason.manual, 'm');
      await (db.delete(db.frames)..where((f) => f.id.equals('fa'))).go();
      await eng.snapshots.restore(s.id);
      expect((await frames()).map((f) => f.id), ['fa', 'fb']);
    });

    test(
      'linked character whose global row is gone restores as forked',
      () async {
        final s = await eng.snapshots.create('p', SnapshotReason.manual, 'm');
        await (db.delete(db.characters)..where((c) => c.id.equals('g1'))).go();
        await eng.snapshots.restore(s.id);
        final pc = await (db.select(
          db.projectCharacters,
        )..where((c) => c.id.equals('pc1'))).getSingle();
        expect(
          [pc.mode, pc.characterId, pc.name],
          [CharacterMode.forked, null, 'Kid'],
        );
      },
    );

    test(
      'undo picks the latest approve; stale undo after a restore throws',
      () async {
        await eng.approve(
          await propose([
            {'op': 'setSummary', 'text': 'one'},
          ], 'a'),
        );
        await eng.approve(
          await propose([
            {'op': 'setSummary', 'text': 'two'},
          ], 'b'),
        );
        await eng.undoLastApprove('p');
        expect((await db.projectsDao.byId('p'))!.summary, 'one');
        final pa = await (db.select(
          db.proposals,
        )..where((p) => p.id.equals('a'))).getSingle();
        expect(pa.status, ProposalStatus.approved);

        await eng.approve(
          await propose([
            {'op': 'setSummary', 'text': 'two'},
          ], 'c'),
        );
        final first = (await snaps(SnapshotReason.proposalApproved)).first;
        await eng.snapshots.restore(first.id); // back to before 'a'
        final cap = await eng.snapshots.capture('p');
        await expectLater(
          eng.undoLastApprove('p'),
          throwsA(isA<ProposalException>()),
        );
        expect(await eng.snapshots.capture('p'), cap);
      },
    );

    test('equal resolved_at: later snapshot wins', () async {
      await eng.approve(
        await propose([
          {'op': 'setSummary', 'text': 'one'},
        ], 'a'),
      );
      await eng.approve(
        await propose([
          {'op': 'setSummary', 'text': 'two'},
        ], 'b'),
      );
      await db
          .update(db.proposals)
          .write(const ProposalsCompanion(resolvedAt: Value(5)));
      await eng.undoLastApprove('p');
      expect((await db.projectsDao.byId('p'))!.summary, 'one');
    });

    test('addScaffold checks project type and text', () async {
      Future<void> bad(List<Map<String, dynamic>> ops, String id) async {
        final pid = await propose(ops, id);
        await expectLater(eng.approve(pid), throwsA(isA<ProposalException>()));
      }

      await bad([
        {
          'op': 'addScaffold',
          'beat_id': 'b1',
          'rows': [
            {
              'say': '',
              'show': {'a_roll': 'x'},
            },
          ],
        },
      ], 'r1');
      await bad([
        {
          'op': 'addScaffold',
          'beat_id': 'b1',
          'blocks': [
            {'type': 'action'},
          ],
        },
      ], 'r2');
      await db
          .update(db.projects)
          .write(const ProjectsCompanion(type: Value(ProjectType.youtube)));
      await bad([
        {
          'op': 'addScaffold',
          'beat_id': 'b1',
          'blocks': [
            {'type': 'action', 'text': 'x'},
          ],
        },
      ], 'r3');
    });

    test(
      'wrong-typed field rolls everything back as ProposalException',
      () async {
        await expectLater(
          eng.approve(
            await propose([
              {'op': 'setSummary', 'text': 'half'},
              {'op': 'addBeat', 'title': 5, 'description': ''},
            ]),
          ),
          throwsA(isA<ProposalException>()),
        );
        expect((await db.projectsDao.byId('p'))!.summary, 'old');
      },
    );

    test('slot must belong to the project template', () async {
      await db
          .into(db.templates)
          .insert(
            TemplatesCompanion.insert(
              id: 'tp2',
              name: 'T2',
              description: '',
              projectTypes: [],
              createdAt: t0,
              updatedAt: t0,
            ),
          );
      await db
          .into(db.slots)
          .insert(
            SlotsCompanion.insert(
              id: 'sx',
              templateId: 'tp2',
              position: 0,
              name: 'x',
              description: '',
              createdAt: t0,
              updatedAt: t0,
            ),
          );
      await expectLater(
        eng.approve(
          await propose([
            {'op': 'placeBeatInSlot', 'beat_id': 'b3', 'slot_id': 'sx'},
          ]),
        ),
        throwsA(isA<ProposalException>()),
      );
    });

    test('accepted must be exactly true', () async {
      await db
          .into(db.proposals)
          .insert(
            ProposalsCompanion.insert(
              id: 'q',
              projectId: 'p',
              status: ProposalStatus.pending,
              summary: '',
              rawTranscript: '',
              summarySpans: [],
              changes: [
                {'id': 'x', 'op': 'setSummary', 'text': 'no'},
                {
                  'id': 'y',
                  'op': 'setSummary',
                  'text': 'str',
                  'accepted': 'true',
                },
              ],
              createdAt: t0,
              updatedAt: t0,
            ),
          );
      await eng.approve('q');
      expect((await db.projectsDao.byId('p'))!.summary, 'old');
    });

    test(
      'stroke files and frame rows survive post-approve frame add/edit + undo',
      () async {
        final bytes = [strokeA.readAsStringSync(), strokeB.readAsStringSync()];
        final newStroke = File('${dir.path}/fn.json')
          ..writeAsStringSync('{"n":3}');
        await eng.approve(
          await propose([
            {'op': 'setSummary', 'text': 'ai'},
          ]),
        );
        await db
            .into(db.frames)
            .insert(
              FramesCompanion.insert(
                id: 'fn',
                beatId: 'b1',
                position: 5,
                notes: 'n',
                characterIds: [],
                referenceImages: [],
                strokesPath: Value(newStroke.path),
                createdAt: t0,
                updatedAt: t0,
              ),
            );
        await (db.update(db.frames)..where((f) => f.id.equals('fb'))).write(
          const FramesCompanion(notes: Value('edited')),
        );
        final fsBefore = fj(await frames());
        await eng.undoLastApprove('p');
        expect(fj(await frames()), fsBefore);
        expect(
          [
            strokeA.readAsStringSync(),
            strokeB.readAsStringSync(),
            newStroke.readAsStringSync(),
          ],
          [...bytes, '{"n":3}'],
        );
      },
    );

    test('undo reverts the shared sheet; other projects and forks', () async {
      await db.projectsDao.upsert(
        ProjectsCompanion.insert(
          id: 'p2',
          title: 'P2',
          type: ProjectType.shortFilm,
          summary: '',
          aspectRatio: '16:9',
          typeFields: {},
          aiPermissions: {},
          createdAt: t0,
          updatedAt: t0,
        ),
      );
      await db
          .into(db.projectCharacters)
          .insert(
            ProjectCharactersCompanion.insert(
              id: 'pc9',
              projectId: 'p2',
              mode: CharacterMode.linked,
              characterId: const Value('g1'),
              createdAt: t0,
              updatedAt: t0,
            ),
          );
      Future<Character> g() => (db.select(
        db.characters,
      )..where((c) => c.id.equals('g1'))).getSingle();
      final p2Before = (await eng.snapshots.capture(
        'p2',
      ))['project_characters'];
      await eng.approve(
        await propose([
          {
            'op': 'editCharacter',
            'project_character_id': 'pc1',
            'fields': {'age': '8', 'notes': 'x'},
          },
          {
            'op': 'editCharacter',
            'project_character_id': 'pc2',
            'fields': {'role': 'new'},
          },
        ]),
      );
      expect((await g()).age, '8');
      expect(
        (await eng.snapshots.capture('p2'))['project_characters'],
        isNot(p2Before),
      );
      await eng.undoLastApprove('p');
      final g1 = await g();
      expect([g1.age, g1.notes], [null, '']);
      expect(
        (await eng.snapshots.capture('p2'))['project_characters'],
        p2Before,
      );
      final f = await (db.select(
        db.projectCharacters,
      )..where((c) => c.id.equals('pc2'))).getSingle();
      expect(f.role, 'r');
      expect(await db.select(db.characters).get(), hasLength(1));
    });
  });
}
