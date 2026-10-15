// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$VoidItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TemplatesTable get templates => attachedDatabase.templates;
  $ProjectsTable get projects => attachedDatabase.projects;
  $VoidItemsTable get voidItems => attachedDatabase.voidItems;
  VoidItemsDaoManager get managers => VoidItemsDaoManager(this);
}

class VoidItemsDaoManager {
  final _$VoidItemsDaoMixin _db;
  VoidItemsDaoManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db.attachedDatabase, _db.templates);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db.attachedDatabase, _db.voidItems);
}

mixin _$ProjectsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TemplatesTable get templates => attachedDatabase.templates;
  $VoidItemsTable get voidItems => attachedDatabase.voidItems;
  $ProjectsTable get projects => attachedDatabase.projects;
  ProjectsDaoManager get managers => ProjectsDaoManager(this);
}

class ProjectsDaoManager {
  final _$ProjectsDaoMixin _db;
  ProjectsDaoManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db.attachedDatabase, _db.templates);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db.attachedDatabase, _db.voidItems);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
}

mixin _$CharactersDaoMixin on DatabaseAccessor<AppDatabase> {
  $TemplatesTable get templates => attachedDatabase.templates;
  $ProjectsTable get projects => attachedDatabase.projects;
  $VoidItemsTable get voidItems => attachedDatabase.voidItems;
  $CharactersTable get characters => attachedDatabase.characters;
  $ProjectCharactersTable get projectCharacters =>
      attachedDatabase.projectCharacters;
  $CharacterMapsTable get characterMaps => attachedDatabase.characterMaps;
  CharactersDaoManager get managers => CharactersDaoManager(this);
}

class CharactersDaoManager {
  final _$CharactersDaoMixin _db;
  CharactersDaoManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db.attachedDatabase, _db.templates);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db.attachedDatabase, _db.voidItems);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db.attachedDatabase, _db.characters);
  $$ProjectCharactersTableTableManager get projectCharacters =>
      $$ProjectCharactersTableTableManager(
        _db.attachedDatabase,
        _db.projectCharacters,
      );
  $$CharacterMapsTableTableManager get characterMaps =>
      $$CharacterMapsTableTableManager(_db.attachedDatabase, _db.characterMaps);
}

mixin _$BeatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TemplatesTable get templates => attachedDatabase.templates;
  $VoidItemsTable get voidItems => attachedDatabase.voidItems;
  $ProjectsTable get projects => attachedDatabase.projects;
  $SlotsTable get slots => attachedDatabase.slots;
  $BeatsTable get beats => attachedDatabase.beats;
  $ShotsTable get shots => attachedDatabase.shots;
  $FramesTable get frames => attachedDatabase.frames;
  BeatsDaoManager get managers => BeatsDaoManager(this);
}

class BeatsDaoManager {
  final _$BeatsDaoMixin _db;
  BeatsDaoManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db.attachedDatabase, _db.templates);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db.attachedDatabase, _db.voidItems);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$SlotsTableTableManager get slots =>
      $$SlotsTableTableManager(_db.attachedDatabase, _db.slots);
  $$BeatsTableTableManager get beats =>
      $$BeatsTableTableManager(_db.attachedDatabase, _db.beats);
  $$ShotsTableTableManager get shots =>
      $$ShotsTableTableManager(_db.attachedDatabase, _db.shots);
  $$FramesTableTableManager get frames =>
      $$FramesTableTableManager(_db.attachedDatabase, _db.frames);
}

mixin _$SettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SettingsTable get settings => attachedDatabase.settings;
  SettingsDaoManager get managers => SettingsDaoManager(this);
}

class SettingsDaoManager {
  final _$SettingsDaoMixin _db;
  SettingsDaoManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db.attachedDatabase, _db.settings);
}

mixin _$AiQueueDaoMixin on DatabaseAccessor<AppDatabase> {
  $TemplatesTable get templates => attachedDatabase.templates;
  $ProjectsTable get projects => attachedDatabase.projects;
  $VoidItemsTable get voidItems => attachedDatabase.voidItems;
  $AiQueueTable get aiQueue => attachedDatabase.aiQueue;
  AiQueueDaoManager get managers => AiQueueDaoManager(this);
}

class AiQueueDaoManager {
  final _$AiQueueDaoMixin _db;
  AiQueueDaoManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db.attachedDatabase, _db.templates);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db.attachedDatabase, _db.voidItems);
  $$AiQueueTableTableManager get aiQueue =>
      $$AiQueueTableTableManager(_db.attachedDatabase, _db.aiQueue);
}
