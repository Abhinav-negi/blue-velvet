import 'package:drift/drift.dart';

import 'converters.dart';

// Enums: Dart camelCase <-> snake_case TEXT in the DB (see EnumConverter).
enum VoidType { storyIdea, concept, character, dialogue, lyric, sceneFragment, other }

enum VoidStatus { ready, needsAi, preProject }

enum ProjectType { shortFilm, longFilm, youtube, short }

enum CharacterMode { linked, forked }

enum ShotCategory { size, angle, movement, composition, lens, lighting }

enum ShotImageKind { seedAsset, userFile }

enum ProposalStatus { pending, approved, rejected }

enum SnapshotReason { created, proposalApproved, restored, manual }

enum QueueKind { cleanCapture, buildProposal, editItem, fetchConvert, createProject }

enum QueueStatus { needsAi, processing, done, failed }


/// Seed-backed columns (DATA_MODEL 0.1). `seed_id` unique; NULLs are allowed many times.
mixin SeedColumns on Table {
  BoolColumn get builtin => boolean().withDefault(const Constant(false))();
  BoolColumn get userEdited => boolean().withDefault(const Constant(false))();
  TextColumn get seedId => text().nullable().unique()();
}

mixin Timestamps on Table {
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

mixin Id on Table {
  TextColumn get id => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class VoidItems extends Table with Id, Timestamps {
  TextColumn get type => text().map(const EnumConverter(VoidType.values))();
  TextColumn get summary => text()();
  TextColumn get rawTranscript => text()();
  TextColumn get summarySpans => text().map(listJson)();
  TextColumn get structure => text().map(mapJson)();
  TextColumn get tags => text().map(strListJson)();
  TextColumn get usedInProjectIds => text().map(strListJson)();
  TextColumn get promotedProjectId => text()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.setNull)();
  TextColumn get status => text().map(const EnumConverter(VoidStatus.values))();
}

class Characters extends Table with Id, Timestamps {
  TextColumn get name => text()();
  TextColumn get age => text().nullable()();
  TextColumn get role => text()();
  TextColumn get appearance => text()();
  TextColumn get background => text()();
  TextColumn get traits => text()();
  TextColumn get habits => text()();
  TextColumn get wantsNeedsFears => text()();
  TextColumn get notes => text()();
  TextColumn get sourceVoidItemId => text()
      .nullable()
      .references(VoidItems, #id, onDelete: KeyAction.setNull)();
}

class ProjectCharacters extends Table with Id, Timestamps {
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get characterId => text()
      .nullable()
      .references(Characters, #id, onDelete: KeyAction.setNull)();
  TextColumn get mode =>
      text().map(const EnumConverter(CharacterMode.values))();
  // Fork copy; NULL while linked.
  TextColumn get name => text().nullable()();
  TextColumn get age => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get appearance => text().nullable()();
  TextColumn get background => text().nullable()();
  TextColumn get traits => text().nullable()();
  TextColumn get habits => text().nullable()();
  TextColumn get wantsNeedsFears => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class Templates extends Table with Id, Timestamps, SeedColumns {
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get projectTypes => text().map(strListJson)();
}

class Slots extends Table with Id, Timestamps, SeedColumns {
  TextColumn get templateId =>
      text().references(Templates, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get runtimeProportion => real().nullable()();
}

class Shots extends Table with Id, Timestamps, SeedColumns {
  TextColumn get name => text()();
  TextColumn get category =>
      text().map(const EnumConverter(ShotCategory.values))();
  TextColumn get description => text()();
  TextColumn get whenToUse => text()();
  TextColumn get effect => text()();
  TextColumn get tags => text().map(strListJson)();
  TextColumn get sources => text().map(listJson)();
}

class ShotImages extends Table with Id, Timestamps, SeedColumns {
  TextColumn get shotId =>
      text().references(Shots, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get path => text()();
  TextColumn get kind =>
      text().map(const EnumConverter(ShotImageKind.values))();
  TextColumn get license => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
}

class Projects extends Table with Id, Timestamps {
  TextColumn get title => text()();
  TextColumn get type => text().map(const EnumConverter(ProjectType.values))();
  TextColumn get summary => text()();
  TextColumn get templateId => text()
      .nullable()
      .references(Templates, #id, onDelete: KeyAction.setNull)();
  TextColumn get aspectRatio => text()();
  TextColumn get typeFields => text().map(mapJson)();
  TextColumn get aiPermissions => text().map(mapJson)();
  TextColumn get sourceVoidItemId => text()
      .nullable()
      .references(VoidItems, #id, onDelete: KeyAction.setNull)();
  BoolColumn get isSample => boolean().withDefault(const Constant(false))();
}

class Beats extends Table with Id, Timestamps {
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get slotId =>
      text().nullable().references(Slots, #id, onDelete: KeyAction.setNull)();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get characterIds => text().map(strListJson)();
  TextColumn get blocks => text().map(listJson).nullable()();
  TextColumn get sayShow => text().map(listJson).nullable()();
}

class Frames extends Table with Id, Timestamps {
  TextColumn get beatId =>
      text().references(Beats, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get strokesPath => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get aspectRatio => text().nullable()();
  TextColumn get shotSize => text().nullable()();
  TextColumn get angle => text().nullable()();
  TextColumn get movement => text().nullable()();
  TextColumn get lensFeel => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get notes => text()();
  TextColumn get blockId => text().nullable()(); // no FK, by design
  TextColumn get characterIds => text().map(strListJson)();
  TextColumn get referenceImages => text().map(listJson)();
  TextColumn get shotId =>
      text().nullable().references(Shots, #id, onDelete: KeyAction.setNull)();
}

class CharacterMaps extends Table with Id, Timestamps {
  TextColumn get projectId => text()
      .unique()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get nodes => text().map(listJson)();
  TextColumn get edges => text().map(listJson)();
  TextColumn get groups => text().map(listJson)();
  TextColumn get viewport => text().map(mapJson)();
}

class Proposals extends Table with Id, Timestamps {
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get status =>
      text().map(const EnumConverter(ProposalStatus.values))();
  TextColumn get summary => text()();
  TextColumn get rawTranscript => text()();
  TextColumn get summarySpans => text().map(listJson)();
  TextColumn get changes => text().map(listJson)();
  TextColumn get sourceVoidItemId => text()
      .nullable()
      .references(VoidItems, #id, onDelete: KeyAction.setNull)();
  TextColumn get rejectedToVoidItemId => text()
      .nullable()
      .references(VoidItems, #id, onDelete: KeyAction.setNull)();
  TextColumn get snapshotId => text()
      .nullable()
      .references(Snapshots, #id, onDelete: KeyAction.setNull)();
  IntColumn get resolvedAt => integer().nullable()();
}

/// No `updated_at` (DATA_MODEL 13), so no Timestamps mixin.
class Snapshots extends Table with Id {
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get reason =>
      text().map(const EnumConverter(SnapshotReason.values))();
  TextColumn get label => text()();
  TextColumn get proposalId => text().nullable()(); // no FK (cycle)
  TextColumn get restoredFromSnapshotId => text().nullable()();
  TextColumn get data => text().map(mapJson)();
  IntColumn get createdAt => integer()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();
  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('AiJob')
class AiQueue extends Table with Id, Timestamps {
  TextColumn get kind => text().map(const EnumConverter(QueueKind.values))();
  TextColumn get status =>
      text().map(const EnumConverter(QueueStatus.values))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get nextRetryAt => integer().nullable()();
  TextColumn get error => text().nullable()();
  TextColumn get payload => text().map(mapJson)();
  TextColumn get targetVoidItemId => text()
      .nullable()
      .references(VoidItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetProjectId => text()
      .nullable()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
}
