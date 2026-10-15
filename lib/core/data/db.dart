// MIGRATION RULE: schema changes = bump schemaVersion + add a migration step
// + add a migration test (drift_schemas/ holds the dumps); never drop user
// data; never edit an old step. Reference data changes in assets/seed, not here.
// Dump after each bump: dart run drift_dev schema dump lib/core/data/db.dart drift_schemas/
import 'package:drift/drift.dart';

import 'converters.dart';
import 'daos.dart';
import 'tables.dart';

export 'converters.dart';
export 'daos.dart';
export 'tables.dart';

part 'db.g.dart';

@DriftDatabase(
  include: {'extras.drift'},
  tables: [
    VoidItems,
    Characters,
    ProjectCharacters,
    Templates,
    Slots,
    Shots,
    ShotImages,
    Projects,
    Beats,
    Frames,
    CharacterMaps,
    Proposals,
    Snapshots,
    Settings,
    AiQueue,
  ],
  daos: [
    VoidItemsDao,
    ProjectsDao,
    CharactersDao,
    BeatsDao,
    SettingsDao,
    AiQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
