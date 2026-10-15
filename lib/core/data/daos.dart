import 'package:drift/drift.dart';

import 'db.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [VoidItems])
class VoidItemsDao extends DatabaseAccessor<AppDatabase>
    with _$VoidItemsDaoMixin {
  VoidItemsDao(super.db);

  Future<void> upsert(VoidItemsCompanion row) =>
      into(voidItems).insertOnConflictUpdate(row);
  Future<VoidItem?> byId(String id) =>
      (select(voidItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<VoidItem>> watchAll() => (select(voidItems)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
  Future<int> remove(String id) =>
      (delete(voidItems)..where((t) => t.id.equals(id))).go();

  /// Full-text search over summary + raw transcript, best match first.
  /// Each whitespace-separated term is quoted so user punctuation can't break
  /// FTS5 syntax; terms are ANDed.
  Future<List<VoidItem>> search(String query) {
    final terms = query
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => '"${t.replaceAll('"', '""')}"')
        .join(' ');
    if (terms.isEmpty) return Future.value([]);
    return customSelect(
      'SELECT v.* FROM void_items v '
      'JOIN void_items_fts f ON f.rowid = v.rowid '
      'WHERE void_items_fts MATCH ? ORDER BY rank',
      variables: [Variable.withString(terms)],
      readsFrom: {voidItems},
    ).map((r) => voidItems.map(r.data)).get();
  }
}

@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  Future<void> upsert(ProjectsCompanion row) =>
      into(projects).insertOnConflictUpdate(row);
  Future<Project?> byId(String id) =>
      (select(projects)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<Project>> watchAll() => (select(projects)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();
  Future<int> remove(String id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [Characters, ProjectCharacters, CharacterMaps])
class CharactersDao extends DatabaseAccessor<AppDatabase>
    with _$CharactersDaoMixin {
  CharactersDao(super.db);

  Future<void> upsert(CharactersCompanion row) =>
      into(characters).insertOnConflictUpdate(row);
  Stream<List<Character>> watchAll() =>
      (select(characters)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  Future<void> upsertMember(ProjectCharactersCompanion row) =>
      into(projectCharacters).insertOnConflictUpdate(row);
  Stream<List<ProjectCharacter>> watchMembers(String projectId) =>
      (select(projectCharacters)..where((t) => t.projectId.equals(projectId)))
          .watch();
  Future<void> upsertMap(CharacterMapsCompanion row) =>
      into(characterMaps).insertOnConflictUpdate(row);
  Future<CharacterMap?> mapFor(String projectId) => (select(characterMaps)
        ..where((t) => t.projectId.equals(projectId)))
      .getSingleOrNull();
}

@DriftAccessor(tables: [Beats, Frames])
class BeatsDao extends DatabaseAccessor<AppDatabase> with _$BeatsDaoMixin {
  BeatsDao(super.db);

  Future<void> upsert(BeatsCompanion row) =>
      into(beats).insertOnConflictUpdate(row);
  Stream<List<Beat>> watchForProject(String projectId) => (select(beats)
        ..where((t) => t.projectId.equals(projectId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
      .watch();
  Future<void> upsertFrame(FramesCompanion row) =>
      into(frames).insertOnConflictUpdate(row);
  Stream<List<Frame>> watchFrames(String beatId) => (select(frames)
        ..where((t) => t.beatId.equals(beatId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
      .watch();
}

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> get(String key) async => (await (select(settings)
            ..where((t) => t.key.equals(key)))
          .getSingleOrNull())
      ?.value;
  Future<void> put(String key, String value, int nowMs) =>
      into(settings).insertOnConflictUpdate(SettingsCompanion.insert(
          key: key, value: value, updatedAt: nowMs));
}

@DriftAccessor(tables: [AiQueue])
class AiQueueDao extends DatabaseAccessor<AppDatabase>
    with _$AiQueueDaoMixin {
  AiQueueDao(super.db);

  Future<void> enqueue(AiQueueCompanion row) => into(aiQueue).insert(row);

  /// Jobs waiting and due, oldest first.
  Future<List<AiJob>> due(int nowMs) => (select(aiQueue)
        ..where((t) =>
            t.status.equalsValue(QueueStatus.needsAi) &
            (t.nextRetryAt.isNull() | t.nextRetryAt.isSmallerOrEqualValue(nowMs)))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();
}
