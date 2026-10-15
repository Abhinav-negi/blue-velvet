import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/characters/characters_providers.dart';

import 'characters_test.dart' show addProject;

void main() {
  late AppDatabase db;
  late ProviderContainer box;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    box = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    await addProject(db, 'a', 'Alpha');
    await addProject(db, 'b', 'Beta');
    await db
        .into(db.characters)
        .insert(
          CharactersCompanion.insert(
            id: 'c',
            name: 'Kid',
            role: 'lead',
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
  });

  tearDown(() async {
    box.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await db.close();
  });

  Future<String?> nameIn(String project, String member) async {
    box.invalidate(sheetProvider((projectId: project, id: member)));
    return (await box.read(
      sheetProvider((projectId: project, id: member)).future,
    ))?['name'];
  }

  test(
    'linked edit shows in both projects; fork changes only locally',
    () async {
      final ma = await importCharacter(db, 'a', 'c');
      final mb = await importCharacter(db, 'b', 'c');
      expect(await importCharacter(db, 'a', 'c'), ma); // no duplicate link
      await (db.update(db.characters)..where((t) => t.id.equals('c'))).write(
        const CharactersCompanion(name: Value('Kid Edited')),
      );
      expect(await nameIn('a', ma), 'Kid Edited');
      expect(await nameIn('b', mb), 'Kid Edited');

      await forkMember(db, mb);
      final row = await (db.select(
        db.projectCharacters,
      )..where((t) => t.id.equals(mb))).getSingle();
      expect(row.mode, CharacterMode.forked);
      expect(row.characterId, 'c'); // origin kept
      expect(row.role, 'lead'); // sheet copied
      await (db.update(db.projectCharacters)..where((t) => t.id.equals(mb)))
          .write(const ProjectCharactersCompanion(name: Value('Fork Only')));
      await (db.update(db.characters)..where((t) => t.id.equals('c'))).write(
        const CharactersCompanion(name: Value('Global Again')),
      );
      expect(await nameIn('a', ma), 'Global Again');
      expect(await nameIn('b', mb), 'Fork Only');
    },
  );

  test('adding a character to a beat updates appears in', () async {
    final m = await importCharacter(db, 'a', 'c');
    final key = (projectId: 'a', id: m);
    final seen = <List<String>>[];
    box.listen(appearsInProvider(key), (_, n) {
      if (n.hasValue) seen.add(n.value!);
    }, fireImmediately: true);
    await db.beatsDao.upsert(
      BeatsCompanion.insert(
        id: 'beat1',
        projectId: 'a',
        position: 0,
        title: 'Opening',
        description: '',
        characterIds: const [],
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(seen.last, isEmpty);
    await (db.update(db.beats)..where((b) => b.id.equals('beat1'))).write(
      BeatsCompanion(characterIds: Value([m])),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(seen.last, ['Opening']);
    // global view resolves through membership too
    final global = <List<String>>[];
    box.listen(appearsInProvider((projectId: null, id: 'c')), (_, n) {
      if (n.hasValue) global.add(n.value!);
    }, fireImmediately: true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(global.last, ['Opening']);
  });
}
