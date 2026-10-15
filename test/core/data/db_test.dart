import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';

const t = 1760500000000;

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  VoidItemsCompanion voidItem(String id, String summary, String raw) =>
      VoidItemsCompanion.insert(
        id: id,
        type: VoidType.storyIdea,
        summary: summary,
        rawTranscript: raw,
        summarySpans: [
          {'sentence_index': 0, 'start': 0, 'end': 5}
        ],
        structure: {},
        tags: ['a'],
        usedInProjectIds: [],
        status: VoidStatus.ready,
        createdAt: t,
        updatedAt: t,
      );

  test('one row round-trips in every table (15)', () async {
    await db.voidItemsDao.upsert(voidItem('v1', 's', 'r'));
    await db.into(db.templates).insert(TemplatesCompanion.insert(
        id: 'tp', name: 'Five point', description: '',
        projectTypes: ['short_film'], createdAt: t, updatedAt: t));
    await db.into(db.slots).insert(SlotsCompanion.insert(
        id: 'sl', templateId: 'tp', position: 0, name: 'Act 1',
        description: '', createdAt: t, updatedAt: t));
    await db.projectsDao.upsert(ProjectsCompanion.insert(
        id: 'p', title: 'The Key', type: ProjectType.shortFilm, summary: '',
        aspectRatio: '16:9', typeFields: {}, aiPermissions: {'auto_summary': true},
        templateId: const Value('tp'), createdAt: t, updatedAt: t));
    await db.charactersDao.upsert(CharactersCompanion.insert(
        id: 'c', name: 'Kid', role: '', appearance: '', background: '',
        traits: '', habits: '', wantsNeedsFears: '', notes: '',
        createdAt: t, updatedAt: t));
    await db.charactersDao.upsertMember(ProjectCharactersCompanion.insert(
        id: 'pc', projectId: 'p', mode: CharacterMode.linked,
        characterId: const Value('c'), createdAt: t, updatedAt: t));
    await db.into(db.shots).insert(ShotsCompanion.insert(
        id: 'sh', name: 'Close-up', category: ShotCategory.size,
        description: '', whenToUse: '', effect: '', tags: [],
        sources: [{'title': 'x', 'url': 'y'}], createdAt: t, updatedAt: t));
    await db.into(db.shotImages).insert(ShotImagesCompanion.insert(
        id: 'si', shotId: 'sh', position: 0, path: 'assets/seed/images/a.jpg',
        kind: ShotImageKind.seedAsset, createdAt: t, updatedAt: t));
    await db.beatsDao.upsert(BeatsCompanion.insert(
        id: 'b', projectId: 'p', position: 0, title: 'Sandbox', description: '',
        characterIds: ['pc'], slotId: const Value('sl'),
        blocks: const Value([
          {'id': 'x', 'type': 'action', 'text': 'A kid.', 'scaffold': false, 'ai_suggested': false}
        ]),
        createdAt: t, updatedAt: t));
    await db.beatsDao.upsertFrame(FramesCompanion.insert(
        id: 'f', beatId: 'b', position: 0, notes: '', characterIds: [],
        referenceImages: [], createdAt: t, updatedAt: t));
    await db.charactersDao.upsertMap(CharacterMapsCompanion.insert(
        id: 'cm', projectId: 'p', nodes: [], edges: [], groups: [],
        viewport: {'x': 0, 'y': 0, 'zoom': 1}, createdAt: t, updatedAt: t));
    await db.into(db.snapshots).insert(SnapshotsCompanion.insert(
        id: 'sn', projectId: 'p', reason: SnapshotReason.created, label: 'Created',
        data: {'format': 1}, createdAt: t));
    await db.into(db.proposals).insert(ProposalsCompanion.insert(
        id: 'pr', projectId: 'p', status: ProposalStatus.pending, summary: '',
        rawTranscript: '', summarySpans: [], changes: [{'op': 'addBeat', 'accepted': true}],
        snapshotId: const Value('sn'), createdAt: t, updatedAt: t));
    await db.settingsDao.put('theme', 'dark', t);
    await db.aiQueueDao.enqueue(AiQueueCompanion.insert(
        id: 'q', kind: QueueKind.cleanCapture, status: QueueStatus.needsAi,
        payload: {'scope': {'type': 'void'}}, targetVoidItemId: const Value('v1'),
        createdAt: t, updatedAt: t));

    expect((await db.voidItemsDao.byId('v1'))!.tags, ['a']);
    expect((await db.select(db.templates).getSingle()).projectTypes, ['short_film']);
    expect((await db.select(db.slots).getSingle()).name, 'Act 1');
    expect((await db.projectsDao.byId('p'))!.type, ProjectType.shortFilm);
    expect((await db.select(db.characters).getSingle()).name, 'Kid');
    expect((await db.select(db.projectCharacters).getSingle()).mode, CharacterMode.linked);
    expect((await db.select(db.shots).getSingle()).sources.first['title'], 'x');
    expect((await db.select(db.shotImages).getSingle()).kind, ShotImageKind.seedAsset);
    final beat = await db.select(db.beats).getSingle();
    expect(beat.blocks!.length, 1);
    expect(beat.sayShow, isNull);
    expect((await db.select(db.frames).getSingle()).beatId, 'b');
    expect((await db.charactersDao.mapFor('p'))!.viewport['zoom'], 1);
    expect((await db.select(db.snapshots).getSingle()).data['format'], 1);
    expect((await db.select(db.proposals).getSingle()).changes.length, 1);
    expect(await db.settingsDao.get('theme'), 'dark');
    expect((await db.aiQueueDao.due(t)).single.payload['scope'], {'type': 'void'});
  });

  test('cascade delete and seed_id uniqueness', () async {
    await db.projectsDao.upsert(ProjectsCompanion.insert(
        id: 'p', title: 'x', type: ProjectType.short, summary: '',
        aspectRatio: '9:16', typeFields: {}, aiPermissions: {},
        createdAt: t, updatedAt: t));
    await db.beatsDao.upsert(BeatsCompanion.insert(
        id: 'b', projectId: 'p', position: 0, title: '', description: '',
        characterIds: [], createdAt: t, updatedAt: t));
    await db.projectsDao.remove('p');
    expect(await db.select(db.beats).get(), isEmpty);

    Future<void> tpl(String id, String seed) =>
        db.into(db.templates).insert(TemplatesCompanion.insert(
            id: id, name: '', description: '', projectTypes: [],
            seedId: Value(seed), createdAt: t, updatedAt: t));
    await tpl('a', 'three-act');
    expect(tpl('b', 'three-act'), throwsA(anything));
  });

  test('enum converter rejects unknown values', () {
    expect(() => const EnumConverter(VoidType.values).fromSql('nope'),
        throwsArgumentError);
  });

  group('FTS', () {
    test('finds by summary-only word and raw-transcript-only word', () async {
      await db.voidItemsDao.upsert(voidItem('v1', 'A lonely watchman', 'okay so a kid finds a rusty key'));
      await db.voidItemsDao.upsert(voidItem('v2', 'Other', 'nothing here'));
      expect((await db.voidItemsDao.search('watchman')).map((e) => e.id), ['v1']);
      expect((await db.voidItemsDao.search('rusty')).map((e) => e.id), ['v1']);
      expect(await db.voidItemsDao.search('zzz'), isEmpty);
    });

    test('stays in sync on update and delete', () async {
      await db.voidItemsDao.upsert(voidItem('v1', 'watchman', 'raw'));
      await db.voidItemsDao.upsert(voidItem('v1', 'lighthouse', 'raw'));
      expect(await db.voidItemsDao.search('watchman'), isEmpty);
      expect(await db.voidItemsDao.search('lighthouse'), hasLength(1));
      await db.voidItemsDao.remove('v1');
      expect(await db.voidItemsDao.search('lighthouse'), isEmpty);
    });
  });
}
