// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, Template> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userEditedMeta = const VerificationMeta(
    'userEdited',
  );
  @override
  late final GeneratedColumn<bool> userEdited = GeneratedColumn<bool>(
    'user_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seedIdMeta = const VerificationMeta('seedId');
  @override
  late final GeneratedColumn<String> seedId = GeneratedColumn<String>(
    'seed_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  projectTypes = GeneratedColumn<String>(
    'project_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($TemplatesTable.$converterprojectTypes);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    name,
    description,
    sourceUrl,
    projectTypes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<Template> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('user_edited')) {
      context.handle(
        _userEditedMeta,
        userEdited.isAcceptableOrUnknown(data['user_edited']!, _userEditedMeta),
      );
    }
    if (data.containsKey('seed_id')) {
      context.handle(
        _seedIdMeta,
        seedId.isAcceptableOrUnknown(data['seed_id']!, _seedIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Template map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Template(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      userEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_edited'],
      )!,
      seedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      projectTypes: $TemplatesTable.$converterprojectTypes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}project_types'],
        )!,
      ),
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterprojectTypes =
      strListJson;
}

class Template extends DataClass implements Insertable<Template> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final bool builtin;
  final bool userEdited;
  final String? seedId;
  final String name;
  final String description;
  final String? sourceUrl;
  final List<String> projectTypes;
  const Template({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.builtin,
    required this.userEdited,
    this.seedId,
    required this.name,
    required this.description,
    this.sourceUrl,
    required this.projectTypes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['builtin'] = Variable<bool>(builtin);
    map['user_edited'] = Variable<bool>(userEdited);
    if (!nullToAbsent || seedId != null) {
      map['seed_id'] = Variable<String>(seedId);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    {
      map['project_types'] = Variable<String>(
        $TemplatesTable.$converterprojectTypes.toSql(projectTypes),
      );
    }
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      builtin: Value(builtin),
      userEdited: Value(userEdited),
      seedId: seedId == null && nullToAbsent
          ? const Value.absent()
          : Value(seedId),
      name: Value(name),
      description: Value(description),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      projectTypes: Value(projectTypes),
    );
  }

  factory Template.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Template(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      userEdited: serializer.fromJson<bool>(json['userEdited']),
      seedId: serializer.fromJson<String?>(json['seedId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      projectTypes: serializer.fromJson<List<String>>(json['projectTypes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'builtin': serializer.toJson<bool>(builtin),
      'userEdited': serializer.toJson<bool>(userEdited),
      'seedId': serializer.toJson<String?>(seedId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'projectTypes': serializer.toJson<List<String>>(projectTypes),
    };
  }

  Template copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    bool? builtin,
    bool? userEdited,
    Value<String?> seedId = const Value.absent(),
    String? name,
    String? description,
    Value<String?> sourceUrl = const Value.absent(),
    List<String>? projectTypes,
  }) => Template(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    builtin: builtin ?? this.builtin,
    userEdited: userEdited ?? this.userEdited,
    seedId: seedId.present ? seedId.value : this.seedId,
    name: name ?? this.name,
    description: description ?? this.description,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    projectTypes: projectTypes ?? this.projectTypes,
  );
  Template copyWithCompanion(TemplatesCompanion data) {
    return Template(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      userEdited: data.userEdited.present
          ? data.userEdited.value
          : this.userEdited,
      seedId: data.seedId.present ? data.seedId.value : this.seedId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      projectTypes: data.projectTypes.present
          ? data.projectTypes.value
          : this.projectTypes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Template(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('projectTypes: $projectTypes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    name,
    description,
    sourceUrl,
    projectTypes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Template &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.builtin == this.builtin &&
          other.userEdited == this.userEdited &&
          other.seedId == this.seedId &&
          other.name == this.name &&
          other.description == this.description &&
          other.sourceUrl == this.sourceUrl &&
          other.projectTypes == this.projectTypes);
}

class TemplatesCompanion extends UpdateCompanion<Template> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> builtin;
  final Value<bool> userEdited;
  final Value<String?> seedId;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> sourceUrl;
  final Value<List<String>> projectTypes;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.projectTypes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    required String name,
    required String description,
    this.sourceUrl = const Value.absent(),
    required List<String> projectTypes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       description = Value(description),
       projectTypes = Value(projectTypes);
  static Insertable<Template> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? builtin,
    Expression<bool>? userEdited,
    Expression<String>? seedId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? sourceUrl,
    Expression<String>? projectTypes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (builtin != null) 'builtin': builtin,
      if (userEdited != null) 'user_edited': userEdited,
      if (seedId != null) 'seed_id': seedId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (projectTypes != null) 'project_types': projectTypes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? builtin,
    Value<bool>? userEdited,
    Value<String?>? seedId,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? sourceUrl,
    Value<List<String>>? projectTypes,
    Value<int>? rowid,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      builtin: builtin ?? this.builtin,
      userEdited: userEdited ?? this.userEdited,
      seedId: seedId ?? this.seedId,
      name: name ?? this.name,
      description: description ?? this.description,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      projectTypes: projectTypes ?? this.projectTypes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (userEdited.present) {
      map['user_edited'] = Variable<bool>(userEdited.value);
    }
    if (seedId.present) {
      map['seed_id'] = Variable<String>(seedId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (projectTypes.present) {
      map['project_types'] = Variable<String>(
        $TemplatesTable.$converterprojectTypes.toSql(projectTypes.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('projectTypes: $projectTypes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProjectType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProjectType>($ProjectsTable.$convertertype);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<String> aspectRatio = GeneratedColumn<String>(
    'aspect_ratio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  typeFields = GeneratedColumn<String>(
    'type_fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($ProjectsTable.$convertertypeFields);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  aiPermissions = GeneratedColumn<String>(
    'ai_permissions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($ProjectsTable.$converteraiPermissions);
  static const VerificationMeta _sourceVoidItemIdMeta = const VerificationMeta(
    'sourceVoidItemId',
  );
  @override
  late final GeneratedColumn<String> sourceVoidItemId = GeneratedColumn<String>(
    'source_void_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES void_items (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _isSampleMeta = const VerificationMeta(
    'isSample',
  );
  @override
  late final GeneratedColumn<bool> isSample = GeneratedColumn<bool>(
    'is_sample',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_sample" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    title,
    type,
    summary,
    templateId,
    aspectRatio,
    typeFields,
    aiPermissions,
    sourceVoidItemId,
    isSample,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_aspectRatioMeta);
    }
    if (data.containsKey('source_void_item_id')) {
      context.handle(
        _sourceVoidItemIdMeta,
        sourceVoidItemId.isAcceptableOrUnknown(
          data['source_void_item_id']!,
          _sourceVoidItemIdMeta,
        ),
      );
    }
    if (data.containsKey('is_sample')) {
      context.handle(
        _isSampleMeta,
        isSample.isAcceptableOrUnknown(data['is_sample']!, _isSampleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: $ProjectsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aspect_ratio'],
      )!,
      typeFields: $ProjectsTable.$convertertypeFields.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type_fields'],
        )!,
      ),
      aiPermissions: $ProjectsTable.$converteraiPermissions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ai_permissions'],
        )!,
      ),
      sourceVoidItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_void_item_id'],
      ),
      isSample: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_sample'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static TypeConverter<ProjectType, String> $convertertype =
      const EnumConverter(ProjectType.values);
  static TypeConverter<Map<String, dynamic>, String> $convertertypeFields =
      mapJson;
  static TypeConverter<Map<String, dynamic>, String> $converteraiPermissions =
      mapJson;
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String title;
  final ProjectType type;
  final String summary;
  final String? templateId;
  final String aspectRatio;
  final Map<String, dynamic> typeFields;
  final Map<String, dynamic> aiPermissions;
  final String? sourceVoidItemId;
  final bool isSample;
  const Project({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.type,
    required this.summary,
    this.templateId,
    required this.aspectRatio,
    required this.typeFields,
    required this.aiPermissions,
    this.sourceVoidItemId,
    required this.isSample,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['title'] = Variable<String>(title);
    {
      map['type'] = Variable<String>($ProjectsTable.$convertertype.toSql(type));
    }
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    map['aspect_ratio'] = Variable<String>(aspectRatio);
    {
      map['type_fields'] = Variable<String>(
        $ProjectsTable.$convertertypeFields.toSql(typeFields),
      );
    }
    {
      map['ai_permissions'] = Variable<String>(
        $ProjectsTable.$converteraiPermissions.toSql(aiPermissions),
      );
    }
    if (!nullToAbsent || sourceVoidItemId != null) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId);
    }
    map['is_sample'] = Variable<bool>(isSample);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title: Value(title),
      type: Value(type),
      summary: Value(summary),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      aspectRatio: Value(aspectRatio),
      typeFields: Value(typeFields),
      aiPermissions: Value(aiPermissions),
      sourceVoidItemId: sourceVoidItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceVoidItemId),
      isSample: Value(isSample),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<ProjectType>(json['type']),
      summary: serializer.fromJson<String>(json['summary']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      aspectRatio: serializer.fromJson<String>(json['aspectRatio']),
      typeFields: serializer.fromJson<Map<String, dynamic>>(json['typeFields']),
      aiPermissions: serializer.fromJson<Map<String, dynamic>>(
        json['aiPermissions'],
      ),
      sourceVoidItemId: serializer.fromJson<String?>(json['sourceVoidItemId']),
      isSample: serializer.fromJson<bool>(json['isSample']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<ProjectType>(type),
      'summary': serializer.toJson<String>(summary),
      'templateId': serializer.toJson<String?>(templateId),
      'aspectRatio': serializer.toJson<String>(aspectRatio),
      'typeFields': serializer.toJson<Map<String, dynamic>>(typeFields),
      'aiPermissions': serializer.toJson<Map<String, dynamic>>(aiPermissions),
      'sourceVoidItemId': serializer.toJson<String?>(sourceVoidItemId),
      'isSample': serializer.toJson<bool>(isSample),
    };
  }

  Project copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? title,
    ProjectType? type,
    String? summary,
    Value<String?> templateId = const Value.absent(),
    String? aspectRatio,
    Map<String, dynamic>? typeFields,
    Map<String, dynamic>? aiPermissions,
    Value<String?> sourceVoidItemId = const Value.absent(),
    bool? isSample,
  }) => Project(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    title: title ?? this.title,
    type: type ?? this.type,
    summary: summary ?? this.summary,
    templateId: templateId.present ? templateId.value : this.templateId,
    aspectRatio: aspectRatio ?? this.aspectRatio,
    typeFields: typeFields ?? this.typeFields,
    aiPermissions: aiPermissions ?? this.aiPermissions,
    sourceVoidItemId: sourceVoidItemId.present
        ? sourceVoidItemId.value
        : this.sourceVoidItemId,
    isSample: isSample ?? this.isSample,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      summary: data.summary.present ? data.summary.value : this.summary,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      typeFields: data.typeFields.present
          ? data.typeFields.value
          : this.typeFields,
      aiPermissions: data.aiPermissions.present
          ? data.aiPermissions.value
          : this.aiPermissions,
      sourceVoidItemId: data.sourceVoidItemId.present
          ? data.sourceVoidItemId.value
          : this.sourceVoidItemId,
      isSample: data.isSample.present ? data.isSample.value : this.isSample,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('summary: $summary, ')
          ..write('templateId: $templateId, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('typeFields: $typeFields, ')
          ..write('aiPermissions: $aiPermissions, ')
          ..write('sourceVoidItemId: $sourceVoidItemId, ')
          ..write('isSample: $isSample')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    title,
    type,
    summary,
    templateId,
    aspectRatio,
    typeFields,
    aiPermissions,
    sourceVoidItemId,
    isSample,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.type == this.type &&
          other.summary == this.summary &&
          other.templateId == this.templateId &&
          other.aspectRatio == this.aspectRatio &&
          other.typeFields == this.typeFields &&
          other.aiPermissions == this.aiPermissions &&
          other.sourceVoidItemId == this.sourceVoidItemId &&
          other.isSample == this.isSample);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> title;
  final Value<ProjectType> type;
  final Value<String> summary;
  final Value<String?> templateId;
  final Value<String> aspectRatio;
  final Value<Map<String, dynamic>> typeFields;
  final Value<Map<String, dynamic>> aiPermissions;
  final Value<String?> sourceVoidItemId;
  final Value<bool> isSample;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.summary = const Value.absent(),
    this.templateId = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.typeFields = const Value.absent(),
    this.aiPermissions = const Value.absent(),
    this.sourceVoidItemId = const Value.absent(),
    this.isSample = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String title,
    required ProjectType type,
    required String summary,
    this.templateId = const Value.absent(),
    required String aspectRatio,
    required Map<String, dynamic> typeFields,
    required Map<String, dynamic> aiPermissions,
    this.sourceVoidItemId = const Value.absent(),
    this.isSample = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       title = Value(title),
       type = Value(type),
       summary = Value(summary),
       aspectRatio = Value(aspectRatio),
       typeFields = Value(typeFields),
       aiPermissions = Value(aiPermissions);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? summary,
    Expression<String>? templateId,
    Expression<String>? aspectRatio,
    Expression<String>? typeFields,
    Expression<String>? aiPermissions,
    Expression<String>? sourceVoidItemId,
    Expression<bool>? isSample,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (summary != null) 'summary': summary,
      if (templateId != null) 'template_id': templateId,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (typeFields != null) 'type_fields': typeFields,
      if (aiPermissions != null) 'ai_permissions': aiPermissions,
      if (sourceVoidItemId != null) 'source_void_item_id': sourceVoidItemId,
      if (isSample != null) 'is_sample': isSample,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? title,
    Value<ProjectType>? type,
    Value<String>? summary,
    Value<String?>? templateId,
    Value<String>? aspectRatio,
    Value<Map<String, dynamic>>? typeFields,
    Value<Map<String, dynamic>>? aiPermissions,
    Value<String?>? sourceVoidItemId,
    Value<bool>? isSample,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      type: type ?? this.type,
      summary: summary ?? this.summary,
      templateId: templateId ?? this.templateId,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      typeFields: typeFields ?? this.typeFields,
      aiPermissions: aiPermissions ?? this.aiPermissions,
      sourceVoidItemId: sourceVoidItemId ?? this.sourceVoidItemId,
      isSample: isSample ?? this.isSample,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ProjectsTable.$convertertype.toSql(type.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<String>(aspectRatio.value);
    }
    if (typeFields.present) {
      map['type_fields'] = Variable<String>(
        $ProjectsTable.$convertertypeFields.toSql(typeFields.value),
      );
    }
    if (aiPermissions.present) {
      map['ai_permissions'] = Variable<String>(
        $ProjectsTable.$converteraiPermissions.toSql(aiPermissions.value),
      );
    }
    if (sourceVoidItemId.present) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId.value);
    }
    if (isSample.present) {
      map['is_sample'] = Variable<bool>(isSample.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('summary: $summary, ')
          ..write('templateId: $templateId, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('typeFields: $typeFields, ')
          ..write('aiPermissions: $aiPermissions, ')
          ..write('sourceVoidItemId: $sourceVoidItemId, ')
          ..write('isSample: $isSample, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoidItemsTable extends VoidItems
    with TableInfo<$VoidItemsTable, VoidItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoidItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VoidType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VoidType>($VoidItemsTable.$convertertype);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTranscriptMeta = const VerificationMeta(
    'rawTranscript',
  );
  @override
  late final GeneratedColumn<String> rawTranscript = GeneratedColumn<String>(
    'raw_transcript',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String>
  summarySpans = GeneratedColumn<String>(
    'summary_spans',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<dynamic>>($VoidItemsTable.$convertersummarySpans);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  structure = GeneratedColumn<String>(
    'structure',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($VoidItemsTable.$converterstructure);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($VoidItemsTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  usedInProjectIds = GeneratedColumn<String>(
    'used_in_project_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($VoidItemsTable.$converterusedInProjectIds);
  static const VerificationMeta _promotedProjectIdMeta = const VerificationMeta(
    'promotedProjectId',
  );
  @override
  late final GeneratedColumn<String> promotedProjectId =
      GeneratedColumn<String>(
        'promoted_project_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE SET NULL',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<VoidStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VoidStatus>($VoidItemsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    type,
    summary,
    rawTranscript,
    summarySpans,
    structure,
    tags,
    usedInProjectIds,
    promotedProjectId,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'void_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoidItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('raw_transcript')) {
      context.handle(
        _rawTranscriptMeta,
        rawTranscript.isAcceptableOrUnknown(
          data['raw_transcript']!,
          _rawTranscriptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawTranscriptMeta);
    }
    if (data.containsKey('promoted_project_id')) {
      context.handle(
        _promotedProjectIdMeta,
        promotedProjectId.isAcceptableOrUnknown(
          data['promoted_project_id']!,
          _promotedProjectIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoidItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoidItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      type: $VoidItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      rawTranscript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_transcript'],
      )!,
      summarySpans: $VoidItemsTable.$convertersummarySpans.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}summary_spans'],
        )!,
      ),
      structure: $VoidItemsTable.$converterstructure.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}structure'],
        )!,
      ),
      tags: $VoidItemsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      usedInProjectIds: $VoidItemsTable.$converterusedInProjectIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}used_in_project_ids'],
        )!,
      ),
      promotedProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promoted_project_id'],
      ),
      status: $VoidItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $VoidItemsTable createAlias(String alias) {
    return $VoidItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<VoidType, String> $convertertype = const EnumConverter(
    VoidType.values,
  );
  static TypeConverter<List<dynamic>, String> $convertersummarySpans = listJson;
  static TypeConverter<Map<String, dynamic>, String> $converterstructure =
      mapJson;
  static TypeConverter<List<String>, String> $convertertags = strListJson;
  static TypeConverter<List<String>, String> $converterusedInProjectIds =
      strListJson;
  static TypeConverter<VoidStatus, String> $converterstatus =
      const EnumConverter(VoidStatus.values);
}

class VoidItem extends DataClass implements Insertable<VoidItem> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final VoidType type;
  final String summary;
  final String rawTranscript;
  final List<dynamic> summarySpans;
  final Map<String, dynamic> structure;
  final List<String> tags;
  final List<String> usedInProjectIds;
  final String? promotedProjectId;
  final VoidStatus status;
  const VoidItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.summary,
    required this.rawTranscript,
    required this.summarySpans,
    required this.structure,
    required this.tags,
    required this.usedInProjectIds,
    this.promotedProjectId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    {
      map['type'] = Variable<String>(
        $VoidItemsTable.$convertertype.toSql(type),
      );
    }
    map['summary'] = Variable<String>(summary);
    map['raw_transcript'] = Variable<String>(rawTranscript);
    {
      map['summary_spans'] = Variable<String>(
        $VoidItemsTable.$convertersummarySpans.toSql(summarySpans),
      );
    }
    {
      map['structure'] = Variable<String>(
        $VoidItemsTable.$converterstructure.toSql(structure),
      );
    }
    {
      map['tags'] = Variable<String>(
        $VoidItemsTable.$convertertags.toSql(tags),
      );
    }
    {
      map['used_in_project_ids'] = Variable<String>(
        $VoidItemsTable.$converterusedInProjectIds.toSql(usedInProjectIds),
      );
    }
    if (!nullToAbsent || promotedProjectId != null) {
      map['promoted_project_id'] = Variable<String>(promotedProjectId);
    }
    {
      map['status'] = Variable<String>(
        $VoidItemsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  VoidItemsCompanion toCompanion(bool nullToAbsent) {
    return VoidItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      type: Value(type),
      summary: Value(summary),
      rawTranscript: Value(rawTranscript),
      summarySpans: Value(summarySpans),
      structure: Value(structure),
      tags: Value(tags),
      usedInProjectIds: Value(usedInProjectIds),
      promotedProjectId: promotedProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(promotedProjectId),
      status: Value(status),
    );
  }

  factory VoidItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoidItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      type: serializer.fromJson<VoidType>(json['type']),
      summary: serializer.fromJson<String>(json['summary']),
      rawTranscript: serializer.fromJson<String>(json['rawTranscript']),
      summarySpans: serializer.fromJson<List<dynamic>>(json['summarySpans']),
      structure: serializer.fromJson<Map<String, dynamic>>(json['structure']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      usedInProjectIds: serializer.fromJson<List<String>>(
        json['usedInProjectIds'],
      ),
      promotedProjectId: serializer.fromJson<String?>(
        json['promotedProjectId'],
      ),
      status: serializer.fromJson<VoidStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'type': serializer.toJson<VoidType>(type),
      'summary': serializer.toJson<String>(summary),
      'rawTranscript': serializer.toJson<String>(rawTranscript),
      'summarySpans': serializer.toJson<List<dynamic>>(summarySpans),
      'structure': serializer.toJson<Map<String, dynamic>>(structure),
      'tags': serializer.toJson<List<String>>(tags),
      'usedInProjectIds': serializer.toJson<List<String>>(usedInProjectIds),
      'promotedProjectId': serializer.toJson<String?>(promotedProjectId),
      'status': serializer.toJson<VoidStatus>(status),
    };
  }

  VoidItem copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    VoidType? type,
    String? summary,
    String? rawTranscript,
    List<dynamic>? summarySpans,
    Map<String, dynamic>? structure,
    List<String>? tags,
    List<String>? usedInProjectIds,
    Value<String?> promotedProjectId = const Value.absent(),
    VoidStatus? status,
  }) => VoidItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    type: type ?? this.type,
    summary: summary ?? this.summary,
    rawTranscript: rawTranscript ?? this.rawTranscript,
    summarySpans: summarySpans ?? this.summarySpans,
    structure: structure ?? this.structure,
    tags: tags ?? this.tags,
    usedInProjectIds: usedInProjectIds ?? this.usedInProjectIds,
    promotedProjectId: promotedProjectId.present
        ? promotedProjectId.value
        : this.promotedProjectId,
    status: status ?? this.status,
  );
  VoidItem copyWithCompanion(VoidItemsCompanion data) {
    return VoidItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      type: data.type.present ? data.type.value : this.type,
      summary: data.summary.present ? data.summary.value : this.summary,
      rawTranscript: data.rawTranscript.present
          ? data.rawTranscript.value
          : this.rawTranscript,
      summarySpans: data.summarySpans.present
          ? data.summarySpans.value
          : this.summarySpans,
      structure: data.structure.present ? data.structure.value : this.structure,
      tags: data.tags.present ? data.tags.value : this.tags,
      usedInProjectIds: data.usedInProjectIds.present
          ? data.usedInProjectIds.value
          : this.usedInProjectIds,
      promotedProjectId: data.promotedProjectId.present
          ? data.promotedProjectId.value
          : this.promotedProjectId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoidItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript, ')
          ..write('summarySpans: $summarySpans, ')
          ..write('structure: $structure, ')
          ..write('tags: $tags, ')
          ..write('usedInProjectIds: $usedInProjectIds, ')
          ..write('promotedProjectId: $promotedProjectId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    type,
    summary,
    rawTranscript,
    summarySpans,
    structure,
    tags,
    usedInProjectIds,
    promotedProjectId,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoidItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.type == this.type &&
          other.summary == this.summary &&
          other.rawTranscript == this.rawTranscript &&
          other.summarySpans == this.summarySpans &&
          other.structure == this.structure &&
          other.tags == this.tags &&
          other.usedInProjectIds == this.usedInProjectIds &&
          other.promotedProjectId == this.promotedProjectId &&
          other.status == this.status);
}

class VoidItemsCompanion extends UpdateCompanion<VoidItem> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<VoidType> type;
  final Value<String> summary;
  final Value<String> rawTranscript;
  final Value<List<dynamic>> summarySpans;
  final Value<Map<String, dynamic>> structure;
  final Value<List<String>> tags;
  final Value<List<String>> usedInProjectIds;
  final Value<String?> promotedProjectId;
  final Value<VoidStatus> status;
  final Value<int> rowid;
  const VoidItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.summary = const Value.absent(),
    this.rawTranscript = const Value.absent(),
    this.summarySpans = const Value.absent(),
    this.structure = const Value.absent(),
    this.tags = const Value.absent(),
    this.usedInProjectIds = const Value.absent(),
    this.promotedProjectId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoidItemsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required VoidType type,
    required String summary,
    required String rawTranscript,
    required List<dynamic> summarySpans,
    required Map<String, dynamic> structure,
    required List<String> tags,
    required List<String> usedInProjectIds,
    this.promotedProjectId = const Value.absent(),
    required VoidStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       type = Value(type),
       summary = Value(summary),
       rawTranscript = Value(rawTranscript),
       summarySpans = Value(summarySpans),
       structure = Value(structure),
       tags = Value(tags),
       usedInProjectIds = Value(usedInProjectIds),
       status = Value(status);
  static Insertable<VoidItem> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? type,
    Expression<String>? summary,
    Expression<String>? rawTranscript,
    Expression<String>? summarySpans,
    Expression<String>? structure,
    Expression<String>? tags,
    Expression<String>? usedInProjectIds,
    Expression<String>? promotedProjectId,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (type != null) 'type': type,
      if (summary != null) 'summary': summary,
      if (rawTranscript != null) 'raw_transcript': rawTranscript,
      if (summarySpans != null) 'summary_spans': summarySpans,
      if (structure != null) 'structure': structure,
      if (tags != null) 'tags': tags,
      if (usedInProjectIds != null) 'used_in_project_ids': usedInProjectIds,
      if (promotedProjectId != null) 'promoted_project_id': promotedProjectId,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoidItemsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<VoidType>? type,
    Value<String>? summary,
    Value<String>? rawTranscript,
    Value<List<dynamic>>? summarySpans,
    Value<Map<String, dynamic>>? structure,
    Value<List<String>>? tags,
    Value<List<String>>? usedInProjectIds,
    Value<String?>? promotedProjectId,
    Value<VoidStatus>? status,
    Value<int>? rowid,
  }) {
    return VoidItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      summary: summary ?? this.summary,
      rawTranscript: rawTranscript ?? this.rawTranscript,
      summarySpans: summarySpans ?? this.summarySpans,
      structure: structure ?? this.structure,
      tags: tags ?? this.tags,
      usedInProjectIds: usedInProjectIds ?? this.usedInProjectIds,
      promotedProjectId: promotedProjectId ?? this.promotedProjectId,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $VoidItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (rawTranscript.present) {
      map['raw_transcript'] = Variable<String>(rawTranscript.value);
    }
    if (summarySpans.present) {
      map['summary_spans'] = Variable<String>(
        $VoidItemsTable.$convertersummarySpans.toSql(summarySpans.value),
      );
    }
    if (structure.present) {
      map['structure'] = Variable<String>(
        $VoidItemsTable.$converterstructure.toSql(structure.value),
      );
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $VoidItemsTable.$convertertags.toSql(tags.value),
      );
    }
    if (usedInProjectIds.present) {
      map['used_in_project_ids'] = Variable<String>(
        $VoidItemsTable.$converterusedInProjectIds.toSql(
          usedInProjectIds.value,
        ),
      );
    }
    if (promotedProjectId.present) {
      map['promoted_project_id'] = Variable<String>(promotedProjectId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $VoidItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoidItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript, ')
          ..write('summarySpans: $summarySpans, ')
          ..write('structure: $structure, ')
          ..write('tags: $tags, ')
          ..write('usedInProjectIds: $usedInProjectIds, ')
          ..write('promotedProjectId: $promotedProjectId, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlotsTable extends Slots with TableInfo<$SlotsTable, Slot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userEditedMeta = const VerificationMeta(
    'userEdited',
  );
  @override
  late final GeneratedColumn<bool> userEdited = GeneratedColumn<bool>(
    'user_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seedIdMeta = const VerificationMeta('seedId');
  @override
  late final GeneratedColumn<String> seedId = GeneratedColumn<String>(
    'seed_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runtimeProportionMeta = const VerificationMeta(
    'runtimeProportion',
  );
  @override
  late final GeneratedColumn<double> runtimeProportion =
      GeneratedColumn<double>(
        'runtime_proportion',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    templateId,
    position,
    name,
    description,
    runtimeProportion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Slot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('user_edited')) {
      context.handle(
        _userEditedMeta,
        userEdited.isAcceptableOrUnknown(data['user_edited']!, _userEditedMeta),
      );
    }
    if (data.containsKey('seed_id')) {
      context.handle(
        _seedIdMeta,
        seedId.isAcceptableOrUnknown(data['seed_id']!, _seedIdMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('runtime_proportion')) {
      context.handle(
        _runtimeProportionMeta,
        runtimeProportion.isAcceptableOrUnknown(
          data['runtime_proportion']!,
          _runtimeProportionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Slot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Slot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      userEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_edited'],
      )!,
      seedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_id'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      runtimeProportion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}runtime_proportion'],
      ),
    );
  }

  @override
  $SlotsTable createAlias(String alias) {
    return $SlotsTable(attachedDatabase, alias);
  }
}

class Slot extends DataClass implements Insertable<Slot> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final bool builtin;
  final bool userEdited;
  final String? seedId;
  final String templateId;
  final int position;
  final String name;
  final String description;
  final double? runtimeProportion;
  const Slot({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.builtin,
    required this.userEdited,
    this.seedId,
    required this.templateId,
    required this.position,
    required this.name,
    required this.description,
    this.runtimeProportion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['builtin'] = Variable<bool>(builtin);
    map['user_edited'] = Variable<bool>(userEdited);
    if (!nullToAbsent || seedId != null) {
      map['seed_id'] = Variable<String>(seedId);
    }
    map['template_id'] = Variable<String>(templateId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || runtimeProportion != null) {
      map['runtime_proportion'] = Variable<double>(runtimeProportion);
    }
    return map;
  }

  SlotsCompanion toCompanion(bool nullToAbsent) {
    return SlotsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      builtin: Value(builtin),
      userEdited: Value(userEdited),
      seedId: seedId == null && nullToAbsent
          ? const Value.absent()
          : Value(seedId),
      templateId: Value(templateId),
      position: Value(position),
      name: Value(name),
      description: Value(description),
      runtimeProportion: runtimeProportion == null && nullToAbsent
          ? const Value.absent()
          : Value(runtimeProportion),
    );
  }

  factory Slot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Slot(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      userEdited: serializer.fromJson<bool>(json['userEdited']),
      seedId: serializer.fromJson<String?>(json['seedId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      runtimeProportion: serializer.fromJson<double?>(
        json['runtimeProportion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'builtin': serializer.toJson<bool>(builtin),
      'userEdited': serializer.toJson<bool>(userEdited),
      'seedId': serializer.toJson<String?>(seedId),
      'templateId': serializer.toJson<String>(templateId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'runtimeProportion': serializer.toJson<double?>(runtimeProportion),
    };
  }

  Slot copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    bool? builtin,
    bool? userEdited,
    Value<String?> seedId = const Value.absent(),
    String? templateId,
    int? position,
    String? name,
    String? description,
    Value<double?> runtimeProportion = const Value.absent(),
  }) => Slot(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    builtin: builtin ?? this.builtin,
    userEdited: userEdited ?? this.userEdited,
    seedId: seedId.present ? seedId.value : this.seedId,
    templateId: templateId ?? this.templateId,
    position: position ?? this.position,
    name: name ?? this.name,
    description: description ?? this.description,
    runtimeProportion: runtimeProportion.present
        ? runtimeProportion.value
        : this.runtimeProportion,
  );
  Slot copyWithCompanion(SlotsCompanion data) {
    return Slot(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      userEdited: data.userEdited.present
          ? data.userEdited.value
          : this.userEdited,
      seedId: data.seedId.present ? data.seedId.value : this.seedId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      runtimeProportion: data.runtimeProportion.present
          ? data.runtimeProportion.value
          : this.runtimeProportion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Slot(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('templateId: $templateId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('runtimeProportion: $runtimeProportion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    templateId,
    position,
    name,
    description,
    runtimeProportion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Slot &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.builtin == this.builtin &&
          other.userEdited == this.userEdited &&
          other.seedId == this.seedId &&
          other.templateId == this.templateId &&
          other.position == this.position &&
          other.name == this.name &&
          other.description == this.description &&
          other.runtimeProportion == this.runtimeProportion);
}

class SlotsCompanion extends UpdateCompanion<Slot> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> builtin;
  final Value<bool> userEdited;
  final Value<String?> seedId;
  final Value<String> templateId;
  final Value<int> position;
  final Value<String> name;
  final Value<String> description;
  final Value<double?> runtimeProportion;
  final Value<int> rowid;
  const SlotsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.runtimeProportion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlotsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    required String templateId,
    required int position,
    required String name,
    required String description,
    this.runtimeProportion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       templateId = Value(templateId),
       position = Value(position),
       name = Value(name),
       description = Value(description);
  static Insertable<Slot> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? builtin,
    Expression<bool>? userEdited,
    Expression<String>? seedId,
    Expression<String>? templateId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? runtimeProportion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (builtin != null) 'builtin': builtin,
      if (userEdited != null) 'user_edited': userEdited,
      if (seedId != null) 'seed_id': seedId,
      if (templateId != null) 'template_id': templateId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (runtimeProportion != null) 'runtime_proportion': runtimeProportion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlotsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? builtin,
    Value<bool>? userEdited,
    Value<String?>? seedId,
    Value<String>? templateId,
    Value<int>? position,
    Value<String>? name,
    Value<String>? description,
    Value<double?>? runtimeProportion,
    Value<int>? rowid,
  }) {
    return SlotsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      builtin: builtin ?? this.builtin,
      userEdited: userEdited ?? this.userEdited,
      seedId: seedId ?? this.seedId,
      templateId: templateId ?? this.templateId,
      position: position ?? this.position,
      name: name ?? this.name,
      description: description ?? this.description,
      runtimeProportion: runtimeProportion ?? this.runtimeProportion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (userEdited.present) {
      map['user_edited'] = Variable<bool>(userEdited.value);
    }
    if (seedId.present) {
      map['seed_id'] = Variable<String>(seedId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (runtimeProportion.present) {
      map['runtime_proportion'] = Variable<double>(runtimeProportion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlotsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('templateId: $templateId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('runtimeProportion: $runtimeProportion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BeatsTable extends Beats with TableInfo<$BeatsTable, Beat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<String> slotId = GeneratedColumn<String>(
    'slot_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES slots (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  characterIds = GeneratedColumn<String>(
    'character_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($BeatsTable.$convertercharacterIds);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>?, String> blocks =
      GeneratedColumn<String>(
        'blocks',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<dynamic>?>($BeatsTable.$converterblocksn);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>?, String> sayShow =
      GeneratedColumn<String>(
        'say_show',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<dynamic>?>($BeatsTable.$convertersayShown);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    projectId,
    slotId,
    position,
    title,
    description,
    characterIds,
    blocks,
    sayShow,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Beat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('slot_id')) {
      context.handle(
        _slotIdMeta,
        slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Beat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      slotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot_id'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      characterIds: $BeatsTable.$convertercharacterIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}character_ids'],
        )!,
      ),
      blocks: $BeatsTable.$converterblocksn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}blocks'],
        ),
      ),
      sayShow: $BeatsTable.$convertersayShown.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}say_show'],
        ),
      ),
    );
  }

  @override
  $BeatsTable createAlias(String alias) {
    return $BeatsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercharacterIds =
      strListJson;
  static TypeConverter<List<dynamic>, String> $converterblocks = listJson;
  static TypeConverter<List<dynamic>?, String?> $converterblocksn =
      NullAwareTypeConverter.wrap($converterblocks);
  static TypeConverter<List<dynamic>, String> $convertersayShow = listJson;
  static TypeConverter<List<dynamic>?, String?> $convertersayShown =
      NullAwareTypeConverter.wrap($convertersayShow);
}

class Beat extends DataClass implements Insertable<Beat> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String projectId;
  final String? slotId;
  final int position;
  final String title;
  final String description;
  final List<String> characterIds;
  final List<dynamic>? blocks;
  final List<dynamic>? sayShow;
  const Beat({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    this.slotId,
    required this.position,
    required this.title,
    required this.description,
    required this.characterIds,
    this.blocks,
    this.sayShow,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || slotId != null) {
      map['slot_id'] = Variable<String>(slotId);
    }
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['character_ids'] = Variable<String>(
        $BeatsTable.$convertercharacterIds.toSql(characterIds),
      );
    }
    if (!nullToAbsent || blocks != null) {
      map['blocks'] = Variable<String>(
        $BeatsTable.$converterblocksn.toSql(blocks),
      );
    }
    if (!nullToAbsent || sayShow != null) {
      map['say_show'] = Variable<String>(
        $BeatsTable.$convertersayShown.toSql(sayShow),
      );
    }
    return map;
  }

  BeatsCompanion toCompanion(bool nullToAbsent) {
    return BeatsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      projectId: Value(projectId),
      slotId: slotId == null && nullToAbsent
          ? const Value.absent()
          : Value(slotId),
      position: Value(position),
      title: Value(title),
      description: Value(description),
      characterIds: Value(characterIds),
      blocks: blocks == null && nullToAbsent
          ? const Value.absent()
          : Value(blocks),
      sayShow: sayShow == null && nullToAbsent
          ? const Value.absent()
          : Value(sayShow),
    );
  }

  factory Beat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beat(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      slotId: serializer.fromJson<String?>(json['slotId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      characterIds: serializer.fromJson<List<String>>(json['characterIds']),
      blocks: serializer.fromJson<List<dynamic>?>(json['blocks']),
      sayShow: serializer.fromJson<List<dynamic>?>(json['sayShow']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'projectId': serializer.toJson<String>(projectId),
      'slotId': serializer.toJson<String?>(slotId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'characterIds': serializer.toJson<List<String>>(characterIds),
      'blocks': serializer.toJson<List<dynamic>?>(blocks),
      'sayShow': serializer.toJson<List<dynamic>?>(sayShow),
    };
  }

  Beat copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? projectId,
    Value<String?> slotId = const Value.absent(),
    int? position,
    String? title,
    String? description,
    List<String>? characterIds,
    Value<List<dynamic>?> blocks = const Value.absent(),
    Value<List<dynamic>?> sayShow = const Value.absent(),
  }) => Beat(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectId: projectId ?? this.projectId,
    slotId: slotId.present ? slotId.value : this.slotId,
    position: position ?? this.position,
    title: title ?? this.title,
    description: description ?? this.description,
    characterIds: characterIds ?? this.characterIds,
    blocks: blocks.present ? blocks.value : this.blocks,
    sayShow: sayShow.present ? sayShow.value : this.sayShow,
  );
  Beat copyWithCompanion(BeatsCompanion data) {
    return Beat(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      characterIds: data.characterIds.present
          ? data.characterIds.value
          : this.characterIds,
      blocks: data.blocks.present ? data.blocks.value : this.blocks,
      sayShow: data.sayShow.present ? data.sayShow.value : this.sayShow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Beat(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('slotId: $slotId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('characterIds: $characterIds, ')
          ..write('blocks: $blocks, ')
          ..write('sayShow: $sayShow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    projectId,
    slotId,
    position,
    title,
    description,
    characterIds,
    blocks,
    sayShow,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beat &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.projectId == this.projectId &&
          other.slotId == this.slotId &&
          other.position == this.position &&
          other.title == this.title &&
          other.description == this.description &&
          other.characterIds == this.characterIds &&
          other.blocks == this.blocks &&
          other.sayShow == this.sayShow);
}

class BeatsCompanion extends UpdateCompanion<Beat> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> projectId;
  final Value<String?> slotId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> description;
  final Value<List<String>> characterIds;
  final Value<List<dynamic>?> blocks;
  final Value<List<dynamic>?> sayShow;
  final Value<int> rowid;
  const BeatsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.slotId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.characterIds = const Value.absent(),
    this.blocks = const Value.absent(),
    this.sayShow = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BeatsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String projectId,
    this.slotId = const Value.absent(),
    required int position,
    required String title,
    required String description,
    required List<String> characterIds,
    this.blocks = const Value.absent(),
    this.sayShow = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       projectId = Value(projectId),
       position = Value(position),
       title = Value(title),
       description = Value(description),
       characterIds = Value(characterIds);
  static Insertable<Beat> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? projectId,
    Expression<String>? slotId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? characterIds,
    Expression<String>? blocks,
    Expression<String>? sayShow,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (projectId != null) 'project_id': projectId,
      if (slotId != null) 'slot_id': slotId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (characterIds != null) 'character_ids': characterIds,
      if (blocks != null) 'blocks': blocks,
      if (sayShow != null) 'say_show': sayShow,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BeatsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? projectId,
    Value<String?>? slotId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? description,
    Value<List<String>>? characterIds,
    Value<List<dynamic>?>? blocks,
    Value<List<dynamic>?>? sayShow,
    Value<int>? rowid,
  }) {
    return BeatsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId ?? this.projectId,
      slotId: slotId ?? this.slotId,
      position: position ?? this.position,
      title: title ?? this.title,
      description: description ?? this.description,
      characterIds: characterIds ?? this.characterIds,
      blocks: blocks ?? this.blocks,
      sayShow: sayShow ?? this.sayShow,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<String>(slotId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (characterIds.present) {
      map['character_ids'] = Variable<String>(
        $BeatsTable.$convertercharacterIds.toSql(characterIds.value),
      );
    }
    if (blocks.present) {
      map['blocks'] = Variable<String>(
        $BeatsTable.$converterblocksn.toSql(blocks.value),
      );
    }
    if (sayShow.present) {
      map['say_show'] = Variable<String>(
        $BeatsTable.$convertersayShown.toSql(sayShow.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeatsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('slotId: $slotId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('characterIds: $characterIds, ')
          ..write('blocks: $blocks, ')
          ..write('sayShow: $sayShow, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShotsTable extends Shots with TableInfo<$ShotsTable, Shot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userEditedMeta = const VerificationMeta(
    'userEdited',
  );
  @override
  late final GeneratedColumn<bool> userEdited = GeneratedColumn<bool>(
    'user_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seedIdMeta = const VerificationMeta('seedId');
  @override
  late final GeneratedColumn<String> seedId = GeneratedColumn<String>(
    'seed_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ShotCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ShotCategory>($ShotsTable.$convertercategory);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whenToUseMeta = const VerificationMeta(
    'whenToUse',
  );
  @override
  late final GeneratedColumn<String> whenToUse = GeneratedColumn<String>(
    'when_to_use',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectMeta = const VerificationMeta('effect');
  @override
  late final GeneratedColumn<String> effect = GeneratedColumn<String>(
    'effect',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ShotsTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String> sources =
      GeneratedColumn<String>(
        'sources',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<dynamic>>($ShotsTable.$convertersources);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    name,
    category,
    description,
    whenToUse,
    effect,
    tags,
    sources,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('user_edited')) {
      context.handle(
        _userEditedMeta,
        userEdited.isAcceptableOrUnknown(data['user_edited']!, _userEditedMeta),
      );
    }
    if (data.containsKey('seed_id')) {
      context.handle(
        _seedIdMeta,
        seedId.isAcceptableOrUnknown(data['seed_id']!, _seedIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('when_to_use')) {
      context.handle(
        _whenToUseMeta,
        whenToUse.isAcceptableOrUnknown(data['when_to_use']!, _whenToUseMeta),
      );
    } else if (isInserting) {
      context.missing(_whenToUseMeta);
    }
    if (data.containsKey('effect')) {
      context.handle(
        _effectMeta,
        effect.isAcceptableOrUnknown(data['effect']!, _effectMeta),
      );
    } else if (isInserting) {
      context.missing(_effectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      userEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_edited'],
      )!,
      seedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: $ShotsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      whenToUse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}when_to_use'],
      )!,
      effect: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect'],
      )!,
      tags: $ShotsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      sources: $ShotsTable.$convertersources.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sources'],
        )!,
      ),
    );
  }

  @override
  $ShotsTable createAlias(String alias) {
    return $ShotsTable(attachedDatabase, alias);
  }

  static TypeConverter<ShotCategory, String> $convertercategory =
      const EnumConverter(ShotCategory.values);
  static TypeConverter<List<String>, String> $convertertags = strListJson;
  static TypeConverter<List<dynamic>, String> $convertersources = listJson;
}

class Shot extends DataClass implements Insertable<Shot> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final bool builtin;
  final bool userEdited;
  final String? seedId;
  final String name;
  final ShotCategory category;
  final String description;
  final String whenToUse;
  final String effect;
  final List<String> tags;
  final List<dynamic> sources;
  const Shot({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.builtin,
    required this.userEdited,
    this.seedId,
    required this.name,
    required this.category,
    required this.description,
    required this.whenToUse,
    required this.effect,
    required this.tags,
    required this.sources,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['builtin'] = Variable<bool>(builtin);
    map['user_edited'] = Variable<bool>(userEdited);
    if (!nullToAbsent || seedId != null) {
      map['seed_id'] = Variable<String>(seedId);
    }
    map['name'] = Variable<String>(name);
    {
      map['category'] = Variable<String>(
        $ShotsTable.$convertercategory.toSql(category),
      );
    }
    map['description'] = Variable<String>(description);
    map['when_to_use'] = Variable<String>(whenToUse);
    map['effect'] = Variable<String>(effect);
    {
      map['tags'] = Variable<String>($ShotsTable.$convertertags.toSql(tags));
    }
    {
      map['sources'] = Variable<String>(
        $ShotsTable.$convertersources.toSql(sources),
      );
    }
    return map;
  }

  ShotsCompanion toCompanion(bool nullToAbsent) {
    return ShotsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      builtin: Value(builtin),
      userEdited: Value(userEdited),
      seedId: seedId == null && nullToAbsent
          ? const Value.absent()
          : Value(seedId),
      name: Value(name),
      category: Value(category),
      description: Value(description),
      whenToUse: Value(whenToUse),
      effect: Value(effect),
      tags: Value(tags),
      sources: Value(sources),
    );
  }

  factory Shot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shot(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      userEdited: serializer.fromJson<bool>(json['userEdited']),
      seedId: serializer.fromJson<String?>(json['seedId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<ShotCategory>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      whenToUse: serializer.fromJson<String>(json['whenToUse']),
      effect: serializer.fromJson<String>(json['effect']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      sources: serializer.fromJson<List<dynamic>>(json['sources']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'builtin': serializer.toJson<bool>(builtin),
      'userEdited': serializer.toJson<bool>(userEdited),
      'seedId': serializer.toJson<String?>(seedId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<ShotCategory>(category),
      'description': serializer.toJson<String>(description),
      'whenToUse': serializer.toJson<String>(whenToUse),
      'effect': serializer.toJson<String>(effect),
      'tags': serializer.toJson<List<String>>(tags),
      'sources': serializer.toJson<List<dynamic>>(sources),
    };
  }

  Shot copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    bool? builtin,
    bool? userEdited,
    Value<String?> seedId = const Value.absent(),
    String? name,
    ShotCategory? category,
    String? description,
    String? whenToUse,
    String? effect,
    List<String>? tags,
    List<dynamic>? sources,
  }) => Shot(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    builtin: builtin ?? this.builtin,
    userEdited: userEdited ?? this.userEdited,
    seedId: seedId.present ? seedId.value : this.seedId,
    name: name ?? this.name,
    category: category ?? this.category,
    description: description ?? this.description,
    whenToUse: whenToUse ?? this.whenToUse,
    effect: effect ?? this.effect,
    tags: tags ?? this.tags,
    sources: sources ?? this.sources,
  );
  Shot copyWithCompanion(ShotsCompanion data) {
    return Shot(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      userEdited: data.userEdited.present
          ? data.userEdited.value
          : this.userEdited,
      seedId: data.seedId.present ? data.seedId.value : this.seedId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      whenToUse: data.whenToUse.present ? data.whenToUse.value : this.whenToUse,
      effect: data.effect.present ? data.effect.value : this.effect,
      tags: data.tags.present ? data.tags.value : this.tags,
      sources: data.sources.present ? data.sources.value : this.sources,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shot(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('whenToUse: $whenToUse, ')
          ..write('effect: $effect, ')
          ..write('tags: $tags, ')
          ..write('sources: $sources')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    name,
    category,
    description,
    whenToUse,
    effect,
    tags,
    sources,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shot &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.builtin == this.builtin &&
          other.userEdited == this.userEdited &&
          other.seedId == this.seedId &&
          other.name == this.name &&
          other.category == this.category &&
          other.description == this.description &&
          other.whenToUse == this.whenToUse &&
          other.effect == this.effect &&
          other.tags == this.tags &&
          other.sources == this.sources);
}

class ShotsCompanion extends UpdateCompanion<Shot> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> builtin;
  final Value<bool> userEdited;
  final Value<String?> seedId;
  final Value<String> name;
  final Value<ShotCategory> category;
  final Value<String> description;
  final Value<String> whenToUse;
  final Value<String> effect;
  final Value<List<String>> tags;
  final Value<List<dynamic>> sources;
  final Value<int> rowid;
  const ShotsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.whenToUse = const Value.absent(),
    this.effect = const Value.absent(),
    this.tags = const Value.absent(),
    this.sources = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShotsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    required String name,
    required ShotCategory category,
    required String description,
    required String whenToUse,
    required String effect,
    required List<String> tags,
    required List<dynamic> sources,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       category = Value(category),
       description = Value(description),
       whenToUse = Value(whenToUse),
       effect = Value(effect),
       tags = Value(tags),
       sources = Value(sources);
  static Insertable<Shot> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? builtin,
    Expression<bool>? userEdited,
    Expression<String>? seedId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? whenToUse,
    Expression<String>? effect,
    Expression<String>? tags,
    Expression<String>? sources,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (builtin != null) 'builtin': builtin,
      if (userEdited != null) 'user_edited': userEdited,
      if (seedId != null) 'seed_id': seedId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (whenToUse != null) 'when_to_use': whenToUse,
      if (effect != null) 'effect': effect,
      if (tags != null) 'tags': tags,
      if (sources != null) 'sources': sources,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShotsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? builtin,
    Value<bool>? userEdited,
    Value<String?>? seedId,
    Value<String>? name,
    Value<ShotCategory>? category,
    Value<String>? description,
    Value<String>? whenToUse,
    Value<String>? effect,
    Value<List<String>>? tags,
    Value<List<dynamic>>? sources,
    Value<int>? rowid,
  }) {
    return ShotsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      builtin: builtin ?? this.builtin,
      userEdited: userEdited ?? this.userEdited,
      seedId: seedId ?? this.seedId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      whenToUse: whenToUse ?? this.whenToUse,
      effect: effect ?? this.effect,
      tags: tags ?? this.tags,
      sources: sources ?? this.sources,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (userEdited.present) {
      map['user_edited'] = Variable<bool>(userEdited.value);
    }
    if (seedId.present) {
      map['seed_id'] = Variable<String>(seedId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ShotsTable.$convertercategory.toSql(category.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (whenToUse.present) {
      map['when_to_use'] = Variable<String>(whenToUse.value);
    }
    if (effect.present) {
      map['effect'] = Variable<String>(effect.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $ShotsTable.$convertertags.toSql(tags.value),
      );
    }
    if (sources.present) {
      map['sources'] = Variable<String>(
        $ShotsTable.$convertersources.toSql(sources.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShotsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('whenToUse: $whenToUse, ')
          ..write('effect: $effect, ')
          ..write('tags: $tags, ')
          ..write('sources: $sources, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FramesTable extends Frames with TableInfo<$FramesTable, Frame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FramesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beatIdMeta = const VerificationMeta('beatId');
  @override
  late final GeneratedColumn<String> beatId = GeneratedColumn<String>(
    'beat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES beats (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strokesPathMeta = const VerificationMeta(
    'strokesPath',
  );
  @override
  late final GeneratedColumn<String> strokesPath = GeneratedColumn<String>(
    'strokes_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<String> aspectRatio = GeneratedColumn<String>(
    'aspect_ratio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shotSizeMeta = const VerificationMeta(
    'shotSize',
  );
  @override
  late final GeneratedColumn<String> shotSize = GeneratedColumn<String>(
    'shot_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _angleMeta = const VerificationMeta('angle');
  @override
  late final GeneratedColumn<String> angle = GeneratedColumn<String>(
    'angle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movementMeta = const VerificationMeta(
    'movement',
  );
  @override
  late final GeneratedColumn<String> movement = GeneratedColumn<String>(
    'movement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lensFeelMeta = const VerificationMeta(
    'lensFeel',
  );
  @override
  late final GeneratedColumn<String> lensFeel = GeneratedColumn<String>(
    'lens_feel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<String> blockId = GeneratedColumn<String>(
    'block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  characterIds = GeneratedColumn<String>(
    'character_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($FramesTable.$convertercharacterIds);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String>
  referenceImages = GeneratedColumn<String>(
    'reference_images',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<dynamic>>($FramesTable.$converterreferenceImages);
  static const VerificationMeta _shotIdMeta = const VerificationMeta('shotId');
  @override
  late final GeneratedColumn<String> shotId = GeneratedColumn<String>(
    'shot_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shots (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    beatId,
    position,
    strokesPath,
    thumbnailPath,
    aspectRatio,
    shotSize,
    angle,
    movement,
    lensFeel,
    durationMs,
    notes,
    blockId,
    characterIds,
    referenceImages,
    shotId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'frames';
  @override
  VerificationContext validateIntegrity(
    Insertable<Frame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('beat_id')) {
      context.handle(
        _beatIdMeta,
        beatId.isAcceptableOrUnknown(data['beat_id']!, _beatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_beatIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('strokes_path')) {
      context.handle(
        _strokesPathMeta,
        strokesPath.isAcceptableOrUnknown(
          data['strokes_path']!,
          _strokesPathMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('shot_size')) {
      context.handle(
        _shotSizeMeta,
        shotSize.isAcceptableOrUnknown(data['shot_size']!, _shotSizeMeta),
      );
    }
    if (data.containsKey('angle')) {
      context.handle(
        _angleMeta,
        angle.isAcceptableOrUnknown(data['angle']!, _angleMeta),
      );
    }
    if (data.containsKey('movement')) {
      context.handle(
        _movementMeta,
        movement.isAcceptableOrUnknown(data['movement']!, _movementMeta),
      );
    }
    if (data.containsKey('lens_feel')) {
      context.handle(
        _lensFeelMeta,
        lensFeel.isAcceptableOrUnknown(data['lens_feel']!, _lensFeelMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    }
    if (data.containsKey('shot_id')) {
      context.handle(
        _shotIdMeta,
        shotId.isAcceptableOrUnknown(data['shot_id']!, _shotIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Frame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Frame(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      beatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beat_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      strokesPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strokes_path'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aspect_ratio'],
      ),
      shotSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shot_size'],
      ),
      angle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}angle'],
      ),
      movement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement'],
      ),
      lensFeel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lens_feel'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_id'],
      ),
      characterIds: $FramesTable.$convertercharacterIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}character_ids'],
        )!,
      ),
      referenceImages: $FramesTable.$converterreferenceImages.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reference_images'],
        )!,
      ),
      shotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shot_id'],
      ),
    );
  }

  @override
  $FramesTable createAlias(String alias) {
    return $FramesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercharacterIds =
      strListJson;
  static TypeConverter<List<dynamic>, String> $converterreferenceImages =
      listJson;
}

class Frame extends DataClass implements Insertable<Frame> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String beatId;
  final int position;
  final String? strokesPath;
  final String? thumbnailPath;
  final String? aspectRatio;
  final String? shotSize;
  final String? angle;
  final String? movement;
  final String? lensFeel;
  final int? durationMs;
  final String notes;
  final String? blockId;
  final List<String> characterIds;
  final List<dynamic> referenceImages;
  final String? shotId;
  const Frame({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.beatId,
    required this.position,
    this.strokesPath,
    this.thumbnailPath,
    this.aspectRatio,
    this.shotSize,
    this.angle,
    this.movement,
    this.lensFeel,
    this.durationMs,
    required this.notes,
    this.blockId,
    required this.characterIds,
    required this.referenceImages,
    this.shotId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['beat_id'] = Variable<String>(beatId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || strokesPath != null) {
      map['strokes_path'] = Variable<String>(strokesPath);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || aspectRatio != null) {
      map['aspect_ratio'] = Variable<String>(aspectRatio);
    }
    if (!nullToAbsent || shotSize != null) {
      map['shot_size'] = Variable<String>(shotSize);
    }
    if (!nullToAbsent || angle != null) {
      map['angle'] = Variable<String>(angle);
    }
    if (!nullToAbsent || movement != null) {
      map['movement'] = Variable<String>(movement);
    }
    if (!nullToAbsent || lensFeel != null) {
      map['lens_feel'] = Variable<String>(lensFeel);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || blockId != null) {
      map['block_id'] = Variable<String>(blockId);
    }
    {
      map['character_ids'] = Variable<String>(
        $FramesTable.$convertercharacterIds.toSql(characterIds),
      );
    }
    {
      map['reference_images'] = Variable<String>(
        $FramesTable.$converterreferenceImages.toSql(referenceImages),
      );
    }
    if (!nullToAbsent || shotId != null) {
      map['shot_id'] = Variable<String>(shotId);
    }
    return map;
  }

  FramesCompanion toCompanion(bool nullToAbsent) {
    return FramesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      beatId: Value(beatId),
      position: Value(position),
      strokesPath: strokesPath == null && nullToAbsent
          ? const Value.absent()
          : Value(strokesPath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      aspectRatio: aspectRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(aspectRatio),
      shotSize: shotSize == null && nullToAbsent
          ? const Value.absent()
          : Value(shotSize),
      angle: angle == null && nullToAbsent
          ? const Value.absent()
          : Value(angle),
      movement: movement == null && nullToAbsent
          ? const Value.absent()
          : Value(movement),
      lensFeel: lensFeel == null && nullToAbsent
          ? const Value.absent()
          : Value(lensFeel),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      notes: Value(notes),
      blockId: blockId == null && nullToAbsent
          ? const Value.absent()
          : Value(blockId),
      characterIds: Value(characterIds),
      referenceImages: Value(referenceImages),
      shotId: shotId == null && nullToAbsent
          ? const Value.absent()
          : Value(shotId),
    );
  }

  factory Frame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Frame(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      beatId: serializer.fromJson<String>(json['beatId']),
      position: serializer.fromJson<int>(json['position']),
      strokesPath: serializer.fromJson<String?>(json['strokesPath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      aspectRatio: serializer.fromJson<String?>(json['aspectRatio']),
      shotSize: serializer.fromJson<String?>(json['shotSize']),
      angle: serializer.fromJson<String?>(json['angle']),
      movement: serializer.fromJson<String?>(json['movement']),
      lensFeel: serializer.fromJson<String?>(json['lensFeel']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      notes: serializer.fromJson<String>(json['notes']),
      blockId: serializer.fromJson<String?>(json['blockId']),
      characterIds: serializer.fromJson<List<String>>(json['characterIds']),
      referenceImages: serializer.fromJson<List<dynamic>>(
        json['referenceImages'],
      ),
      shotId: serializer.fromJson<String?>(json['shotId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'beatId': serializer.toJson<String>(beatId),
      'position': serializer.toJson<int>(position),
      'strokesPath': serializer.toJson<String?>(strokesPath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'aspectRatio': serializer.toJson<String?>(aspectRatio),
      'shotSize': serializer.toJson<String?>(shotSize),
      'angle': serializer.toJson<String?>(angle),
      'movement': serializer.toJson<String?>(movement),
      'lensFeel': serializer.toJson<String?>(lensFeel),
      'durationMs': serializer.toJson<int?>(durationMs),
      'notes': serializer.toJson<String>(notes),
      'blockId': serializer.toJson<String?>(blockId),
      'characterIds': serializer.toJson<List<String>>(characterIds),
      'referenceImages': serializer.toJson<List<dynamic>>(referenceImages),
      'shotId': serializer.toJson<String?>(shotId),
    };
  }

  Frame copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? beatId,
    int? position,
    Value<String?> strokesPath = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> aspectRatio = const Value.absent(),
    Value<String?> shotSize = const Value.absent(),
    Value<String?> angle = const Value.absent(),
    Value<String?> movement = const Value.absent(),
    Value<String?> lensFeel = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    String? notes,
    Value<String?> blockId = const Value.absent(),
    List<String>? characterIds,
    List<dynamic>? referenceImages,
    Value<String?> shotId = const Value.absent(),
  }) => Frame(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    beatId: beatId ?? this.beatId,
    position: position ?? this.position,
    strokesPath: strokesPath.present ? strokesPath.value : this.strokesPath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    aspectRatio: aspectRatio.present ? aspectRatio.value : this.aspectRatio,
    shotSize: shotSize.present ? shotSize.value : this.shotSize,
    angle: angle.present ? angle.value : this.angle,
    movement: movement.present ? movement.value : this.movement,
    lensFeel: lensFeel.present ? lensFeel.value : this.lensFeel,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    notes: notes ?? this.notes,
    blockId: blockId.present ? blockId.value : this.blockId,
    characterIds: characterIds ?? this.characterIds,
    referenceImages: referenceImages ?? this.referenceImages,
    shotId: shotId.present ? shotId.value : this.shotId,
  );
  Frame copyWithCompanion(FramesCompanion data) {
    return Frame(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      beatId: data.beatId.present ? data.beatId.value : this.beatId,
      position: data.position.present ? data.position.value : this.position,
      strokesPath: data.strokesPath.present
          ? data.strokesPath.value
          : this.strokesPath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      shotSize: data.shotSize.present ? data.shotSize.value : this.shotSize,
      angle: data.angle.present ? data.angle.value : this.angle,
      movement: data.movement.present ? data.movement.value : this.movement,
      lensFeel: data.lensFeel.present ? data.lensFeel.value : this.lensFeel,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      notes: data.notes.present ? data.notes.value : this.notes,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      characterIds: data.characterIds.present
          ? data.characterIds.value
          : this.characterIds,
      referenceImages: data.referenceImages.present
          ? data.referenceImages.value
          : this.referenceImages,
      shotId: data.shotId.present ? data.shotId.value : this.shotId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Frame(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('beatId: $beatId, ')
          ..write('position: $position, ')
          ..write('strokesPath: $strokesPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('shotSize: $shotSize, ')
          ..write('angle: $angle, ')
          ..write('movement: $movement, ')
          ..write('lensFeel: $lensFeel, ')
          ..write('durationMs: $durationMs, ')
          ..write('notes: $notes, ')
          ..write('blockId: $blockId, ')
          ..write('characterIds: $characterIds, ')
          ..write('referenceImages: $referenceImages, ')
          ..write('shotId: $shotId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    beatId,
    position,
    strokesPath,
    thumbnailPath,
    aspectRatio,
    shotSize,
    angle,
    movement,
    lensFeel,
    durationMs,
    notes,
    blockId,
    characterIds,
    referenceImages,
    shotId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Frame &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.beatId == this.beatId &&
          other.position == this.position &&
          other.strokesPath == this.strokesPath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.aspectRatio == this.aspectRatio &&
          other.shotSize == this.shotSize &&
          other.angle == this.angle &&
          other.movement == this.movement &&
          other.lensFeel == this.lensFeel &&
          other.durationMs == this.durationMs &&
          other.notes == this.notes &&
          other.blockId == this.blockId &&
          other.characterIds == this.characterIds &&
          other.referenceImages == this.referenceImages &&
          other.shotId == this.shotId);
}

class FramesCompanion extends UpdateCompanion<Frame> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> beatId;
  final Value<int> position;
  final Value<String?> strokesPath;
  final Value<String?> thumbnailPath;
  final Value<String?> aspectRatio;
  final Value<String?> shotSize;
  final Value<String?> angle;
  final Value<String?> movement;
  final Value<String?> lensFeel;
  final Value<int?> durationMs;
  final Value<String> notes;
  final Value<String?> blockId;
  final Value<List<String>> characterIds;
  final Value<List<dynamic>> referenceImages;
  final Value<String?> shotId;
  final Value<int> rowid;
  const FramesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.beatId = const Value.absent(),
    this.position = const Value.absent(),
    this.strokesPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.shotSize = const Value.absent(),
    this.angle = const Value.absent(),
    this.movement = const Value.absent(),
    this.lensFeel = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.notes = const Value.absent(),
    this.blockId = const Value.absent(),
    this.characterIds = const Value.absent(),
    this.referenceImages = const Value.absent(),
    this.shotId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FramesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String beatId,
    required int position,
    this.strokesPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.shotSize = const Value.absent(),
    this.angle = const Value.absent(),
    this.movement = const Value.absent(),
    this.lensFeel = const Value.absent(),
    this.durationMs = const Value.absent(),
    required String notes,
    this.blockId = const Value.absent(),
    required List<String> characterIds,
    required List<dynamic> referenceImages,
    this.shotId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       beatId = Value(beatId),
       position = Value(position),
       notes = Value(notes),
       characterIds = Value(characterIds),
       referenceImages = Value(referenceImages);
  static Insertable<Frame> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? beatId,
    Expression<int>? position,
    Expression<String>? strokesPath,
    Expression<String>? thumbnailPath,
    Expression<String>? aspectRatio,
    Expression<String>? shotSize,
    Expression<String>? angle,
    Expression<String>? movement,
    Expression<String>? lensFeel,
    Expression<int>? durationMs,
    Expression<String>? notes,
    Expression<String>? blockId,
    Expression<String>? characterIds,
    Expression<String>? referenceImages,
    Expression<String>? shotId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (beatId != null) 'beat_id': beatId,
      if (position != null) 'position': position,
      if (strokesPath != null) 'strokes_path': strokesPath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (shotSize != null) 'shot_size': shotSize,
      if (angle != null) 'angle': angle,
      if (movement != null) 'movement': movement,
      if (lensFeel != null) 'lens_feel': lensFeel,
      if (durationMs != null) 'duration_ms': durationMs,
      if (notes != null) 'notes': notes,
      if (blockId != null) 'block_id': blockId,
      if (characterIds != null) 'character_ids': characterIds,
      if (referenceImages != null) 'reference_images': referenceImages,
      if (shotId != null) 'shot_id': shotId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FramesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? beatId,
    Value<int>? position,
    Value<String?>? strokesPath,
    Value<String?>? thumbnailPath,
    Value<String?>? aspectRatio,
    Value<String?>? shotSize,
    Value<String?>? angle,
    Value<String?>? movement,
    Value<String?>? lensFeel,
    Value<int?>? durationMs,
    Value<String>? notes,
    Value<String?>? blockId,
    Value<List<String>>? characterIds,
    Value<List<dynamic>>? referenceImages,
    Value<String?>? shotId,
    Value<int>? rowid,
  }) {
    return FramesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      beatId: beatId ?? this.beatId,
      position: position ?? this.position,
      strokesPath: strokesPath ?? this.strokesPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      shotSize: shotSize ?? this.shotSize,
      angle: angle ?? this.angle,
      movement: movement ?? this.movement,
      lensFeel: lensFeel ?? this.lensFeel,
      durationMs: durationMs ?? this.durationMs,
      notes: notes ?? this.notes,
      blockId: blockId ?? this.blockId,
      characterIds: characterIds ?? this.characterIds,
      referenceImages: referenceImages ?? this.referenceImages,
      shotId: shotId ?? this.shotId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (beatId.present) {
      map['beat_id'] = Variable<String>(beatId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (strokesPath.present) {
      map['strokes_path'] = Variable<String>(strokesPath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<String>(aspectRatio.value);
    }
    if (shotSize.present) {
      map['shot_size'] = Variable<String>(shotSize.value);
    }
    if (angle.present) {
      map['angle'] = Variable<String>(angle.value);
    }
    if (movement.present) {
      map['movement'] = Variable<String>(movement.value);
    }
    if (lensFeel.present) {
      map['lens_feel'] = Variable<String>(lensFeel.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<String>(blockId.value);
    }
    if (characterIds.present) {
      map['character_ids'] = Variable<String>(
        $FramesTable.$convertercharacterIds.toSql(characterIds.value),
      );
    }
    if (referenceImages.present) {
      map['reference_images'] = Variable<String>(
        $FramesTable.$converterreferenceImages.toSql(referenceImages.value),
      );
    }
    if (shotId.present) {
      map['shot_id'] = Variable<String>(shotId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FramesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('beatId: $beatId, ')
          ..write('position: $position, ')
          ..write('strokesPath: $strokesPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('shotSize: $shotSize, ')
          ..write('angle: $angle, ')
          ..write('movement: $movement, ')
          ..write('lensFeel: $lensFeel, ')
          ..write('durationMs: $durationMs, ')
          ..write('notes: $notes, ')
          ..write('blockId: $blockId, ')
          ..write('characterIds: $characterIds, ')
          ..write('referenceImages: $referenceImages, ')
          ..write('shotId: $shotId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, Snapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SnapshotReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SnapshotReason>($SnapshotsTable.$converterreason);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proposalIdMeta = const VerificationMeta(
    'proposalId',
  );
  @override
  late final GeneratedColumn<String> proposalId = GeneratedColumn<String>(
    'proposal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restoredFromSnapshotIdMeta =
      const VerificationMeta('restoredFromSnapshotId');
  @override
  late final GeneratedColumn<String> restoredFromSnapshotId =
      GeneratedColumn<String>(
        'restored_from_snapshot_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($SnapshotsTable.$converterdata);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    reason,
    label,
    proposalId,
    restoredFromSnapshotId,
    data,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('proposal_id')) {
      context.handle(
        _proposalIdMeta,
        proposalId.isAcceptableOrUnknown(data['proposal_id']!, _proposalIdMeta),
      );
    }
    if (data.containsKey('restored_from_snapshot_id')) {
      context.handle(
        _restoredFromSnapshotIdMeta,
        restoredFromSnapshotId.isAcceptableOrUnknown(
          data['restored_from_snapshot_id']!,
          _restoredFromSnapshotIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      reason: $SnapshotsTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      proposalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_id'],
      ),
      restoredFromSnapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restored_from_snapshot_id'],
      ),
      data: $SnapshotsTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }

  static TypeConverter<SnapshotReason, String> $converterreason =
      const EnumConverter(SnapshotReason.values);
  static TypeConverter<Map<String, dynamic>, String> $converterdata = mapJson;
}

class Snapshot extends DataClass implements Insertable<Snapshot> {
  final String id;
  final String projectId;
  final SnapshotReason reason;
  final String label;
  final String? proposalId;
  final String? restoredFromSnapshotId;
  final Map<String, dynamic> data;
  final int createdAt;
  const Snapshot({
    required this.id,
    required this.projectId,
    required this.reason,
    required this.label,
    this.proposalId,
    this.restoredFromSnapshotId,
    required this.data,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    {
      map['reason'] = Variable<String>(
        $SnapshotsTable.$converterreason.toSql(reason),
      );
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || proposalId != null) {
      map['proposal_id'] = Variable<String>(proposalId);
    }
    if (!nullToAbsent || restoredFromSnapshotId != null) {
      map['restored_from_snapshot_id'] = Variable<String>(
        restoredFromSnapshotId,
      );
    }
    {
      map['data'] = Variable<String>(
        $SnapshotsTable.$converterdata.toSql(data),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      reason: Value(reason),
      label: Value(label),
      proposalId: proposalId == null && nullToAbsent
          ? const Value.absent()
          : Value(proposalId),
      restoredFromSnapshotId: restoredFromSnapshotId == null && nullToAbsent
          ? const Value.absent()
          : Value(restoredFromSnapshotId),
      data: Value(data),
      createdAt: Value(createdAt),
    );
  }

  factory Snapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snapshot(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      reason: serializer.fromJson<SnapshotReason>(json['reason']),
      label: serializer.fromJson<String>(json['label']),
      proposalId: serializer.fromJson<String?>(json['proposalId']),
      restoredFromSnapshotId: serializer.fromJson<String?>(
        json['restoredFromSnapshotId'],
      ),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'reason': serializer.toJson<SnapshotReason>(reason),
      'label': serializer.toJson<String>(label),
      'proposalId': serializer.toJson<String?>(proposalId),
      'restoredFromSnapshotId': serializer.toJson<String?>(
        restoredFromSnapshotId,
      ),
      'data': serializer.toJson<Map<String, dynamic>>(data),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Snapshot copyWith({
    String? id,
    String? projectId,
    SnapshotReason? reason,
    String? label,
    Value<String?> proposalId = const Value.absent(),
    Value<String?> restoredFromSnapshotId = const Value.absent(),
    Map<String, dynamic>? data,
    int? createdAt,
  }) => Snapshot(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    reason: reason ?? this.reason,
    label: label ?? this.label,
    proposalId: proposalId.present ? proposalId.value : this.proposalId,
    restoredFromSnapshotId: restoredFromSnapshotId.present
        ? restoredFromSnapshotId.value
        : this.restoredFromSnapshotId,
    data: data ?? this.data,
    createdAt: createdAt ?? this.createdAt,
  );
  Snapshot copyWithCompanion(SnapshotsCompanion data) {
    return Snapshot(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      reason: data.reason.present ? data.reason.value : this.reason,
      label: data.label.present ? data.label.value : this.label,
      proposalId: data.proposalId.present
          ? data.proposalId.value
          : this.proposalId,
      restoredFromSnapshotId: data.restoredFromSnapshotId.present
          ? data.restoredFromSnapshotId.value
          : this.restoredFromSnapshotId,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snapshot(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('reason: $reason, ')
          ..write('label: $label, ')
          ..write('proposalId: $proposalId, ')
          ..write('restoredFromSnapshotId: $restoredFromSnapshotId, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    reason,
    label,
    proposalId,
    restoredFromSnapshotId,
    data,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snapshot &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.reason == this.reason &&
          other.label == this.label &&
          other.proposalId == this.proposalId &&
          other.restoredFromSnapshotId == this.restoredFromSnapshotId &&
          other.data == this.data &&
          other.createdAt == this.createdAt);
}

class SnapshotsCompanion extends UpdateCompanion<Snapshot> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<SnapshotReason> reason;
  final Value<String> label;
  final Value<String?> proposalId;
  final Value<String?> restoredFromSnapshotId;
  final Value<Map<String, dynamic>> data;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.reason = const Value.absent(),
    this.label = const Value.absent(),
    this.proposalId = const Value.absent(),
    this.restoredFromSnapshotId = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    required String id,
    required String projectId,
    required SnapshotReason reason,
    required String label,
    this.proposalId = const Value.absent(),
    this.restoredFromSnapshotId = const Value.absent(),
    required Map<String, dynamic> data,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       reason = Value(reason),
       label = Value(label),
       data = Value(data),
       createdAt = Value(createdAt);
  static Insertable<Snapshot> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? reason,
    Expression<String>? label,
    Expression<String>? proposalId,
    Expression<String>? restoredFromSnapshotId,
    Expression<String>? data,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (reason != null) 'reason': reason,
      if (label != null) 'label': label,
      if (proposalId != null) 'proposal_id': proposalId,
      if (restoredFromSnapshotId != null)
        'restored_from_snapshot_id': restoredFromSnapshotId,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<SnapshotReason>? reason,
    Value<String>? label,
    Value<String?>? proposalId,
    Value<String?>? restoredFromSnapshotId,
    Value<Map<String, dynamic>>? data,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      reason: reason ?? this.reason,
      label: label ?? this.label,
      proposalId: proposalId ?? this.proposalId,
      restoredFromSnapshotId:
          restoredFromSnapshotId ?? this.restoredFromSnapshotId,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $SnapshotsTable.$converterreason.toSql(reason.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (proposalId.present) {
      map['proposal_id'] = Variable<String>(proposalId.value);
    }
    if (restoredFromSnapshotId.present) {
      map['restored_from_snapshot_id'] = Variable<String>(
        restoredFromSnapshotId.value,
      );
    }
    if (data.present) {
      map['data'] = Variable<String>(
        $SnapshotsTable.$converterdata.toSql(data.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('reason: $reason, ')
          ..write('label: $label, ')
          ..write('proposalId: $proposalId, ')
          ..write('restoredFromSnapshotId: $restoredFromSnapshotId, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProposalsTable extends Proposals
    with TableInfo<$ProposalsTable, Proposal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProposalStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProposalStatus>($ProposalsTable.$converterstatus);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTranscriptMeta = const VerificationMeta(
    'rawTranscript',
  );
  @override
  late final GeneratedColumn<String> rawTranscript = GeneratedColumn<String>(
    'raw_transcript',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String>
  summarySpans = GeneratedColumn<String>(
    'summary_spans',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<dynamic>>($ProposalsTable.$convertersummarySpans);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String> changes =
      GeneratedColumn<String>(
        'changes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<dynamic>>($ProposalsTable.$converterchanges);
  static const VerificationMeta _sourceVoidItemIdMeta = const VerificationMeta(
    'sourceVoidItemId',
  );
  @override
  late final GeneratedColumn<String> sourceVoidItemId = GeneratedColumn<String>(
    'source_void_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES void_items (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _rejectedToVoidItemIdMeta =
      const VerificationMeta('rejectedToVoidItemId');
  @override
  late final GeneratedColumn<String> rejectedToVoidItemId =
      GeneratedColumn<String>(
        'rejected_to_void_item_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES void_items (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _snapshotIdMeta = const VerificationMeta(
    'snapshotId',
  );
  @override
  late final GeneratedColumn<String> snapshotId = GeneratedColumn<String>(
    'snapshot_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES snapshots (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<int> resolvedAt = GeneratedColumn<int>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    projectId,
    status,
    summary,
    rawTranscript,
    summarySpans,
    changes,
    sourceVoidItemId,
    rejectedToVoidItemId,
    snapshotId,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proposal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('raw_transcript')) {
      context.handle(
        _rawTranscriptMeta,
        rawTranscript.isAcceptableOrUnknown(
          data['raw_transcript']!,
          _rawTranscriptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawTranscriptMeta);
    }
    if (data.containsKey('source_void_item_id')) {
      context.handle(
        _sourceVoidItemIdMeta,
        sourceVoidItemId.isAcceptableOrUnknown(
          data['source_void_item_id']!,
          _sourceVoidItemIdMeta,
        ),
      );
    }
    if (data.containsKey('rejected_to_void_item_id')) {
      context.handle(
        _rejectedToVoidItemIdMeta,
        rejectedToVoidItemId.isAcceptableOrUnknown(
          data['rejected_to_void_item_id']!,
          _rejectedToVoidItemIdMeta,
        ),
      );
    }
    if (data.containsKey('snapshot_id')) {
      context.handle(
        _snapshotIdMeta,
        snapshotId.isAcceptableOrUnknown(data['snapshot_id']!, _snapshotIdMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Proposal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proposal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      status: $ProposalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      rawTranscript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_transcript'],
      )!,
      summarySpans: $ProposalsTable.$convertersummarySpans.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}summary_spans'],
        )!,
      ),
      changes: $ProposalsTable.$converterchanges.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}changes'],
        )!,
      ),
      sourceVoidItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_void_item_id'],
      ),
      rejectedToVoidItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejected_to_void_item_id'],
      ),
      snapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_id'],
      ),
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $ProposalsTable createAlias(String alias) {
    return $ProposalsTable(attachedDatabase, alias);
  }

  static TypeConverter<ProposalStatus, String> $converterstatus =
      const EnumConverter(ProposalStatus.values);
  static TypeConverter<List<dynamic>, String> $convertersummarySpans = listJson;
  static TypeConverter<List<dynamic>, String> $converterchanges = listJson;
}

class Proposal extends DataClass implements Insertable<Proposal> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String projectId;
  final ProposalStatus status;
  final String summary;
  final String rawTranscript;
  final List<dynamic> summarySpans;
  final List<dynamic> changes;
  final String? sourceVoidItemId;
  final String? rejectedToVoidItemId;
  final String? snapshotId;
  final int? resolvedAt;
  const Proposal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    required this.status,
    required this.summary,
    required this.rawTranscript,
    required this.summarySpans,
    required this.changes,
    this.sourceVoidItemId,
    this.rejectedToVoidItemId,
    this.snapshotId,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['project_id'] = Variable<String>(projectId);
    {
      map['status'] = Variable<String>(
        $ProposalsTable.$converterstatus.toSql(status),
      );
    }
    map['summary'] = Variable<String>(summary);
    map['raw_transcript'] = Variable<String>(rawTranscript);
    {
      map['summary_spans'] = Variable<String>(
        $ProposalsTable.$convertersummarySpans.toSql(summarySpans),
      );
    }
    {
      map['changes'] = Variable<String>(
        $ProposalsTable.$converterchanges.toSql(changes),
      );
    }
    if (!nullToAbsent || sourceVoidItemId != null) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId);
    }
    if (!nullToAbsent || rejectedToVoidItemId != null) {
      map['rejected_to_void_item_id'] = Variable<String>(rejectedToVoidItemId);
    }
    if (!nullToAbsent || snapshotId != null) {
      map['snapshot_id'] = Variable<String>(snapshotId);
    }
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<int>(resolvedAt);
    }
    return map;
  }

  ProposalsCompanion toCompanion(bool nullToAbsent) {
    return ProposalsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      projectId: Value(projectId),
      status: Value(status),
      summary: Value(summary),
      rawTranscript: Value(rawTranscript),
      summarySpans: Value(summarySpans),
      changes: Value(changes),
      sourceVoidItemId: sourceVoidItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceVoidItemId),
      rejectedToVoidItemId: rejectedToVoidItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectedToVoidItemId),
      snapshotId: snapshotId == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotId),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory Proposal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proposal(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      status: serializer.fromJson<ProposalStatus>(json['status']),
      summary: serializer.fromJson<String>(json['summary']),
      rawTranscript: serializer.fromJson<String>(json['rawTranscript']),
      summarySpans: serializer.fromJson<List<dynamic>>(json['summarySpans']),
      changes: serializer.fromJson<List<dynamic>>(json['changes']),
      sourceVoidItemId: serializer.fromJson<String?>(json['sourceVoidItemId']),
      rejectedToVoidItemId: serializer.fromJson<String?>(
        json['rejectedToVoidItemId'],
      ),
      snapshotId: serializer.fromJson<String?>(json['snapshotId']),
      resolvedAt: serializer.fromJson<int?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'projectId': serializer.toJson<String>(projectId),
      'status': serializer.toJson<ProposalStatus>(status),
      'summary': serializer.toJson<String>(summary),
      'rawTranscript': serializer.toJson<String>(rawTranscript),
      'summarySpans': serializer.toJson<List<dynamic>>(summarySpans),
      'changes': serializer.toJson<List<dynamic>>(changes),
      'sourceVoidItemId': serializer.toJson<String?>(sourceVoidItemId),
      'rejectedToVoidItemId': serializer.toJson<String?>(rejectedToVoidItemId),
      'snapshotId': serializer.toJson<String?>(snapshotId),
      'resolvedAt': serializer.toJson<int?>(resolvedAt),
    };
  }

  Proposal copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? projectId,
    ProposalStatus? status,
    String? summary,
    String? rawTranscript,
    List<dynamic>? summarySpans,
    List<dynamic>? changes,
    Value<String?> sourceVoidItemId = const Value.absent(),
    Value<String?> rejectedToVoidItemId = const Value.absent(),
    Value<String?> snapshotId = const Value.absent(),
    Value<int?> resolvedAt = const Value.absent(),
  }) => Proposal(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectId: projectId ?? this.projectId,
    status: status ?? this.status,
    summary: summary ?? this.summary,
    rawTranscript: rawTranscript ?? this.rawTranscript,
    summarySpans: summarySpans ?? this.summarySpans,
    changes: changes ?? this.changes,
    sourceVoidItemId: sourceVoidItemId.present
        ? sourceVoidItemId.value
        : this.sourceVoidItemId,
    rejectedToVoidItemId: rejectedToVoidItemId.present
        ? rejectedToVoidItemId.value
        : this.rejectedToVoidItemId,
    snapshotId: snapshotId.present ? snapshotId.value : this.snapshotId,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  Proposal copyWithCompanion(ProposalsCompanion data) {
    return Proposal(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      status: data.status.present ? data.status.value : this.status,
      summary: data.summary.present ? data.summary.value : this.summary,
      rawTranscript: data.rawTranscript.present
          ? data.rawTranscript.value
          : this.rawTranscript,
      summarySpans: data.summarySpans.present
          ? data.summarySpans.value
          : this.summarySpans,
      changes: data.changes.present ? data.changes.value : this.changes,
      sourceVoidItemId: data.sourceVoidItemId.present
          ? data.sourceVoidItemId.value
          : this.sourceVoidItemId,
      rejectedToVoidItemId: data.rejectedToVoidItemId.present
          ? data.rejectedToVoidItemId.value
          : this.rejectedToVoidItemId,
      snapshotId: data.snapshotId.present
          ? data.snapshotId.value
          : this.snapshotId,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proposal(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript, ')
          ..write('summarySpans: $summarySpans, ')
          ..write('changes: $changes, ')
          ..write('sourceVoidItemId: $sourceVoidItemId, ')
          ..write('rejectedToVoidItemId: $rejectedToVoidItemId, ')
          ..write('snapshotId: $snapshotId, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    projectId,
    status,
    summary,
    rawTranscript,
    summarySpans,
    changes,
    sourceVoidItemId,
    rejectedToVoidItemId,
    snapshotId,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proposal &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.projectId == this.projectId &&
          other.status == this.status &&
          other.summary == this.summary &&
          other.rawTranscript == this.rawTranscript &&
          other.summarySpans == this.summarySpans &&
          other.changes == this.changes &&
          other.sourceVoidItemId == this.sourceVoidItemId &&
          other.rejectedToVoidItemId == this.rejectedToVoidItemId &&
          other.snapshotId == this.snapshotId &&
          other.resolvedAt == this.resolvedAt);
}

class ProposalsCompanion extends UpdateCompanion<Proposal> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> projectId;
  final Value<ProposalStatus> status;
  final Value<String> summary;
  final Value<String> rawTranscript;
  final Value<List<dynamic>> summarySpans;
  final Value<List<dynamic>> changes;
  final Value<String?> sourceVoidItemId;
  final Value<String?> rejectedToVoidItemId;
  final Value<String?> snapshotId;
  final Value<int?> resolvedAt;
  final Value<int> rowid;
  const ProposalsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.status = const Value.absent(),
    this.summary = const Value.absent(),
    this.rawTranscript = const Value.absent(),
    this.summarySpans = const Value.absent(),
    this.changes = const Value.absent(),
    this.sourceVoidItemId = const Value.absent(),
    this.rejectedToVoidItemId = const Value.absent(),
    this.snapshotId = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProposalsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String projectId,
    required ProposalStatus status,
    required String summary,
    required String rawTranscript,
    required List<dynamic> summarySpans,
    required List<dynamic> changes,
    this.sourceVoidItemId = const Value.absent(),
    this.rejectedToVoidItemId = const Value.absent(),
    this.snapshotId = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       projectId = Value(projectId),
       status = Value(status),
       summary = Value(summary),
       rawTranscript = Value(rawTranscript),
       summarySpans = Value(summarySpans),
       changes = Value(changes);
  static Insertable<Proposal> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? projectId,
    Expression<String>? status,
    Expression<String>? summary,
    Expression<String>? rawTranscript,
    Expression<String>? summarySpans,
    Expression<String>? changes,
    Expression<String>? sourceVoidItemId,
    Expression<String>? rejectedToVoidItemId,
    Expression<String>? snapshotId,
    Expression<int>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (projectId != null) 'project_id': projectId,
      if (status != null) 'status': status,
      if (summary != null) 'summary': summary,
      if (rawTranscript != null) 'raw_transcript': rawTranscript,
      if (summarySpans != null) 'summary_spans': summarySpans,
      if (changes != null) 'changes': changes,
      if (sourceVoidItemId != null) 'source_void_item_id': sourceVoidItemId,
      if (rejectedToVoidItemId != null)
        'rejected_to_void_item_id': rejectedToVoidItemId,
      if (snapshotId != null) 'snapshot_id': snapshotId,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProposalsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? projectId,
    Value<ProposalStatus>? status,
    Value<String>? summary,
    Value<String>? rawTranscript,
    Value<List<dynamic>>? summarySpans,
    Value<List<dynamic>>? changes,
    Value<String?>? sourceVoidItemId,
    Value<String?>? rejectedToVoidItemId,
    Value<String?>? snapshotId,
    Value<int?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return ProposalsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      rawTranscript: rawTranscript ?? this.rawTranscript,
      summarySpans: summarySpans ?? this.summarySpans,
      changes: changes ?? this.changes,
      sourceVoidItemId: sourceVoidItemId ?? this.sourceVoidItemId,
      rejectedToVoidItemId: rejectedToVoidItemId ?? this.rejectedToVoidItemId,
      snapshotId: snapshotId ?? this.snapshotId,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProposalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (rawTranscript.present) {
      map['raw_transcript'] = Variable<String>(rawTranscript.value);
    }
    if (summarySpans.present) {
      map['summary_spans'] = Variable<String>(
        $ProposalsTable.$convertersummarySpans.toSql(summarySpans.value),
      );
    }
    if (changes.present) {
      map['changes'] = Variable<String>(
        $ProposalsTable.$converterchanges.toSql(changes.value),
      );
    }
    if (sourceVoidItemId.present) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId.value);
    }
    if (rejectedToVoidItemId.present) {
      map['rejected_to_void_item_id'] = Variable<String>(
        rejectedToVoidItemId.value,
      );
    }
    if (snapshotId.present) {
      map['snapshot_id'] = Variable<String>(snapshotId.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<int>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProposalsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript, ')
          ..write('summarySpans: $summarySpans, ')
          ..write('changes: $changes, ')
          ..write('sourceVoidItemId: $sourceVoidItemId, ')
          ..write('rejectedToVoidItemId: $rejectedToVoidItemId, ')
          ..write('snapshotId: $snapshotId, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiQueueTable extends AiQueue with TableInfo<$AiQueueTable, AiJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueueKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QueueKind>($AiQueueTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<QueueStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QueueStatus>($AiQueueTable.$converterstatus);
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<int> nextRetryAt = GeneratedColumn<int>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($AiQueueTable.$converterpayload);
  static const VerificationMeta _targetVoidItemIdMeta = const VerificationMeta(
    'targetVoidItemId',
  );
  @override
  late final GeneratedColumn<String> targetVoidItemId = GeneratedColumn<String>(
    'target_void_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES void_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetProjectIdMeta = const VerificationMeta(
    'targetProjectId',
  );
  @override
  late final GeneratedColumn<String> targetProjectId = GeneratedColumn<String>(
    'target_project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    kind,
    status,
    attempts,
    nextRetryAt,
    error,
    payload,
    targetVoidItemId,
    targetProjectId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('target_void_item_id')) {
      context.handle(
        _targetVoidItemIdMeta,
        targetVoidItemId.isAcceptableOrUnknown(
          data['target_void_item_id']!,
          _targetVoidItemIdMeta,
        ),
      );
    }
    if (data.containsKey('target_project_id')) {
      context.handle(
        _targetProjectIdMeta,
        targetProjectId.isAcceptableOrUnknown(
          data['target_project_id']!,
          _targetProjectIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      kind: $AiQueueTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      status: $AiQueueTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_retry_at'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      payload: $AiQueueTable.$converterpayload.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payload'],
        )!,
      ),
      targetVoidItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_void_item_id'],
      ),
      targetProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_project_id'],
      ),
    );
  }

  @override
  $AiQueueTable createAlias(String alias) {
    return $AiQueueTable(attachedDatabase, alias);
  }

  static TypeConverter<QueueKind, String> $converterkind = const EnumConverter(
    QueueKind.values,
  );
  static TypeConverter<QueueStatus, String> $converterstatus =
      const EnumConverter(QueueStatus.values);
  static TypeConverter<Map<String, dynamic>, String> $converterpayload =
      mapJson;
}

class AiJob extends DataClass implements Insertable<AiJob> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final QueueKind kind;
  final QueueStatus status;
  final int attempts;
  final int? nextRetryAt;
  final String? error;
  final Map<String, dynamic> payload;
  final String? targetVoidItemId;
  final String? targetProjectId;
  const AiJob({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.kind,
    required this.status,
    required this.attempts,
    this.nextRetryAt,
    this.error,
    required this.payload,
    this.targetVoidItemId,
    this.targetProjectId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    {
      map['kind'] = Variable<String>($AiQueueTable.$converterkind.toSql(kind));
    }
    {
      map['status'] = Variable<String>(
        $AiQueueTable.$converterstatus.toSql(status),
      );
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<int>(nextRetryAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    {
      map['payload'] = Variable<String>(
        $AiQueueTable.$converterpayload.toSql(payload),
      );
    }
    if (!nullToAbsent || targetVoidItemId != null) {
      map['target_void_item_id'] = Variable<String>(targetVoidItemId);
    }
    if (!nullToAbsent || targetProjectId != null) {
      map['target_project_id'] = Variable<String>(targetProjectId);
    }
    return map;
  }

  AiQueueCompanion toCompanion(bool nullToAbsent) {
    return AiQueueCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      kind: Value(kind),
      status: Value(status),
      attempts: Value(attempts),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      payload: Value(payload),
      targetVoidItemId: targetVoidItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetVoidItemId),
      targetProjectId: targetProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetProjectId),
    );
  }

  factory AiJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiJob(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      kind: serializer.fromJson<QueueKind>(json['kind']),
      status: serializer.fromJson<QueueStatus>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextRetryAt: serializer.fromJson<int?>(json['nextRetryAt']),
      error: serializer.fromJson<String?>(json['error']),
      payload: serializer.fromJson<Map<String, dynamic>>(json['payload']),
      targetVoidItemId: serializer.fromJson<String?>(json['targetVoidItemId']),
      targetProjectId: serializer.fromJson<String?>(json['targetProjectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'kind': serializer.toJson<QueueKind>(kind),
      'status': serializer.toJson<QueueStatus>(status),
      'attempts': serializer.toJson<int>(attempts),
      'nextRetryAt': serializer.toJson<int?>(nextRetryAt),
      'error': serializer.toJson<String?>(error),
      'payload': serializer.toJson<Map<String, dynamic>>(payload),
      'targetVoidItemId': serializer.toJson<String?>(targetVoidItemId),
      'targetProjectId': serializer.toJson<String?>(targetProjectId),
    };
  }

  AiJob copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    QueueKind? kind,
    QueueStatus? status,
    int? attempts,
    Value<int?> nextRetryAt = const Value.absent(),
    Value<String?> error = const Value.absent(),
    Map<String, dynamic>? payload,
    Value<String?> targetVoidItemId = const Value.absent(),
    Value<String?> targetProjectId = const Value.absent(),
  }) => AiJob(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    error: error.present ? error.value : this.error,
    payload: payload ?? this.payload,
    targetVoidItemId: targetVoidItemId.present
        ? targetVoidItemId.value
        : this.targetVoidItemId,
    targetProjectId: targetProjectId.present
        ? targetProjectId.value
        : this.targetProjectId,
  );
  AiJob copyWithCompanion(AiQueueCompanion data) {
    return AiJob(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      error: data.error.present ? data.error.value : this.error,
      payload: data.payload.present ? data.payload.value : this.payload,
      targetVoidItemId: data.targetVoidItemId.present
          ? data.targetVoidItemId.value
          : this.targetVoidItemId,
      targetProjectId: data.targetProjectId.present
          ? data.targetProjectId.value
          : this.targetProjectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiJob(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('error: $error, ')
          ..write('payload: $payload, ')
          ..write('targetVoidItemId: $targetVoidItemId, ')
          ..write('targetProjectId: $targetProjectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    kind,
    status,
    attempts,
    nextRetryAt,
    error,
    payload,
    targetVoidItemId,
    targetProjectId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiJob &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.nextRetryAt == this.nextRetryAt &&
          other.error == this.error &&
          other.payload == this.payload &&
          other.targetVoidItemId == this.targetVoidItemId &&
          other.targetProjectId == this.targetProjectId);
}

class AiQueueCompanion extends UpdateCompanion<AiJob> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<QueueKind> kind;
  final Value<QueueStatus> status;
  final Value<int> attempts;
  final Value<int?> nextRetryAt;
  final Value<String?> error;
  final Value<Map<String, dynamic>> payload;
  final Value<String?> targetVoidItemId;
  final Value<String?> targetProjectId;
  final Value<int> rowid;
  const AiQueueCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.error = const Value.absent(),
    this.payload = const Value.absent(),
    this.targetVoidItemId = const Value.absent(),
    this.targetProjectId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiQueueCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required QueueKind kind,
    required QueueStatus status,
    this.attempts = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.error = const Value.absent(),
    required Map<String, dynamic> payload,
    this.targetVoidItemId = const Value.absent(),
    this.targetProjectId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       status = Value(status),
       payload = Value(payload);
  static Insertable<AiJob> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<int>? nextRetryAt,
    Expression<String>? error,
    Expression<String>? payload,
    Expression<String>? targetVoidItemId,
    Expression<String>? targetProjectId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (error != null) 'error': error,
      if (payload != null) 'payload': payload,
      if (targetVoidItemId != null) 'target_void_item_id': targetVoidItemId,
      if (targetProjectId != null) 'target_project_id': targetProjectId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiQueueCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<QueueKind>? kind,
    Value<QueueStatus>? status,
    Value<int>? attempts,
    Value<int?>? nextRetryAt,
    Value<String?>? error,
    Value<Map<String, dynamic>>? payload,
    Value<String?>? targetVoidItemId,
    Value<String?>? targetProjectId,
    Value<int>? rowid,
  }) {
    return AiQueueCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      error: error ?? this.error,
      payload: payload ?? this.payload,
      targetVoidItemId: targetVoidItemId ?? this.targetVoidItemId,
      targetProjectId: targetProjectId ?? this.targetProjectId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AiQueueTable.$converterkind.toSql(kind.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AiQueueTable.$converterstatus.toSql(status.value),
      );
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<int>(nextRetryAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
        $AiQueueTable.$converterpayload.toSql(payload.value),
      );
    }
    if (targetVoidItemId.present) {
      map['target_void_item_id'] = Variable<String>(targetVoidItemId.value);
    }
    if (targetProjectId.present) {
      map['target_project_id'] = Variable<String>(targetProjectId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiQueueCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('error: $error, ')
          ..write('payload: $payload, ')
          ..write('targetVoidItemId: $targetVoidItemId, ')
          ..write('targetProjectId: $targetProjectId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<String> age = GeneratedColumn<String>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backgroundMeta = const VerificationMeta(
    'background',
  );
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
    'background',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _traitsMeta = const VerificationMeta('traits');
  @override
  late final GeneratedColumn<String> traits = GeneratedColumn<String>(
    'traits',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitsMeta = const VerificationMeta('habits');
  @override
  late final GeneratedColumn<String> habits = GeneratedColumn<String>(
    'habits',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wantsNeedsFearsMeta = const VerificationMeta(
    'wantsNeedsFears',
  );
  @override
  late final GeneratedColumn<String> wantsNeedsFears = GeneratedColumn<String>(
    'wants_needs_fears',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceVoidItemIdMeta = const VerificationMeta(
    'sourceVoidItemId',
  );
  @override
  late final GeneratedColumn<String> sourceVoidItemId = GeneratedColumn<String>(
    'source_void_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES void_items (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    name,
    age,
    role,
    appearance,
    background,
    traits,
    habits,
    wantsNeedsFears,
    notes,
    sourceVoidItemId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    } else if (isInserting) {
      context.missing(_appearanceMeta);
    }
    if (data.containsKey('background')) {
      context.handle(
        _backgroundMeta,
        background.isAcceptableOrUnknown(data['background']!, _backgroundMeta),
      );
    } else if (isInserting) {
      context.missing(_backgroundMeta);
    }
    if (data.containsKey('traits')) {
      context.handle(
        _traitsMeta,
        traits.isAcceptableOrUnknown(data['traits']!, _traitsMeta),
      );
    } else if (isInserting) {
      context.missing(_traitsMeta);
    }
    if (data.containsKey('habits')) {
      context.handle(
        _habitsMeta,
        habits.isAcceptableOrUnknown(data['habits']!, _habitsMeta),
      );
    } else if (isInserting) {
      context.missing(_habitsMeta);
    }
    if (data.containsKey('wants_needs_fears')) {
      context.handle(
        _wantsNeedsFearsMeta,
        wantsNeedsFears.isAcceptableOrUnknown(
          data['wants_needs_fears']!,
          _wantsNeedsFearsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wantsNeedsFearsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('source_void_item_id')) {
      context.handle(
        _sourceVoidItemIdMeta,
        sourceVoidItemId.isAcceptableOrUnknown(
          data['source_void_item_id']!,
          _sourceVoidItemIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      appearance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance'],
      )!,
      background: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background'],
      )!,
      traits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traits'],
      )!,
      habits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habits'],
      )!,
      wantsNeedsFears: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wants_needs_fears'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      sourceVoidItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_void_item_id'],
      ),
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String name;
  final String? age;
  final String role;
  final String appearance;
  final String background;
  final String traits;
  final String habits;
  final String wantsNeedsFears;
  final String notes;
  final String? sourceVoidItemId;
  const Character({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.age,
    required this.role,
    required this.appearance,
    required this.background,
    required this.traits,
    required this.habits,
    required this.wantsNeedsFears,
    required this.notes,
    this.sourceVoidItemId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<String>(age);
    }
    map['role'] = Variable<String>(role);
    map['appearance'] = Variable<String>(appearance);
    map['background'] = Variable<String>(background);
    map['traits'] = Variable<String>(traits);
    map['habits'] = Variable<String>(habits);
    map['wants_needs_fears'] = Variable<String>(wantsNeedsFears);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || sourceVoidItemId != null) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId);
    }
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      name: Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      role: Value(role),
      appearance: Value(appearance),
      background: Value(background),
      traits: Value(traits),
      habits: Value(habits),
      wantsNeedsFears: Value(wantsNeedsFears),
      notes: Value(notes),
      sourceVoidItemId: sourceVoidItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceVoidItemId),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<String?>(json['age']),
      role: serializer.fromJson<String>(json['role']),
      appearance: serializer.fromJson<String>(json['appearance']),
      background: serializer.fromJson<String>(json['background']),
      traits: serializer.fromJson<String>(json['traits']),
      habits: serializer.fromJson<String>(json['habits']),
      wantsNeedsFears: serializer.fromJson<String>(json['wantsNeedsFears']),
      notes: serializer.fromJson<String>(json['notes']),
      sourceVoidItemId: serializer.fromJson<String?>(json['sourceVoidItemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<String?>(age),
      'role': serializer.toJson<String>(role),
      'appearance': serializer.toJson<String>(appearance),
      'background': serializer.toJson<String>(background),
      'traits': serializer.toJson<String>(traits),
      'habits': serializer.toJson<String>(habits),
      'wantsNeedsFears': serializer.toJson<String>(wantsNeedsFears),
      'notes': serializer.toJson<String>(notes),
      'sourceVoidItemId': serializer.toJson<String?>(sourceVoidItemId),
    };
  }

  Character copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? name,
    Value<String?> age = const Value.absent(),
    String? role,
    String? appearance,
    String? background,
    String? traits,
    String? habits,
    String? wantsNeedsFears,
    String? notes,
    Value<String?> sourceVoidItemId = const Value.absent(),
  }) => Character(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    age: age.present ? age.value : this.age,
    role: role ?? this.role,
    appearance: appearance ?? this.appearance,
    background: background ?? this.background,
    traits: traits ?? this.traits,
    habits: habits ?? this.habits,
    wantsNeedsFears: wantsNeedsFears ?? this.wantsNeedsFears,
    notes: notes ?? this.notes,
    sourceVoidItemId: sourceVoidItemId.present
        ? sourceVoidItemId.value
        : this.sourceVoidItemId,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      role: data.role.present ? data.role.value : this.role,
      appearance: data.appearance.present
          ? data.appearance.value
          : this.appearance,
      background: data.background.present
          ? data.background.value
          : this.background,
      traits: data.traits.present ? data.traits.value : this.traits,
      habits: data.habits.present ? data.habits.value : this.habits,
      wantsNeedsFears: data.wantsNeedsFears.present
          ? data.wantsNeedsFears.value
          : this.wantsNeedsFears,
      notes: data.notes.present ? data.notes.value : this.notes,
      sourceVoidItemId: data.sourceVoidItemId.present
          ? data.sourceVoidItemId.value
          : this.sourceVoidItemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role, ')
          ..write('appearance: $appearance, ')
          ..write('background: $background, ')
          ..write('traits: $traits, ')
          ..write('habits: $habits, ')
          ..write('wantsNeedsFears: $wantsNeedsFears, ')
          ..write('notes: $notes, ')
          ..write('sourceVoidItemId: $sourceVoidItemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    name,
    age,
    role,
    appearance,
    background,
    traits,
    habits,
    wantsNeedsFears,
    notes,
    sourceVoidItemId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.age == this.age &&
          other.role == this.role &&
          other.appearance == this.appearance &&
          other.background == this.background &&
          other.traits == this.traits &&
          other.habits == this.habits &&
          other.wantsNeedsFears == this.wantsNeedsFears &&
          other.notes == this.notes &&
          other.sourceVoidItemId == this.sourceVoidItemId);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> name;
  final Value<String?> age;
  final Value<String> role;
  final Value<String> appearance;
  final Value<String> background;
  final Value<String> traits;
  final Value<String> habits;
  final Value<String> wantsNeedsFears;
  final Value<String> notes;
  final Value<String?> sourceVoidItemId;
  final Value<int> rowid;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.role = const Value.absent(),
    this.appearance = const Value.absent(),
    this.background = const Value.absent(),
    this.traits = const Value.absent(),
    this.habits = const Value.absent(),
    this.wantsNeedsFears = const Value.absent(),
    this.notes = const Value.absent(),
    this.sourceVoidItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String name,
    this.age = const Value.absent(),
    required String role,
    required String appearance,
    required String background,
    required String traits,
    required String habits,
    required String wantsNeedsFears,
    required String notes,
    this.sourceVoidItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       role = Value(role),
       appearance = Value(appearance),
       background = Value(background),
       traits = Value(traits),
       habits = Value(habits),
       wantsNeedsFears = Value(wantsNeedsFears),
       notes = Value(notes);
  static Insertable<Character> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? name,
    Expression<String>? age,
    Expression<String>? role,
    Expression<String>? appearance,
    Expression<String>? background,
    Expression<String>? traits,
    Expression<String>? habits,
    Expression<String>? wantsNeedsFears,
    Expression<String>? notes,
    Expression<String>? sourceVoidItemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (role != null) 'role': role,
      if (appearance != null) 'appearance': appearance,
      if (background != null) 'background': background,
      if (traits != null) 'traits': traits,
      if (habits != null) 'habits': habits,
      if (wantsNeedsFears != null) 'wants_needs_fears': wantsNeedsFears,
      if (notes != null) 'notes': notes,
      if (sourceVoidItemId != null) 'source_void_item_id': sourceVoidItemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? name,
    Value<String?>? age,
    Value<String>? role,
    Value<String>? appearance,
    Value<String>? background,
    Value<String>? traits,
    Value<String>? habits,
    Value<String>? wantsNeedsFears,
    Value<String>? notes,
    Value<String?>? sourceVoidItemId,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      age: age ?? this.age,
      role: role ?? this.role,
      appearance: appearance ?? this.appearance,
      background: background ?? this.background,
      traits: traits ?? this.traits,
      habits: habits ?? this.habits,
      wantsNeedsFears: wantsNeedsFears ?? this.wantsNeedsFears,
      notes: notes ?? this.notes,
      sourceVoidItemId: sourceVoidItemId ?? this.sourceVoidItemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<String>(age.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (background.present) {
      map['background'] = Variable<String>(background.value);
    }
    if (traits.present) {
      map['traits'] = Variable<String>(traits.value);
    }
    if (habits.present) {
      map['habits'] = Variable<String>(habits.value);
    }
    if (wantsNeedsFears.present) {
      map['wants_needs_fears'] = Variable<String>(wantsNeedsFears.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sourceVoidItemId.present) {
      map['source_void_item_id'] = Variable<String>(sourceVoidItemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role, ')
          ..write('appearance: $appearance, ')
          ..write('background: $background, ')
          ..write('traits: $traits, ')
          ..write('habits: $habits, ')
          ..write('wantsNeedsFears: $wantsNeedsFears, ')
          ..write('notes: $notes, ')
          ..write('sourceVoidItemId: $sourceVoidItemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectCharactersTable extends ProjectCharacters
    with TableInfo<$ProjectCharactersTable, ProjectCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CharacterMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CharacterMode>($ProjectCharactersTable.$convertermode);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<String> age = GeneratedColumn<String>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backgroundMeta = const VerificationMeta(
    'background',
  );
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
    'background',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _traitsMeta = const VerificationMeta('traits');
  @override
  late final GeneratedColumn<String> traits = GeneratedColumn<String>(
    'traits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _habitsMeta = const VerificationMeta('habits');
  @override
  late final GeneratedColumn<String> habits = GeneratedColumn<String>(
    'habits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wantsNeedsFearsMeta = const VerificationMeta(
    'wantsNeedsFears',
  );
  @override
  late final GeneratedColumn<String> wantsNeedsFears = GeneratedColumn<String>(
    'wants_needs_fears',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    projectId,
    characterId,
    mode,
    name,
    age,
    role,
    appearance,
    background,
    traits,
    habits,
    wantsNeedsFears,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectCharacter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    }
    if (data.containsKey('background')) {
      context.handle(
        _backgroundMeta,
        background.isAcceptableOrUnknown(data['background']!, _backgroundMeta),
      );
    }
    if (data.containsKey('traits')) {
      context.handle(
        _traitsMeta,
        traits.isAcceptableOrUnknown(data['traits']!, _traitsMeta),
      );
    }
    if (data.containsKey('habits')) {
      context.handle(
        _habitsMeta,
        habits.isAcceptableOrUnknown(data['habits']!, _habitsMeta),
      );
    }
    if (data.containsKey('wants_needs_fears')) {
      context.handle(
        _wantsNeedsFearsMeta,
        wantsNeedsFears.isAcceptableOrUnknown(
          data['wants_needs_fears']!,
          _wantsNeedsFearsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectCharacter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      ),
      mode: $ProjectCharactersTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      appearance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance'],
      ),
      background: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background'],
      ),
      traits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traits'],
      ),
      habits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habits'],
      ),
      wantsNeedsFears: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wants_needs_fears'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ProjectCharactersTable createAlias(String alias) {
    return $ProjectCharactersTable(attachedDatabase, alias);
  }

  static TypeConverter<CharacterMode, String> $convertermode =
      const EnumConverter(CharacterMode.values);
}

class ProjectCharacter extends DataClass
    implements Insertable<ProjectCharacter> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String projectId;
  final String? characterId;
  final CharacterMode mode;
  final String? name;
  final String? age;
  final String? role;
  final String? appearance;
  final String? background;
  final String? traits;
  final String? habits;
  final String? wantsNeedsFears;
  final String? notes;
  const ProjectCharacter({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    this.characterId,
    required this.mode,
    this.name,
    this.age,
    this.role,
    this.appearance,
    this.background,
    this.traits,
    this.habits,
    this.wantsNeedsFears,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || characterId != null) {
      map['character_id'] = Variable<String>(characterId);
    }
    {
      map['mode'] = Variable<String>(
        $ProjectCharactersTable.$convertermode.toSql(mode),
      );
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<String>(age);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || appearance != null) {
      map['appearance'] = Variable<String>(appearance);
    }
    if (!nullToAbsent || background != null) {
      map['background'] = Variable<String>(background);
    }
    if (!nullToAbsent || traits != null) {
      map['traits'] = Variable<String>(traits);
    }
    if (!nullToAbsent || habits != null) {
      map['habits'] = Variable<String>(habits);
    }
    if (!nullToAbsent || wantsNeedsFears != null) {
      map['wants_needs_fears'] = Variable<String>(wantsNeedsFears);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ProjectCharactersCompanion toCompanion(bool nullToAbsent) {
    return ProjectCharactersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      projectId: Value(projectId),
      characterId: characterId == null && nullToAbsent
          ? const Value.absent()
          : Value(characterId),
      mode: Value(mode),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      appearance: appearance == null && nullToAbsent
          ? const Value.absent()
          : Value(appearance),
      background: background == null && nullToAbsent
          ? const Value.absent()
          : Value(background),
      traits: traits == null && nullToAbsent
          ? const Value.absent()
          : Value(traits),
      habits: habits == null && nullToAbsent
          ? const Value.absent()
          : Value(habits),
      wantsNeedsFears: wantsNeedsFears == null && nullToAbsent
          ? const Value.absent()
          : Value(wantsNeedsFears),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ProjectCharacter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectCharacter(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      characterId: serializer.fromJson<String?>(json['characterId']),
      mode: serializer.fromJson<CharacterMode>(json['mode']),
      name: serializer.fromJson<String?>(json['name']),
      age: serializer.fromJson<String?>(json['age']),
      role: serializer.fromJson<String?>(json['role']),
      appearance: serializer.fromJson<String?>(json['appearance']),
      background: serializer.fromJson<String?>(json['background']),
      traits: serializer.fromJson<String?>(json['traits']),
      habits: serializer.fromJson<String?>(json['habits']),
      wantsNeedsFears: serializer.fromJson<String?>(json['wantsNeedsFears']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'projectId': serializer.toJson<String>(projectId),
      'characterId': serializer.toJson<String?>(characterId),
      'mode': serializer.toJson<CharacterMode>(mode),
      'name': serializer.toJson<String?>(name),
      'age': serializer.toJson<String?>(age),
      'role': serializer.toJson<String?>(role),
      'appearance': serializer.toJson<String?>(appearance),
      'background': serializer.toJson<String?>(background),
      'traits': serializer.toJson<String?>(traits),
      'habits': serializer.toJson<String?>(habits),
      'wantsNeedsFears': serializer.toJson<String?>(wantsNeedsFears),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ProjectCharacter copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? projectId,
    Value<String?> characterId = const Value.absent(),
    CharacterMode? mode,
    Value<String?> name = const Value.absent(),
    Value<String?> age = const Value.absent(),
    Value<String?> role = const Value.absent(),
    Value<String?> appearance = const Value.absent(),
    Value<String?> background = const Value.absent(),
    Value<String?> traits = const Value.absent(),
    Value<String?> habits = const Value.absent(),
    Value<String?> wantsNeedsFears = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => ProjectCharacter(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectId: projectId ?? this.projectId,
    characterId: characterId.present ? characterId.value : this.characterId,
    mode: mode ?? this.mode,
    name: name.present ? name.value : this.name,
    age: age.present ? age.value : this.age,
    role: role.present ? role.value : this.role,
    appearance: appearance.present ? appearance.value : this.appearance,
    background: background.present ? background.value : this.background,
    traits: traits.present ? traits.value : this.traits,
    habits: habits.present ? habits.value : this.habits,
    wantsNeedsFears: wantsNeedsFears.present
        ? wantsNeedsFears.value
        : this.wantsNeedsFears,
    notes: notes.present ? notes.value : this.notes,
  );
  ProjectCharacter copyWithCompanion(ProjectCharactersCompanion data) {
    return ProjectCharacter(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      mode: data.mode.present ? data.mode.value : this.mode,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      role: data.role.present ? data.role.value : this.role,
      appearance: data.appearance.present
          ? data.appearance.value
          : this.appearance,
      background: data.background.present
          ? data.background.value
          : this.background,
      traits: data.traits.present ? data.traits.value : this.traits,
      habits: data.habits.present ? data.habits.value : this.habits,
      wantsNeedsFears: data.wantsNeedsFears.present
          ? data.wantsNeedsFears.value
          : this.wantsNeedsFears,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectCharacter(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('characterId: $characterId, ')
          ..write('mode: $mode, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role, ')
          ..write('appearance: $appearance, ')
          ..write('background: $background, ')
          ..write('traits: $traits, ')
          ..write('habits: $habits, ')
          ..write('wantsNeedsFears: $wantsNeedsFears, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    projectId,
    characterId,
    mode,
    name,
    age,
    role,
    appearance,
    background,
    traits,
    habits,
    wantsNeedsFears,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectCharacter &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.projectId == this.projectId &&
          other.characterId == this.characterId &&
          other.mode == this.mode &&
          other.name == this.name &&
          other.age == this.age &&
          other.role == this.role &&
          other.appearance == this.appearance &&
          other.background == this.background &&
          other.traits == this.traits &&
          other.habits == this.habits &&
          other.wantsNeedsFears == this.wantsNeedsFears &&
          other.notes == this.notes);
}

class ProjectCharactersCompanion extends UpdateCompanion<ProjectCharacter> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> projectId;
  final Value<String?> characterId;
  final Value<CharacterMode> mode;
  final Value<String?> name;
  final Value<String?> age;
  final Value<String?> role;
  final Value<String?> appearance;
  final Value<String?> background;
  final Value<String?> traits;
  final Value<String?> habits;
  final Value<String?> wantsNeedsFears;
  final Value<String?> notes;
  final Value<int> rowid;
  const ProjectCharactersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.mode = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.role = const Value.absent(),
    this.appearance = const Value.absent(),
    this.background = const Value.absent(),
    this.traits = const Value.absent(),
    this.habits = const Value.absent(),
    this.wantsNeedsFears = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectCharactersCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String projectId,
    this.characterId = const Value.absent(),
    required CharacterMode mode,
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.role = const Value.absent(),
    this.appearance = const Value.absent(),
    this.background = const Value.absent(),
    this.traits = const Value.absent(),
    this.habits = const Value.absent(),
    this.wantsNeedsFears = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       projectId = Value(projectId),
       mode = Value(mode);
  static Insertable<ProjectCharacter> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? projectId,
    Expression<String>? characterId,
    Expression<String>? mode,
    Expression<String>? name,
    Expression<String>? age,
    Expression<String>? role,
    Expression<String>? appearance,
    Expression<String>? background,
    Expression<String>? traits,
    Expression<String>? habits,
    Expression<String>? wantsNeedsFears,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (projectId != null) 'project_id': projectId,
      if (characterId != null) 'character_id': characterId,
      if (mode != null) 'mode': mode,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (role != null) 'role': role,
      if (appearance != null) 'appearance': appearance,
      if (background != null) 'background': background,
      if (traits != null) 'traits': traits,
      if (habits != null) 'habits': habits,
      if (wantsNeedsFears != null) 'wants_needs_fears': wantsNeedsFears,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectCharactersCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? projectId,
    Value<String?>? characterId,
    Value<CharacterMode>? mode,
    Value<String?>? name,
    Value<String?>? age,
    Value<String?>? role,
    Value<String?>? appearance,
    Value<String?>? background,
    Value<String?>? traits,
    Value<String?>? habits,
    Value<String?>? wantsNeedsFears,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ProjectCharactersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId ?? this.projectId,
      characterId: characterId ?? this.characterId,
      mode: mode ?? this.mode,
      name: name ?? this.name,
      age: age ?? this.age,
      role: role ?? this.role,
      appearance: appearance ?? this.appearance,
      background: background ?? this.background,
      traits: traits ?? this.traits,
      habits: habits ?? this.habits,
      wantsNeedsFears: wantsNeedsFears ?? this.wantsNeedsFears,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $ProjectCharactersTable.$convertermode.toSql(mode.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<String>(age.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (background.present) {
      map['background'] = Variable<String>(background.value);
    }
    if (traits.present) {
      map['traits'] = Variable<String>(traits.value);
    }
    if (habits.present) {
      map['habits'] = Variable<String>(habits.value);
    }
    if (wantsNeedsFears.present) {
      map['wants_needs_fears'] = Variable<String>(wantsNeedsFears.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectCharactersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('characterId: $characterId, ')
          ..write('mode: $mode, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role, ')
          ..write('appearance: $appearance, ')
          ..write('background: $background, ')
          ..write('traits: $traits, ')
          ..write('habits: $habits, ')
          ..write('wantsNeedsFears: $wantsNeedsFears, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class VoidItemsFts extends Table
    with
        TableInfo<VoidItemsFts, VoidItemsFt>,
        VirtualTableInfo<VoidItemsFts, VoidItemsFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VoidItemsFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _rawTranscriptMeta = const VerificationMeta(
    'rawTranscript',
  );
  late final GeneratedColumn<String> rawTranscript = GeneratedColumn<String>(
    'raw_transcript',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [summary, rawTranscript];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'void_items_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoidItemsFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('raw_transcript')) {
      context.handle(
        _rawTranscriptMeta,
        rawTranscript.isAcceptableOrUnknown(
          data['raw_transcript']!,
          _rawTranscriptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawTranscriptMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  VoidItemsFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoidItemsFt(
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      rawTranscript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_transcript'],
      )!,
    );
  }

  @override
  VoidItemsFts createAlias(String alias) {
    return VoidItemsFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(summary, raw_transcript, content=\'void_items\', content_rowid=\'rowid\', tokenize=\'unicode61 remove_diacritics 2\')';
}

class VoidItemsFt extends DataClass implements Insertable<VoidItemsFt> {
  final String summary;
  final String rawTranscript;
  const VoidItemsFt({required this.summary, required this.rawTranscript});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['summary'] = Variable<String>(summary);
    map['raw_transcript'] = Variable<String>(rawTranscript);
    return map;
  }

  VoidItemsFtsCompanion toCompanion(bool nullToAbsent) {
    return VoidItemsFtsCompanion(
      summary: Value(summary),
      rawTranscript: Value(rawTranscript),
    );
  }

  factory VoidItemsFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoidItemsFt(
      summary: serializer.fromJson<String>(json['summary']),
      rawTranscript: serializer.fromJson<String>(json['raw_transcript']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'summary': serializer.toJson<String>(summary),
      'raw_transcript': serializer.toJson<String>(rawTranscript),
    };
  }

  VoidItemsFt copyWith({String? summary, String? rawTranscript}) => VoidItemsFt(
    summary: summary ?? this.summary,
    rawTranscript: rawTranscript ?? this.rawTranscript,
  );
  VoidItemsFt copyWithCompanion(VoidItemsFtsCompanion data) {
    return VoidItemsFt(
      summary: data.summary.present ? data.summary.value : this.summary,
      rawTranscript: data.rawTranscript.present
          ? data.rawTranscript.value
          : this.rawTranscript,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoidItemsFt(')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(summary, rawTranscript);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoidItemsFt &&
          other.summary == this.summary &&
          other.rawTranscript == this.rawTranscript);
}

class VoidItemsFtsCompanion extends UpdateCompanion<VoidItemsFt> {
  final Value<String> summary;
  final Value<String> rawTranscript;
  final Value<int> rowid;
  const VoidItemsFtsCompanion({
    this.summary = const Value.absent(),
    this.rawTranscript = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoidItemsFtsCompanion.insert({
    required String summary,
    required String rawTranscript,
    this.rowid = const Value.absent(),
  }) : summary = Value(summary),
       rawTranscript = Value(rawTranscript);
  static Insertable<VoidItemsFt> custom({
    Expression<String>? summary,
    Expression<String>? rawTranscript,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (summary != null) 'summary': summary,
      if (rawTranscript != null) 'raw_transcript': rawTranscript,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoidItemsFtsCompanion copyWith({
    Value<String>? summary,
    Value<String>? rawTranscript,
    Value<int>? rowid,
  }) {
    return VoidItemsFtsCompanion(
      summary: summary ?? this.summary,
      rawTranscript: rawTranscript ?? this.rawTranscript,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (rawTranscript.present) {
      map['raw_transcript'] = Variable<String>(rawTranscript.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoidItemsFtsCompanion(')
          ..write('summary: $summary, ')
          ..write('rawTranscript: $rawTranscript, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShotImagesTable extends ShotImages
    with TableInfo<$ShotImagesTable, ShotImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShotImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userEditedMeta = const VerificationMeta(
    'userEdited',
  );
  @override
  late final GeneratedColumn<bool> userEdited = GeneratedColumn<bool>(
    'user_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seedIdMeta = const VerificationMeta('seedId');
  @override
  late final GeneratedColumn<String> seedId = GeneratedColumn<String>(
    'seed_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _shotIdMeta = const VerificationMeta('shotId');
  @override
  late final GeneratedColumn<String> shotId = GeneratedColumn<String>(
    'shot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ShotImageKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ShotImageKind>($ShotImagesTable.$converterkind);
  static const VerificationMeta _licenseMeta = const VerificationMeta(
    'license',
  );
  @override
  late final GeneratedColumn<String> license = GeneratedColumn<String>(
    'license',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    shotId,
    position,
    path,
    kind,
    license,
    author,
    sourceUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shot_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShotImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('user_edited')) {
      context.handle(
        _userEditedMeta,
        userEdited.isAcceptableOrUnknown(data['user_edited']!, _userEditedMeta),
      );
    }
    if (data.containsKey('seed_id')) {
      context.handle(
        _seedIdMeta,
        seedId.isAcceptableOrUnknown(data['seed_id']!, _seedIdMeta),
      );
    }
    if (data.containsKey('shot_id')) {
      context.handle(
        _shotIdMeta,
        shotId.isAcceptableOrUnknown(data['shot_id']!, _shotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shotIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('license')) {
      context.handle(
        _licenseMeta,
        license.isAcceptableOrUnknown(data['license']!, _licenseMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShotImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShotImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      userEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_edited'],
      )!,
      seedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_id'],
      ),
      shotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shot_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      kind: $ShotImagesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      license: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
    );
  }

  @override
  $ShotImagesTable createAlias(String alias) {
    return $ShotImagesTable(attachedDatabase, alias);
  }

  static TypeConverter<ShotImageKind, String> $converterkind =
      const EnumConverter(ShotImageKind.values);
}

class ShotImage extends DataClass implements Insertable<ShotImage> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final bool builtin;
  final bool userEdited;
  final String? seedId;
  final String shotId;
  final int position;
  final String path;
  final ShotImageKind kind;
  final String? license;
  final String? author;
  final String? sourceUrl;
  const ShotImage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.builtin,
    required this.userEdited,
    this.seedId,
    required this.shotId,
    required this.position,
    required this.path,
    required this.kind,
    this.license,
    this.author,
    this.sourceUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['builtin'] = Variable<bool>(builtin);
    map['user_edited'] = Variable<bool>(userEdited);
    if (!nullToAbsent || seedId != null) {
      map['seed_id'] = Variable<String>(seedId);
    }
    map['shot_id'] = Variable<String>(shotId);
    map['position'] = Variable<int>(position);
    map['path'] = Variable<String>(path);
    {
      map['kind'] = Variable<String>(
        $ShotImagesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || license != null) {
      map['license'] = Variable<String>(license);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    return map;
  }

  ShotImagesCompanion toCompanion(bool nullToAbsent) {
    return ShotImagesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      builtin: Value(builtin),
      userEdited: Value(userEdited),
      seedId: seedId == null && nullToAbsent
          ? const Value.absent()
          : Value(seedId),
      shotId: Value(shotId),
      position: Value(position),
      path: Value(path),
      kind: Value(kind),
      license: license == null && nullToAbsent
          ? const Value.absent()
          : Value(license),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
    );
  }

  factory ShotImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShotImage(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      userEdited: serializer.fromJson<bool>(json['userEdited']),
      seedId: serializer.fromJson<String?>(json['seedId']),
      shotId: serializer.fromJson<String>(json['shotId']),
      position: serializer.fromJson<int>(json['position']),
      path: serializer.fromJson<String>(json['path']),
      kind: serializer.fromJson<ShotImageKind>(json['kind']),
      license: serializer.fromJson<String?>(json['license']),
      author: serializer.fromJson<String?>(json['author']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'builtin': serializer.toJson<bool>(builtin),
      'userEdited': serializer.toJson<bool>(userEdited),
      'seedId': serializer.toJson<String?>(seedId),
      'shotId': serializer.toJson<String>(shotId),
      'position': serializer.toJson<int>(position),
      'path': serializer.toJson<String>(path),
      'kind': serializer.toJson<ShotImageKind>(kind),
      'license': serializer.toJson<String?>(license),
      'author': serializer.toJson<String?>(author),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
    };
  }

  ShotImage copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    bool? builtin,
    bool? userEdited,
    Value<String?> seedId = const Value.absent(),
    String? shotId,
    int? position,
    String? path,
    ShotImageKind? kind,
    Value<String?> license = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
  }) => ShotImage(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    builtin: builtin ?? this.builtin,
    userEdited: userEdited ?? this.userEdited,
    seedId: seedId.present ? seedId.value : this.seedId,
    shotId: shotId ?? this.shotId,
    position: position ?? this.position,
    path: path ?? this.path,
    kind: kind ?? this.kind,
    license: license.present ? license.value : this.license,
    author: author.present ? author.value : this.author,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
  );
  ShotImage copyWithCompanion(ShotImagesCompanion data) {
    return ShotImage(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      userEdited: data.userEdited.present
          ? data.userEdited.value
          : this.userEdited,
      seedId: data.seedId.present ? data.seedId.value : this.seedId,
      shotId: data.shotId.present ? data.shotId.value : this.shotId,
      position: data.position.present ? data.position.value : this.position,
      path: data.path.present ? data.path.value : this.path,
      kind: data.kind.present ? data.kind.value : this.kind,
      license: data.license.present ? data.license.value : this.license,
      author: data.author.present ? data.author.value : this.author,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShotImage(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('shotId: $shotId, ')
          ..write('position: $position, ')
          ..write('path: $path, ')
          ..write('kind: $kind, ')
          ..write('license: $license, ')
          ..write('author: $author, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    builtin,
    userEdited,
    seedId,
    shotId,
    position,
    path,
    kind,
    license,
    author,
    sourceUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShotImage &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.builtin == this.builtin &&
          other.userEdited == this.userEdited &&
          other.seedId == this.seedId &&
          other.shotId == this.shotId &&
          other.position == this.position &&
          other.path == this.path &&
          other.kind == this.kind &&
          other.license == this.license &&
          other.author == this.author &&
          other.sourceUrl == this.sourceUrl);
}

class ShotImagesCompanion extends UpdateCompanion<ShotImage> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> builtin;
  final Value<bool> userEdited;
  final Value<String?> seedId;
  final Value<String> shotId;
  final Value<int> position;
  final Value<String> path;
  final Value<ShotImageKind> kind;
  final Value<String?> license;
  final Value<String?> author;
  final Value<String?> sourceUrl;
  final Value<int> rowid;
  const ShotImagesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    this.shotId = const Value.absent(),
    this.position = const Value.absent(),
    this.path = const Value.absent(),
    this.kind = const Value.absent(),
    this.license = const Value.absent(),
    this.author = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShotImagesCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.builtin = const Value.absent(),
    this.userEdited = const Value.absent(),
    this.seedId = const Value.absent(),
    required String shotId,
    required int position,
    required String path,
    required ShotImageKind kind,
    this.license = const Value.absent(),
    this.author = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       shotId = Value(shotId),
       position = Value(position),
       path = Value(path),
       kind = Value(kind);
  static Insertable<ShotImage> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? builtin,
    Expression<bool>? userEdited,
    Expression<String>? seedId,
    Expression<String>? shotId,
    Expression<int>? position,
    Expression<String>? path,
    Expression<String>? kind,
    Expression<String>? license,
    Expression<String>? author,
    Expression<String>? sourceUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (builtin != null) 'builtin': builtin,
      if (userEdited != null) 'user_edited': userEdited,
      if (seedId != null) 'seed_id': seedId,
      if (shotId != null) 'shot_id': shotId,
      if (position != null) 'position': position,
      if (path != null) 'path': path,
      if (kind != null) 'kind': kind,
      if (license != null) 'license': license,
      if (author != null) 'author': author,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShotImagesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? builtin,
    Value<bool>? userEdited,
    Value<String?>? seedId,
    Value<String>? shotId,
    Value<int>? position,
    Value<String>? path,
    Value<ShotImageKind>? kind,
    Value<String?>? license,
    Value<String?>? author,
    Value<String?>? sourceUrl,
    Value<int>? rowid,
  }) {
    return ShotImagesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      builtin: builtin ?? this.builtin,
      userEdited: userEdited ?? this.userEdited,
      seedId: seedId ?? this.seedId,
      shotId: shotId ?? this.shotId,
      position: position ?? this.position,
      path: path ?? this.path,
      kind: kind ?? this.kind,
      license: license ?? this.license,
      author: author ?? this.author,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (userEdited.present) {
      map['user_edited'] = Variable<bool>(userEdited.value);
    }
    if (seedId.present) {
      map['seed_id'] = Variable<String>(seedId.value);
    }
    if (shotId.present) {
      map['shot_id'] = Variable<String>(shotId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ShotImagesTable.$converterkind.toSql(kind.value),
      );
    }
    if (license.present) {
      map['license'] = Variable<String>(license.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShotImagesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('builtin: $builtin, ')
          ..write('userEdited: $userEdited, ')
          ..write('seedId: $seedId, ')
          ..write('shotId: $shotId, ')
          ..write('position: $position, ')
          ..write('path: $path, ')
          ..write('kind: $kind, ')
          ..write('license: $license, ')
          ..write('author: $author, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterMapsTable extends CharacterMaps
    with TableInfo<$CharacterMapsTable, CharacterMap> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterMapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String> nodes =
      GeneratedColumn<String>(
        'nodes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<dynamic>>($CharacterMapsTable.$converternodes);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String> edges =
      GeneratedColumn<String>(
        'edges',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<dynamic>>($CharacterMapsTable.$converteredges);
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>, String> groups =
      GeneratedColumn<String>(
        'groups',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<dynamic>>($CharacterMapsTable.$convertergroups);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  viewport = GeneratedColumn<String>(
    'viewport',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($CharacterMapsTable.$converterviewport);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    projectId,
    nodes,
    edges,
    groups,
    viewport,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_maps';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterMap> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterMap map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterMap(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      nodes: $CharacterMapsTable.$converternodes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nodes'],
        )!,
      ),
      edges: $CharacterMapsTable.$converteredges.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}edges'],
        )!,
      ),
      groups: $CharacterMapsTable.$convertergroups.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}groups'],
        )!,
      ),
      viewport: $CharacterMapsTable.$converterviewport.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}viewport'],
        )!,
      ),
    );
  }

  @override
  $CharacterMapsTable createAlias(String alias) {
    return $CharacterMapsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<dynamic>, String> $converternodes = listJson;
  static TypeConverter<List<dynamic>, String> $converteredges = listJson;
  static TypeConverter<List<dynamic>, String> $convertergroups = listJson;
  static TypeConverter<Map<String, dynamic>, String> $converterviewport =
      mapJson;
}

class CharacterMap extends DataClass implements Insertable<CharacterMap> {
  final String id;
  final int createdAt;
  final int updatedAt;
  final String projectId;
  final List<dynamic> nodes;
  final List<dynamic> edges;
  final List<dynamic> groups;
  final Map<String, dynamic> viewport;
  const CharacterMap({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    required this.nodes,
    required this.edges,
    required this.groups,
    required this.viewport,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['project_id'] = Variable<String>(projectId);
    {
      map['nodes'] = Variable<String>(
        $CharacterMapsTable.$converternodes.toSql(nodes),
      );
    }
    {
      map['edges'] = Variable<String>(
        $CharacterMapsTable.$converteredges.toSql(edges),
      );
    }
    {
      map['groups'] = Variable<String>(
        $CharacterMapsTable.$convertergroups.toSql(groups),
      );
    }
    {
      map['viewport'] = Variable<String>(
        $CharacterMapsTable.$converterviewport.toSql(viewport),
      );
    }
    return map;
  }

  CharacterMapsCompanion toCompanion(bool nullToAbsent) {
    return CharacterMapsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      projectId: Value(projectId),
      nodes: Value(nodes),
      edges: Value(edges),
      groups: Value(groups),
      viewport: Value(viewport),
    );
  }

  factory CharacterMap.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterMap(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      nodes: serializer.fromJson<List<dynamic>>(json['nodes']),
      edges: serializer.fromJson<List<dynamic>>(json['edges']),
      groups: serializer.fromJson<List<dynamic>>(json['groups']),
      viewport: serializer.fromJson<Map<String, dynamic>>(json['viewport']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'projectId': serializer.toJson<String>(projectId),
      'nodes': serializer.toJson<List<dynamic>>(nodes),
      'edges': serializer.toJson<List<dynamic>>(edges),
      'groups': serializer.toJson<List<dynamic>>(groups),
      'viewport': serializer.toJson<Map<String, dynamic>>(viewport),
    };
  }

  CharacterMap copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? projectId,
    List<dynamic>? nodes,
    List<dynamic>? edges,
    List<dynamic>? groups,
    Map<String, dynamic>? viewport,
  }) => CharacterMap(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectId: projectId ?? this.projectId,
    nodes: nodes ?? this.nodes,
    edges: edges ?? this.edges,
    groups: groups ?? this.groups,
    viewport: viewport ?? this.viewport,
  );
  CharacterMap copyWithCompanion(CharacterMapsCompanion data) {
    return CharacterMap(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      nodes: data.nodes.present ? data.nodes.value : this.nodes,
      edges: data.edges.present ? data.edges.value : this.edges,
      groups: data.groups.present ? data.groups.value : this.groups,
      viewport: data.viewport.present ? data.viewport.value : this.viewport,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterMap(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('nodes: $nodes, ')
          ..write('edges: $edges, ')
          ..write('groups: $groups, ')
          ..write('viewport: $viewport')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    projectId,
    nodes,
    edges,
    groups,
    viewport,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterMap &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.projectId == this.projectId &&
          other.nodes == this.nodes &&
          other.edges == this.edges &&
          other.groups == this.groups &&
          other.viewport == this.viewport);
}

class CharacterMapsCompanion extends UpdateCompanion<CharacterMap> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> projectId;
  final Value<List<dynamic>> nodes;
  final Value<List<dynamic>> edges;
  final Value<List<dynamic>> groups;
  final Value<Map<String, dynamic>> viewport;
  final Value<int> rowid;
  const CharacterMapsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.nodes = const Value.absent(),
    this.edges = const Value.absent(),
    this.groups = const Value.absent(),
    this.viewport = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterMapsCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    required String projectId,
    required List<dynamic> nodes,
    required List<dynamic> edges,
    required List<dynamic> groups,
    required Map<String, dynamic> viewport,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       projectId = Value(projectId),
       nodes = Value(nodes),
       edges = Value(edges),
       groups = Value(groups),
       viewport = Value(viewport);
  static Insertable<CharacterMap> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? projectId,
    Expression<String>? nodes,
    Expression<String>? edges,
    Expression<String>? groups,
    Expression<String>? viewport,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (projectId != null) 'project_id': projectId,
      if (nodes != null) 'nodes': nodes,
      if (edges != null) 'edges': edges,
      if (groups != null) 'groups': groups,
      if (viewport != null) 'viewport': viewport,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterMapsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? projectId,
    Value<List<dynamic>>? nodes,
    Value<List<dynamic>>? edges,
    Value<List<dynamic>>? groups,
    Value<Map<String, dynamic>>? viewport,
    Value<int>? rowid,
  }) {
    return CharacterMapsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId ?? this.projectId,
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      groups: groups ?? this.groups,
      viewport: viewport ?? this.viewport,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (nodes.present) {
      map['nodes'] = Variable<String>(
        $CharacterMapsTable.$converternodes.toSql(nodes.value),
      );
    }
    if (edges.present) {
      map['edges'] = Variable<String>(
        $CharacterMapsTable.$converteredges.toSql(edges.value),
      );
    }
    if (groups.present) {
      map['groups'] = Variable<String>(
        $CharacterMapsTable.$convertergroups.toSql(groups.value),
      );
    }
    if (viewport.present) {
      map['viewport'] = Variable<String>(
        $CharacterMapsTable.$converterviewport.toSql(viewport.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterMapsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('nodes: $nodes, ')
          ..write('edges: $edges, ')
          ..write('groups: $groups, ')
          ..write('viewport: $viewport, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  final int updatedAt;
  const Setting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? value, int? updatedAt}) => Setting(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $VoidItemsTable voidItems = $VoidItemsTable(this);
  late final Index voidItemsCreated = Index(
    'void_items_created',
    'CREATE INDEX void_items_created ON void_items (created_at DESC)',
  );
  late final Index voidItemsType = Index(
    'void_items_type',
    'CREATE INDEX void_items_type ON void_items (type)',
  );
  late final Index voidItemsStatus = Index(
    'void_items_status',
    'CREATE INDEX void_items_status ON void_items (status)',
  );
  late final $SlotsTable slots = $SlotsTable(this);
  late final Index slotsTemplatePos = Index(
    'slots_template_pos',
    'CREATE INDEX slots_template_pos ON slots (template_id, position)',
  );
  late final $BeatsTable beats = $BeatsTable(this);
  late final Index beatsProjectSlotPos = Index(
    'beats_project_slot_pos',
    'CREATE INDEX beats_project_slot_pos ON beats (project_id, slot_id, position)',
  );
  late final $ShotsTable shots = $ShotsTable(this);
  late final $FramesTable frames = $FramesTable(this);
  late final Index framesBeatPos = Index(
    'frames_beat_pos',
    'CREATE INDEX frames_beat_pos ON frames (beat_id, position)',
  );
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  late final $ProposalsTable proposals = $ProposalsTable(this);
  late final Index proposalsProjectStatus = Index(
    'proposals_project_status',
    'CREATE INDEX proposals_project_status ON proposals (project_id, status, created_at)',
  );
  late final Index snapshotsProjectCreated = Index(
    'snapshots_project_created',
    'CREATE INDEX snapshots_project_created ON snapshots (project_id, created_at DESC)',
  );
  late final $AiQueueTable aiQueue = $AiQueueTable(this);
  late final Index aiQueueStatusRetry = Index(
    'ai_queue_status_retry',
    'CREATE INDEX ai_queue_status_retry ON ai_queue (status, next_retry_at)',
  );
  late final $CharactersTable characters = $CharactersTable(this);
  late final $ProjectCharactersTable projectCharacters =
      $ProjectCharactersTable(this);
  late final Index projectCharactersLinked = Index(
    'project_characters_linked',
    'CREATE UNIQUE INDEX project_characters_linked ON project_characters (project_id, character_id) WHERE mode = \'linked\'',
  );
  late final VoidItemsFts voidItemsFts = VoidItemsFts(this);
  late final Trigger voidItemsAi = Trigger(
    'CREATE TRIGGER void_items_ai AFTER INSERT ON void_items BEGIN INSERT INTO void_items_fts ("rowid", summary, raw_transcript) VALUES (new."rowid", new.summary, new.raw_transcript);END',
    'void_items_ai',
  );
  late final Trigger voidItemsAd = Trigger(
    'CREATE TRIGGER void_items_ad AFTER DELETE ON void_items BEGIN INSERT INTO void_items_fts (void_items_fts, "rowid", summary, raw_transcript) VALUES (\'delete\', old."rowid", old.summary, old.raw_transcript);END',
    'void_items_ad',
  );
  late final Trigger voidItemsAu = Trigger(
    'CREATE TRIGGER void_items_au AFTER UPDATE ON void_items BEGIN INSERT INTO void_items_fts (void_items_fts, "rowid", summary, raw_transcript) VALUES (\'delete\', old."rowid", old.summary, old.raw_transcript);INSERT INTO void_items_fts ("rowid", summary, raw_transcript) VALUES (new."rowid", new.summary, new.raw_transcript);END',
    'void_items_au',
  );
  late final $ShotImagesTable shotImages = $ShotImagesTable(this);
  late final $CharacterMapsTable characterMaps = $CharacterMapsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final VoidItemsDao voidItemsDao = VoidItemsDao(this as AppDatabase);
  late final ProjectsDao projectsDao = ProjectsDao(this as AppDatabase);
  late final CharactersDao charactersDao = CharactersDao(this as AppDatabase);
  late final BeatsDao beatsDao = BeatsDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final AiQueueDao aiQueueDao = AiQueueDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    templates,
    projects,
    voidItems,
    voidItemsCreated,
    voidItemsType,
    voidItemsStatus,
    slots,
    slotsTemplatePos,
    beats,
    beatsProjectSlotPos,
    shots,
    frames,
    framesBeatPos,
    snapshots,
    proposals,
    proposalsProjectStatus,
    snapshotsProjectCreated,
    aiQueue,
    aiQueueStatusRetry,
    characters,
    projectCharacters,
    projectCharactersLinked,
    voidItemsFts,
    voidItemsAi,
    voidItemsAd,
    voidItemsAu,
    shotImages,
    characterMaps,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('projects', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('projects', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('void_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('beats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'slots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('beats', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'beats',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('frames', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('frames', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('proposals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('proposals', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('proposals', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'snapshots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('proposals', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ai_queue', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ai_queue', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('characters', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('project_characters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('project_characters', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('void_items_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('void_items_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'void_items',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('void_items_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shot_images', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_maps', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  required String name,
  required String description,
  Value<String?> sourceUrl,
  required List<String> projectTypes,
  Value<int> rowid,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  Value<String> name,
  Value<String> description,
  Value<String?> sourceUrl,
  Value<List<String>> projectTypes,
  Value<int> rowid,
});

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, Template> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'templates__id__projects__template_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SlotsTable, List<Slot>> _slotsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.slots,
    aliasName: 'templates__id__slots__template_id',
  );

  $$SlotsTableProcessedTableManager get slotsRefs {
    final manager = $$SlotsTableTableManager(
      $_db,
      $_db.slots,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_slotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get projectTypes => $composableBuilder(
    column: $table.projectTypes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> slotsRefs(
    Expression<bool> Function($$SlotsTableFilterComposer f) f,
  ) {
    final $$SlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slots,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotsTableFilterComposer(
            $db: $db,
            $table: $db.slots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectTypes => $composableBuilder(
    column: $table.projectTypes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedId =>
      $composableBuilder(column: $table.seedId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get projectTypes =>
      $composableBuilder(
        column: $table.projectTypes,
        builder: (column) => column,
      );

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> slotsRefs<T extends Object>(
    Expression<T> Function($$SlotsTableAnnotationComposer a) f,
  ) {
    final $$SlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slots,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.slots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          Template,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (Template, $$TemplatesTableReferences),
          Template,
          PrefetchHooks Function({bool projectsRefs, bool slotsRefs})
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<List<String>> projectTypes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                name: name,
                description: description,
                sourceUrl: sourceUrl,
                projectTypes: projectTypes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                required String name,
                required String description,
                Value<String?> sourceUrl = const Value.absent(),
                required List<String> projectTypes,
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                name: name,
                description: description,
                sourceUrl: sourceUrl,
                projectTypes: projectTypes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplatesTable, Template>(table),
                  $$TemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectsRefs = false, slotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (projectsRefs) db.projects,
                if (slotsRefs) db.slots,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (projectsRefs)
                    await $_getPrefetchedData<
                      Template,
                      $TemplatesTable,
                      Project
                    >(
                      currentTable: table,
                      referencedTable: $$TemplatesTableReferences
                          ._projectsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).projectsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                  if (slotsRefs)
                    await $_getPrefetchedData<Template, $TemplatesTable, Slot>(
                      currentTable: table,
                      referencedTable: $$TemplatesTableReferences
                          ._slotsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TemplatesTableReferences(db, table, p0).slotsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      Template,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (Template, $$TemplatesTableReferences),
      Template,
      PrefetchHooks Function({bool projectsRefs, bool slotsRefs})
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required String title,
  required ProjectType type,
  required String summary,
  Value<String?> templateId,
  required String aspectRatio,
  required Map<String, dynamic> typeFields,
  required Map<String, dynamic> aiPermissions,
  Value<String?> sourceVoidItemId,
  Value<bool> isSample,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> title,
  Value<ProjectType> type,
  Value<String> summary,
  Value<String?> templateId,
  Value<String> aspectRatio,
  Value<Map<String, dynamic>> typeFields,
  Value<Map<String, dynamic>> aiPermissions,
  Value<String?> sourceVoidItemId,
  Value<bool> isSample,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias('projects__template_id__templates__id');

  $$TemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<String>('template_id');
    if ($_column == null) return null;
    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VoidItemsTable _sourceVoidItemIdTable(_$AppDatabase db) =>
      db.voidItems.createAlias('projects__source_void_item_id__void_items__id');

  $$VoidItemsTableProcessedTableManager? get sourceVoidItemId {
    final $_column = $_itemColumn<String>('source_void_item_id');
    if ($_column == null) return null;
    final manager = $$VoidItemsTableTableManager(
      $_db,
      $_db.voidItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceVoidItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VoidItemsTable, List<VoidItem>>
  _voidItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.voidItems,
    aliasName: 'projects__id__void_items__promoted_project_id',
  );

  $$VoidItemsTableProcessedTableManager get voidItemsRefs {
    final manager = $$VoidItemsTableTableManager($_db, $_db.voidItems).filter(
      (f) => f.promotedProjectId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_voidItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BeatsTable, List<Beat>> _beatsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.beats,
    aliasName: 'projects__id__beats__project_id',
  );

  $$BeatsTableProcessedTableManager get beatsRefs {
    final manager = $$BeatsTableTableManager(
      $_db,
      $_db.beats,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_beatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SnapshotsTable, List<Snapshot>>
  _snapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snapshots,
    aliasName: 'projects__id__snapshots__project_id',
  );

  $$SnapshotsTableProcessedTableManager get snapshotsRefs {
    final manager = $$SnapshotsTableTableManager(
      $_db,
      $_db.snapshots,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_snapshotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProposalsTable, List<Proposal>>
  _proposalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.proposals,
    aliasName: 'projects__id__proposals__project_id',
  );

  $$ProposalsTableProcessedTableManager get proposalsRefs {
    final manager = $$ProposalsTableTableManager(
      $_db,
      $_db.proposals,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_proposalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AiQueueTable, List<AiJob>> _aiQueueRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.aiQueue,
    aliasName: 'projects__id__ai_queue__target_project_id',
  );

  $$AiQueueTableProcessedTableManager get aiQueueRefs {
    final manager = $$AiQueueTableTableManager($_db, $_db.aiQueue).filter(
      (f) => f.targetProjectId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_aiQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectCharactersTable, List<ProjectCharacter>>
  _projectCharactersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectCharacters,
        aliasName: 'projects__id__project_characters__project_id',
      );

  $$ProjectCharactersTableProcessedTableManager get projectCharactersRefs {
    final manager = $$ProjectCharactersTableTableManager(
      $_db,
      $_db.projectCharacters,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectCharactersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterMapsTable, List<CharacterMap>>
  _characterMapsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characterMaps,
    aliasName: 'projects__id__character_maps__project_id',
  );

  $$CharacterMapsTableProcessedTableManager get characterMapsRefs {
    final manager = $$CharacterMapsTableTableManager(
      $_db,
      $_db.characterMaps,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_characterMapsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProjectType, ProjectType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get typeFields => $composableBuilder(
    column: $table.typeFields,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get aiPermissions => $composableBuilder(
    column: $table.aiPermissions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isSample => $composableBuilder(
    column: $table.isSample,
    builder: (column) => ColumnFilters(column),
  );

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableFilterComposer get sourceVoidItemId {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> voidItemsRefs(
    Expression<bool> Function($$VoidItemsTableFilterComposer f) f,
  ) {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.promotedProjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> beatsRefs(
    Expression<bool> Function($$BeatsTableFilterComposer f) f,
  ) {
    final $$BeatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableFilterComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> snapshotsRefs(
    Expression<bool> Function($$SnapshotsTableFilterComposer f) f,
  ) {
    final $$SnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> proposalsRefs(
    Expression<bool> Function($$ProposalsTableFilterComposer f) f,
  ) {
    final $$ProposalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proposals,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProposalsTableFilterComposer(
            $db: $db,
            $table: $db.proposals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aiQueueRefs(
    Expression<bool> Function($$AiQueueTableFilterComposer f) f,
  ) {
    final $$AiQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiQueue,
      getReferencedColumn: (t) => t.targetProjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiQueueTableFilterComposer(
            $db: $db,
            $table: $db.aiQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectCharactersRefs(
    Expression<bool> Function($$ProjectCharactersTableFilterComposer f) f,
  ) {
    final $$ProjectCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectCharacters,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectCharactersTableFilterComposer(
            $db: $db,
            $table: $db.projectCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterMapsRefs(
    Expression<bool> Function($$CharacterMapsTableFilterComposer f) f,
  ) {
    final $$CharacterMapsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterMaps,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterMapsTableFilterComposer(
            $db: $db,
            $table: $db.characterMaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeFields => $composableBuilder(
    column: $table.typeFields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiPermissions => $composableBuilder(
    column: $table.aiPermissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSample => $composableBuilder(
    column: $table.isSample,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableOrderingComposer get sourceVoidItemId {
    final $$VoidItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableOrderingComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProjectType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get typeFields => $composableBuilder(
    column: $table.typeFields,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get aiPermissions => $composableBuilder(
    column: $table.aiPermissions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSample =>
      $composableBuilder(column: $table.isSample, builder: (column) => column);

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableAnnotationComposer get sourceVoidItemId {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> voidItemsRefs<T extends Object>(
    Expression<T> Function($$VoidItemsTableAnnotationComposer a) f,
  ) {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.promotedProjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> beatsRefs<T extends Object>(
    Expression<T> Function($$BeatsTableAnnotationComposer a) f,
  ) {
    final $$BeatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableAnnotationComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> snapshotsRefs<T extends Object>(
    Expression<T> Function($$SnapshotsTableAnnotationComposer a) f,
  ) {
    final $$SnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> proposalsRefs<T extends Object>(
    Expression<T> Function($$ProposalsTableAnnotationComposer a) f,
  ) {
    final $$ProposalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proposals,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProposalsTableAnnotationComposer(
            $db: $db,
            $table: $db.proposals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aiQueueRefs<T extends Object>(
    Expression<T> Function($$AiQueueTableAnnotationComposer a) f,
  ) {
    final $$AiQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiQueue,
      getReferencedColumn: (t) => t.targetProjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.aiQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectCharactersRefs<T extends Object>(
    Expression<T> Function($$ProjectCharactersTableAnnotationComposer a) f,
  ) {
    final $$ProjectCharactersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectCharacters,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectCharactersTableAnnotationComposer(
                $db: $db,
                $table: $db.projectCharacters,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterMapsRefs<T extends Object>(
    Expression<T> Function($$CharacterMapsTableAnnotationComposer a) f,
  ) {
    final $$CharacterMapsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterMaps,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterMapsTableAnnotationComposer(
            $db: $db,
            $table: $db.characterMaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool templateId,
            bool sourceVoidItemId,
            bool voidItemsRefs,
            bool beatsRefs,
            bool snapshotsRefs,
            bool proposalsRefs,
            bool aiQueueRefs,
            bool projectCharactersRefs,
            bool characterMapsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<ProjectType> type = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String> aspectRatio = const Value.absent(),
                Value<Map<String, dynamic>> typeFields = const Value.absent(),
                Value<Map<String, dynamic>> aiPermissions =
                    const Value.absent(),
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<bool> isSample = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                type: type,
                summary: summary,
                templateId: templateId,
                aspectRatio: aspectRatio,
                typeFields: typeFields,
                aiPermissions: aiPermissions,
                sourceVoidItemId: sourceVoidItemId,
                isSample: isSample,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String title,
                required ProjectType type,
                required String summary,
                Value<String?> templateId = const Value.absent(),
                required String aspectRatio,
                required Map<String, dynamic> typeFields,
                required Map<String, dynamic> aiPermissions,
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<bool> isSample = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                type: type,
                summary: summary,
                templateId: templateId,
                aspectRatio: aspectRatio,
                typeFields: typeFields,
                aiPermissions: aiPermissions,
                sourceVoidItemId: sourceVoidItemId,
                isSample: isSample,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                templateId = false,
                sourceVoidItemId = false,
                voidItemsRefs = false,
                beatsRefs = false,
                snapshotsRefs = false,
                proposalsRefs = false,
                aiQueueRefs = false,
                projectCharactersRefs = false,
                characterMapsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (voidItemsRefs) db.voidItems,
                    if (beatsRefs) db.beats,
                    if (snapshotsRefs) db.snapshots,
                    if (proposalsRefs) db.proposals,
                    if (aiQueueRefs) db.aiQueue,
                    if (projectCharactersRefs) db.projectCharacters,
                    if (characterMapsRefs) db.characterMaps,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (templateId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.templateId,
                            referencedTable: $$ProjectsTableReferences
                                ._templateIdTable(db),
                            referencedColumn: $$ProjectsTableReferences
                                ._templateIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (sourceVoidItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceVoidItemId,
                            referencedTable: $$ProjectsTableReferences
                                ._sourceVoidItemIdTable(db),
                            referencedColumn: $$ProjectsTableReferences
                                ._sourceVoidItemIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (voidItemsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          VoidItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._voidItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).voidItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promotedProjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (beatsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Beat
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._beatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).beatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (snapshotsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Snapshot
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._snapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).snapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (proposalsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Proposal
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._proposalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).proposalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aiQueueRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          AiJob
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._aiQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).aiQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetProjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectCharactersRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ProjectCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterMapsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          CharacterMap
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._characterMapsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).characterMapsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({
        bool templateId,
        bool sourceVoidItemId,
        bool voidItemsRefs,
        bool beatsRefs,
        bool snapshotsRefs,
        bool proposalsRefs,
        bool aiQueueRefs,
        bool projectCharactersRefs,
        bool characterMapsRefs,
      })
    >;
typedef $$VoidItemsTableCreateCompanionBuilder = VoidItemsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required VoidType type,
  required String summary,
  required String rawTranscript,
  required List<dynamic> summarySpans,
  required Map<String, dynamic> structure,
  required List<String> tags,
  required List<String> usedInProjectIds,
  Value<String?> promotedProjectId,
  required VoidStatus status,
  Value<int> rowid,
});
typedef $$VoidItemsTableUpdateCompanionBuilder = VoidItemsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<VoidType> type,
  Value<String> summary,
  Value<String> rawTranscript,
  Value<List<dynamic>> summarySpans,
  Value<Map<String, dynamic>> structure,
  Value<List<String>> tags,
  Value<List<String>> usedInProjectIds,
  Value<String?> promotedProjectId,
  Value<VoidStatus> status,
  Value<int> rowid,
});

final class $$VoidItemsTableReferences
    extends BaseReferences<_$AppDatabase, $VoidItemsTable, VoidItem> {
  $$VoidItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _promotedProjectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('void_items__promoted_project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get promotedProjectId {
    final $_column = $_itemColumn<String>('promoted_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promotedProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'void_items__id__projects__source_void_item_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager($_db, $_db.projects).filter(
      (f) => f.sourceVoidItemId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AiQueueTable, List<AiJob>> _aiQueueRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.aiQueue,
    aliasName: 'void_items__id__ai_queue__target_void_item_id',
  );

  $$AiQueueTableProcessedTableManager get aiQueueRefs {
    final manager = $$AiQueueTableTableManager($_db, $_db.aiQueue).filter(
      (f) => f.targetVoidItemId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_aiQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharactersTable, List<Character>>
  _charactersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characters,
    aliasName: 'void_items__id__characters__source_void_item_id',
  );

  $$CharactersTableProcessedTableManager get charactersRefs {
    final manager = $$CharactersTableTableManager($_db, $_db.characters).filter(
      (f) => f.sourceVoidItemId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_charactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VoidItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VoidItemsTable> {
  $$VoidItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VoidType, VoidType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get summarySpans => $composableBuilder(
    column: $table.summarySpans,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get structure => $composableBuilder(
    column: $table.structure,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get usedInProjectIds => $composableBuilder(
    column: $table.usedInProjectIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<VoidStatus, VoidStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$ProjectsTableFilterComposer get promotedProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.sourceVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aiQueueRefs(
    Expression<bool> Function($$AiQueueTableFilterComposer f) f,
  ) {
    final $$AiQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiQueue,
      getReferencedColumn: (t) => t.targetVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiQueueTableFilterComposer(
            $db: $db,
            $table: $db.aiQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> charactersRefs(
    Expression<bool> Function($$CharactersTableFilterComposer f) f,
  ) {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.sourceVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VoidItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VoidItemsTable> {
  $$VoidItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summarySpans => $composableBuilder(
    column: $table.summarySpans,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get structure => $composableBuilder(
    column: $table.structure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usedInProjectIds => $composableBuilder(
    column: $table.usedInProjectIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get promotedProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VoidItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoidItemsTable> {
  $$VoidItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VoidType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get summarySpans =>
      $composableBuilder(
        column: $table.summarySpans,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get structure =>
      $composableBuilder(column: $table.structure, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get usedInProjectIds =>
      $composableBuilder(
        column: $table.usedInProjectIds,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<VoidStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get promotedProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.sourceVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aiQueueRefs<T extends Object>(
    Expression<T> Function($$AiQueueTableAnnotationComposer a) f,
  ) {
    final $$AiQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiQueue,
      getReferencedColumn: (t) => t.targetVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.aiQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> charactersRefs<T extends Object>(
    Expression<T> Function($$CharactersTableAnnotationComposer a) f,
  ) {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.sourceVoidItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VoidItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoidItemsTable,
          VoidItem,
          $$VoidItemsTableFilterComposer,
          $$VoidItemsTableOrderingComposer,
          $$VoidItemsTableAnnotationComposer,
          $$VoidItemsTableCreateCompanionBuilder,
          $$VoidItemsTableUpdateCompanionBuilder,
          (VoidItem, $$VoidItemsTableReferences),
          VoidItem,
          PrefetchHooks Function({
            bool promotedProjectId,
            bool projectsRefs,
            bool aiQueueRefs,
            bool charactersRefs,
          })
        > {
  $$VoidItemsTableTableManager(_$AppDatabase db, $VoidItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoidItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoidItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoidItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<VoidType> type = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> rawTranscript = const Value.absent(),
                Value<List<dynamic>> summarySpans = const Value.absent(),
                Value<Map<String, dynamic>> structure = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<List<String>> usedInProjectIds = const Value.absent(),
                Value<String?> promotedProjectId = const Value.absent(),
                Value<VoidStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoidItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                summary: summary,
                rawTranscript: rawTranscript,
                summarySpans: summarySpans,
                structure: structure,
                tags: tags,
                usedInProjectIds: usedInProjectIds,
                promotedProjectId: promotedProjectId,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required VoidType type,
                required String summary,
                required String rawTranscript,
                required List<dynamic> summarySpans,
                required Map<String, dynamic> structure,
                required List<String> tags,
                required List<String> usedInProjectIds,
                Value<String?> promotedProjectId = const Value.absent(),
                required VoidStatus status,
                Value<int> rowid = const Value.absent(),
              }) => VoidItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                summary: summary,
                rawTranscript: rawTranscript,
                summarySpans: summarySpans,
                structure: structure,
                tags: tags,
                usedInProjectIds: usedInProjectIds,
                promotedProjectId: promotedProjectId,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VoidItemsTable, VoidItem>(table),
                  $$VoidItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                promotedProjectId = false,
                projectsRefs = false,
                aiQueueRefs = false,
                charactersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectsRefs) db.projects,
                    if (aiQueueRefs) db.aiQueue,
                    if (charactersRefs) db.characters,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (promotedProjectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.promotedProjectId,
                            referencedTable: $$VoidItemsTableReferences
                                ._promotedProjectIdTable(db),
                            referencedColumn: $$VoidItemsTableReferences
                                ._promotedProjectIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          VoidItem,
                          $VoidItemsTable,
                          Project
                        >(
                          currentTable: table,
                          referencedTable: $$VoidItemsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VoidItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceVoidItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aiQueueRefs)
                        await $_getPrefetchedData<
                          VoidItem,
                          $VoidItemsTable,
                          AiJob
                        >(
                          currentTable: table,
                          referencedTable: $$VoidItemsTableReferences
                              ._aiQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VoidItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).aiQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetVoidItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (charactersRefs)
                        await $_getPrefetchedData<
                          VoidItem,
                          $VoidItemsTable,
                          Character
                        >(
                          currentTable: table,
                          referencedTable: $$VoidItemsTableReferences
                              ._charactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VoidItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).charactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceVoidItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VoidItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoidItemsTable,
      VoidItem,
      $$VoidItemsTableFilterComposer,
      $$VoidItemsTableOrderingComposer,
      $$VoidItemsTableAnnotationComposer,
      $$VoidItemsTableCreateCompanionBuilder,
      $$VoidItemsTableUpdateCompanionBuilder,
      (VoidItem, $$VoidItemsTableReferences),
      VoidItem,
      PrefetchHooks Function({
        bool promotedProjectId,
        bool projectsRefs,
        bool aiQueueRefs,
        bool charactersRefs,
      })
    >;
typedef $$SlotsTableCreateCompanionBuilder = SlotsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  required String templateId,
  required int position,
  required String name,
  required String description,
  Value<double?> runtimeProportion,
  Value<int> rowid,
});
typedef $$SlotsTableUpdateCompanionBuilder = SlotsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  Value<String> templateId,
  Value<int> position,
  Value<String> name,
  Value<String> description,
  Value<double?> runtimeProportion,
  Value<int> rowid,
});

final class $$SlotsTableReferences
    extends BaseReferences<_$AppDatabase, $SlotsTable, Slot> {
  $$SlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias('slots__template_id__templates__id');

  $$TemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BeatsTable, List<Beat>> _beatsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.beats,
    aliasName: 'slots__id__beats__slot_id',
  );

  $$BeatsTableProcessedTableManager get beatsRefs {
    final manager = $$BeatsTableTableManager(
      $_db,
      $_db.beats,
    ).filter((f) => f.slotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_beatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SlotsTableFilterComposer extends Composer<_$AppDatabase, $SlotsTable> {
  $$SlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get runtimeProportion => $composableBuilder(
    column: $table.runtimeProportion,
    builder: (column) => ColumnFilters(column),
  );

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> beatsRefs(
    Expression<bool> Function($$BeatsTableFilterComposer f) f,
  ) {
    final $$BeatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableFilterComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SlotsTable> {
  $$SlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get runtimeProportion => $composableBuilder(
    column: $table.runtimeProportion,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlotsTable> {
  $$SlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedId =>
      $composableBuilder(column: $table.seedId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get runtimeProportion => $composableBuilder(
    column: $table.runtimeProportion,
    builder: (column) => column,
  );

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> beatsRefs<T extends Object>(
    Expression<T> Function($$BeatsTableAnnotationComposer a) f,
  ) {
    final $$BeatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableAnnotationComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlotsTable,
          Slot,
          $$SlotsTableFilterComposer,
          $$SlotsTableOrderingComposer,
          $$SlotsTableAnnotationComposer,
          $$SlotsTableCreateCompanionBuilder,
          $$SlotsTableUpdateCompanionBuilder,
          (Slot, $$SlotsTableReferences),
          Slot,
          PrefetchHooks Function({bool templateId, bool beatsRefs})
        > {
  $$SlotsTableTableManager(_$AppDatabase db, $SlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double?> runtimeProportion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlotsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                templateId: templateId,
                position: position,
                name: name,
                description: description,
                runtimeProportion: runtimeProportion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                required String templateId,
                required int position,
                required String name,
                required String description,
                Value<double?> runtimeProportion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlotsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                templateId: templateId,
                position: position,
                name: name,
                description: description,
                runtimeProportion: runtimeProportion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SlotsTable, Slot>(table),
                  $$SlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, beatsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (beatsRefs) db.beats],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.templateId,
                        referencedTable: $$SlotsTableReferences
                            ._templateIdTable(db),
                        referencedColumn: $$SlotsTableReferences
                            ._templateIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (beatsRefs)
                    await $_getPrefetchedData<Slot, $SlotsTable, Beat>(
                      currentTable: table,
                      referencedTable: $$SlotsTableReferences._beatsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SlotsTableReferences(db, table, p0).beatsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.slotId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlotsTable,
      Slot,
      $$SlotsTableFilterComposer,
      $$SlotsTableOrderingComposer,
      $$SlotsTableAnnotationComposer,
      $$SlotsTableCreateCompanionBuilder,
      $$SlotsTableUpdateCompanionBuilder,
      (Slot, $$SlotsTableReferences),
      Slot,
      PrefetchHooks Function({bool templateId, bool beatsRefs})
    >;
typedef $$BeatsTableCreateCompanionBuilder = BeatsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required String projectId,
  Value<String?> slotId,
  required int position,
  required String title,
  required String description,
  required List<String> characterIds,
  Value<List<dynamic>?> blocks,
  Value<List<dynamic>?> sayShow,
  Value<int> rowid,
});
typedef $$BeatsTableUpdateCompanionBuilder = BeatsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> projectId,
  Value<String?> slotId,
  Value<int> position,
  Value<String> title,
  Value<String> description,
  Value<List<String>> characterIds,
  Value<List<dynamic>?> blocks,
  Value<List<dynamic>?> sayShow,
  Value<int> rowid,
});

final class $$BeatsTableReferences
    extends BaseReferences<_$AppDatabase, $BeatsTable, Beat> {
  $$BeatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('beats__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SlotsTable _slotIdTable(_$AppDatabase db) =>
      db.slots.createAlias('beats__slot_id__slots__id');

  $$SlotsTableProcessedTableManager? get slotId {
    final $_column = $_itemColumn<String>('slot_id');
    if ($_column == null) return null;
    final manager = $$SlotsTableTableManager(
      $_db,
      $_db.slots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_slotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FramesTable, List<Frame>> _framesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.frames,
    aliasName: 'beats__id__frames__beat_id',
  );

  $$FramesTableProcessedTableManager get framesRefs {
    final manager = $$FramesTableTableManager(
      $_db,
      $_db.frames,
    ).filter((f) => f.beatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_framesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BeatsTableFilterComposer extends Composer<_$AppDatabase, $BeatsTable> {
  $$BeatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get characterIds => $composableBuilder(
    column: $table.characterIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>?, List<dynamic>, String>
  get blocks => $composableBuilder(
    column: $table.blocks,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>?, List<dynamic>, String>
  get sayShow => $composableBuilder(
    column: $table.sayShow,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SlotsTableFilterComposer get slotId {
    final $$SlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.slots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotsTableFilterComposer(
            $db: $db,
            $table: $db.slots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> framesRefs(
    Expression<bool> Function($$FramesTableFilterComposer f) f,
  ) {
    final $$FramesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.frames,
      getReferencedColumn: (t) => t.beatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FramesTableFilterComposer(
            $db: $db,
            $table: $db.frames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BeatsTableOrderingComposer
    extends Composer<_$AppDatabase, $BeatsTable> {
  $$BeatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characterIds => $composableBuilder(
    column: $table.characterIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blocks => $composableBuilder(
    column: $table.blocks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sayShow => $composableBuilder(
    column: $table.sayShow,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SlotsTableOrderingComposer get slotId {
    final $$SlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.slots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotsTableOrderingComposer(
            $db: $db,
            $table: $db.slots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BeatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeatsTable> {
  $$BeatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get characterIds =>
      $composableBuilder(
        column: $table.characterIds,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<dynamic>?, String> get blocks =>
      $composableBuilder(column: $table.blocks, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<dynamic>?, String> get sayShow =>
      $composableBuilder(column: $table.sayShow, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SlotsTableAnnotationComposer get slotId {
    final $$SlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.slots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.slots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> framesRefs<T extends Object>(
    Expression<T> Function($$FramesTableAnnotationComposer a) f,
  ) {
    final $$FramesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.frames,
      getReferencedColumn: (t) => t.beatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FramesTableAnnotationComposer(
            $db: $db,
            $table: $db.frames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BeatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BeatsTable,
          Beat,
          $$BeatsTableFilterComposer,
          $$BeatsTableOrderingComposer,
          $$BeatsTableAnnotationComposer,
          $$BeatsTableCreateCompanionBuilder,
          $$BeatsTableUpdateCompanionBuilder,
          (Beat, $$BeatsTableReferences),
          Beat,
          PrefetchHooks Function({bool projectId, bool slotId, bool framesRefs})
        > {
  $$BeatsTableTableManager(_$AppDatabase db, $BeatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String?> slotId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<List<String>> characterIds = const Value.absent(),
                Value<List<dynamic>?> blocks = const Value.absent(),
                Value<List<dynamic>?> sayShow = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BeatsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                slotId: slotId,
                position: position,
                title: title,
                description: description,
                characterIds: characterIds,
                blocks: blocks,
                sayShow: sayShow,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String projectId,
                Value<String?> slotId = const Value.absent(),
                required int position,
                required String title,
                required String description,
                required List<String> characterIds,
                Value<List<dynamic>?> blocks = const Value.absent(),
                Value<List<dynamic>?> sayShow = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BeatsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                slotId: slotId,
                position: position,
                title: title,
                description: description,
                characterIds: characterIds,
                blocks: blocks,
                sayShow: sayShow,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BeatsTable, Beat>(table),
                  $$BeatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, slotId = false, framesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (framesRefs) db.frames],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$BeatsTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$BeatsTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (slotId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.slotId,
                            referencedTable: $$BeatsTableReferences
                                ._slotIdTable(db),
                            referencedColumn: $$BeatsTableReferences
                                ._slotIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (framesRefs)
                        await $_getPrefetchedData<Beat, $BeatsTable, Frame>(
                          currentTable: table,
                          referencedTable: $$BeatsTableReferences
                              ._framesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BeatsTableReferences(db, table, p0).framesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.beatId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BeatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BeatsTable,
      Beat,
      $$BeatsTableFilterComposer,
      $$BeatsTableOrderingComposer,
      $$BeatsTableAnnotationComposer,
      $$BeatsTableCreateCompanionBuilder,
      $$BeatsTableUpdateCompanionBuilder,
      (Beat, $$BeatsTableReferences),
      Beat,
      PrefetchHooks Function({bool projectId, bool slotId, bool framesRefs})
    >;
typedef $$ShotsTableCreateCompanionBuilder = ShotsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  required String name,
  required ShotCategory category,
  required String description,
  required String whenToUse,
  required String effect,
  required List<String> tags,
  required List<dynamic> sources,
  Value<int> rowid,
});
typedef $$ShotsTableUpdateCompanionBuilder = ShotsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  Value<String> name,
  Value<ShotCategory> category,
  Value<String> description,
  Value<String> whenToUse,
  Value<String> effect,
  Value<List<String>> tags,
  Value<List<dynamic>> sources,
  Value<int> rowid,
});

final class $$ShotsTableReferences
    extends BaseReferences<_$AppDatabase, $ShotsTable, Shot> {
  $$ShotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FramesTable, List<Frame>> _framesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.frames,
    aliasName: 'shots__id__frames__shot_id',
  );

  $$FramesTableProcessedTableManager get framesRefs {
    final manager = $$FramesTableTableManager(
      $_db,
      $_db.frames,
    ).filter((f) => f.shotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_framesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShotImagesTable, List<ShotImage>>
  _shotImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shotImages,
    aliasName: 'shots__id__shot_images__shot_id',
  );

  $$ShotImagesTableProcessedTableManager get shotImagesRefs {
    final manager = $$ShotImagesTableTableManager(
      $_db,
      $_db.shotImages,
    ).filter((f) => f.shotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shotImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShotsTableFilterComposer extends Composer<_$AppDatabase, $ShotsTable> {
  $$ShotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ShotCategory, ShotCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whenToUse => $composableBuilder(
    column: $table.whenToUse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effect => $composableBuilder(
    column: $table.effect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get sources => $composableBuilder(
    column: $table.sources,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> framesRefs(
    Expression<bool> Function($$FramesTableFilterComposer f) f,
  ) {
    final $$FramesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.frames,
      getReferencedColumn: (t) => t.shotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FramesTableFilterComposer(
            $db: $db,
            $table: $db.frames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shotImagesRefs(
    Expression<bool> Function($$ShotImagesTableFilterComposer f) f,
  ) {
    final $$ShotImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shotImages,
      getReferencedColumn: (t) => t.shotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotImagesTableFilterComposer(
            $db: $db,
            $table: $db.shotImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShotsTable> {
  $$ShotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whenToUse => $composableBuilder(
    column: $table.whenToUse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effect => $composableBuilder(
    column: $table.effect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sources => $composableBuilder(
    column: $table.sources,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShotsTable> {
  $$ShotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedId =>
      $composableBuilder(column: $table.seedId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ShotCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whenToUse =>
      $composableBuilder(column: $table.whenToUse, builder: (column) => column);

  GeneratedColumn<String> get effect =>
      $composableBuilder(column: $table.effect, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get sources =>
      $composableBuilder(column: $table.sources, builder: (column) => column);

  Expression<T> framesRefs<T extends Object>(
    Expression<T> Function($$FramesTableAnnotationComposer a) f,
  ) {
    final $$FramesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.frames,
      getReferencedColumn: (t) => t.shotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FramesTableAnnotationComposer(
            $db: $db,
            $table: $db.frames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shotImagesRefs<T extends Object>(
    Expression<T> Function($$ShotImagesTableAnnotationComposer a) f,
  ) {
    final $$ShotImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shotImages,
      getReferencedColumn: (t) => t.shotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.shotImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShotsTable,
          Shot,
          $$ShotsTableFilterComposer,
          $$ShotsTableOrderingComposer,
          $$ShotsTableAnnotationComposer,
          $$ShotsTableCreateCompanionBuilder,
          $$ShotsTableUpdateCompanionBuilder,
          (Shot, $$ShotsTableReferences),
          Shot,
          PrefetchHooks Function({bool framesRefs, bool shotImagesRefs})
        > {
  $$ShotsTableTableManager(_$AppDatabase db, $ShotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<ShotCategory> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> whenToUse = const Value.absent(),
                Value<String> effect = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<List<dynamic>> sources = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShotsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                name: name,
                category: category,
                description: description,
                whenToUse: whenToUse,
                effect: effect,
                tags: tags,
                sources: sources,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                required String name,
                required ShotCategory category,
                required String description,
                required String whenToUse,
                required String effect,
                required List<String> tags,
                required List<dynamic> sources,
                Value<int> rowid = const Value.absent(),
              }) => ShotsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                name: name,
                category: category,
                description: description,
                whenToUse: whenToUse,
                effect: effect,
                tags: tags,
                sources: sources,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShotsTable, Shot>(table),
                  $$ShotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({framesRefs = false, shotImagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (framesRefs) db.frames,
                    if (shotImagesRefs) db.shotImages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (framesRefs)
                        await $_getPrefetchedData<Shot, $ShotsTable, Frame>(
                          currentTable: table,
                          referencedTable: $$ShotsTableReferences
                              ._framesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShotsTableReferences(db, table, p0).framesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shotId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shotImagesRefs)
                        await $_getPrefetchedData<Shot, $ShotsTable, ShotImage>(
                          currentTable: table,
                          referencedTable: $$ShotsTableReferences
                              ._shotImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShotsTableReferences(
                                db,
                                table,
                                p0,
                              ).shotImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShotsTable,
      Shot,
      $$ShotsTableFilterComposer,
      $$ShotsTableOrderingComposer,
      $$ShotsTableAnnotationComposer,
      $$ShotsTableCreateCompanionBuilder,
      $$ShotsTableUpdateCompanionBuilder,
      (Shot, $$ShotsTableReferences),
      Shot,
      PrefetchHooks Function({bool framesRefs, bool shotImagesRefs})
    >;
typedef $$FramesTableCreateCompanionBuilder = FramesCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required String beatId,
  required int position,
  Value<String?> strokesPath,
  Value<String?> thumbnailPath,
  Value<String?> aspectRatio,
  Value<String?> shotSize,
  Value<String?> angle,
  Value<String?> movement,
  Value<String?> lensFeel,
  Value<int?> durationMs,
  required String notes,
  Value<String?> blockId,
  required List<String> characterIds,
  required List<dynamic> referenceImages,
  Value<String?> shotId,
  Value<int> rowid,
});
typedef $$FramesTableUpdateCompanionBuilder = FramesCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> beatId,
  Value<int> position,
  Value<String?> strokesPath,
  Value<String?> thumbnailPath,
  Value<String?> aspectRatio,
  Value<String?> shotSize,
  Value<String?> angle,
  Value<String?> movement,
  Value<String?> lensFeel,
  Value<int?> durationMs,
  Value<String> notes,
  Value<String?> blockId,
  Value<List<String>> characterIds,
  Value<List<dynamic>> referenceImages,
  Value<String?> shotId,
  Value<int> rowid,
});

final class $$FramesTableReferences
    extends BaseReferences<_$AppDatabase, $FramesTable, Frame> {
  $$FramesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BeatsTable _beatIdTable(_$AppDatabase db) =>
      db.beats.createAlias('frames__beat_id__beats__id');

  $$BeatsTableProcessedTableManager get beatId {
    final $_column = $_itemColumn<String>('beat_id')!;

    final manager = $$BeatsTableTableManager(
      $_db,
      $_db.beats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShotsTable _shotIdTable(_$AppDatabase db) =>
      db.shots.createAlias('frames__shot_id__shots__id');

  $$ShotsTableProcessedTableManager? get shotId {
    final $_column = $_itemColumn<String>('shot_id');
    if ($_column == null) return null;
    final manager = $$ShotsTableTableManager(
      $_db,
      $_db.shots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FramesTableFilterComposer
    extends Composer<_$AppDatabase, $FramesTable> {
  $$FramesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strokesPath => $composableBuilder(
    column: $table.strokesPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shotSize => $composableBuilder(
    column: $table.shotSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get angle => $composableBuilder(
    column: $table.angle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lensFeel => $composableBuilder(
    column: $table.lensFeel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get characterIds => $composableBuilder(
    column: $table.characterIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get referenceImages => $composableBuilder(
    column: $table.referenceImages,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$BeatsTableFilterComposer get beatId {
    final $$BeatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beatId,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableFilterComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShotsTableFilterComposer get shotId {
    final $$ShotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableFilterComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FramesTableOrderingComposer
    extends Composer<_$AppDatabase, $FramesTable> {
  $$FramesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokesPath => $composableBuilder(
    column: $table.strokesPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shotSize => $composableBuilder(
    column: $table.shotSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get angle => $composableBuilder(
    column: $table.angle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lensFeel => $composableBuilder(
    column: $table.lensFeel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characterIds => $composableBuilder(
    column: $table.characterIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceImages => $composableBuilder(
    column: $table.referenceImages,
    builder: (column) => ColumnOrderings(column),
  );

  $$BeatsTableOrderingComposer get beatId {
    final $$BeatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beatId,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableOrderingComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShotsTableOrderingComposer get shotId {
    final $$ShotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableOrderingComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FramesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FramesTable> {
  $$FramesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get strokesPath => $composableBuilder(
    column: $table.strokesPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shotSize =>
      $composableBuilder(column: $table.shotSize, builder: (column) => column);

  GeneratedColumn<String> get angle =>
      $composableBuilder(column: $table.angle, builder: (column) => column);

  GeneratedColumn<String> get movement =>
      $composableBuilder(column: $table.movement, builder: (column) => column);

  GeneratedColumn<String> get lensFeel =>
      $composableBuilder(column: $table.lensFeel, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get characterIds =>
      $composableBuilder(
        column: $table.characterIds,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get referenceImages =>
      $composableBuilder(
        column: $table.referenceImages,
        builder: (column) => column,
      );

  $$BeatsTableAnnotationComposer get beatId {
    final $$BeatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beatId,
      referencedTable: $db.beats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeatsTableAnnotationComposer(
            $db: $db,
            $table: $db.beats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShotsTableAnnotationComposer get shotId {
    final $$ShotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableAnnotationComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FramesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FramesTable,
          Frame,
          $$FramesTableFilterComposer,
          $$FramesTableOrderingComposer,
          $$FramesTableAnnotationComposer,
          $$FramesTableCreateCompanionBuilder,
          $$FramesTableUpdateCompanionBuilder,
          (Frame, $$FramesTableReferences),
          Frame,
          PrefetchHooks Function({bool beatId, bool shotId})
        > {
  $$FramesTableTableManager(_$AppDatabase db, $FramesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FramesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FramesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FramesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> beatId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> strokesPath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> aspectRatio = const Value.absent(),
                Value<String?> shotSize = const Value.absent(),
                Value<String?> angle = const Value.absent(),
                Value<String?> movement = const Value.absent(),
                Value<String?> lensFeel = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> blockId = const Value.absent(),
                Value<List<String>> characterIds = const Value.absent(),
                Value<List<dynamic>> referenceImages = const Value.absent(),
                Value<String?> shotId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FramesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                beatId: beatId,
                position: position,
                strokesPath: strokesPath,
                thumbnailPath: thumbnailPath,
                aspectRatio: aspectRatio,
                shotSize: shotSize,
                angle: angle,
                movement: movement,
                lensFeel: lensFeel,
                durationMs: durationMs,
                notes: notes,
                blockId: blockId,
                characterIds: characterIds,
                referenceImages: referenceImages,
                shotId: shotId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String beatId,
                required int position,
                Value<String?> strokesPath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> aspectRatio = const Value.absent(),
                Value<String?> shotSize = const Value.absent(),
                Value<String?> angle = const Value.absent(),
                Value<String?> movement = const Value.absent(),
                Value<String?> lensFeel = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                required String notes,
                Value<String?> blockId = const Value.absent(),
                required List<String> characterIds,
                required List<dynamic> referenceImages,
                Value<String?> shotId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FramesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                beatId: beatId,
                position: position,
                strokesPath: strokesPath,
                thumbnailPath: thumbnailPath,
                aspectRatio: aspectRatio,
                shotSize: shotSize,
                angle: angle,
                movement: movement,
                lensFeel: lensFeel,
                durationMs: durationMs,
                notes: notes,
                blockId: blockId,
                characterIds: characterIds,
                referenceImages: referenceImages,
                shotId: shotId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FramesTable, Frame>(table),
                  $$FramesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({beatId = false, shotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (beatId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.beatId,
                        referencedTable: $$FramesTableReferences._beatIdTable(
                          db,
                        ),
                        referencedColumn: $$FramesTableReferences
                            ._beatIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (shotId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.shotId,
                        referencedTable: $$FramesTableReferences._shotIdTable(
                          db,
                        ),
                        referencedColumn: $$FramesTableReferences
                            ._shotIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FramesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FramesTable,
      Frame,
      $$FramesTableFilterComposer,
      $$FramesTableOrderingComposer,
      $$FramesTableAnnotationComposer,
      $$FramesTableCreateCompanionBuilder,
      $$FramesTableUpdateCompanionBuilder,
      (Frame, $$FramesTableReferences),
      Frame,
      PrefetchHooks Function({bool beatId, bool shotId})
    >;
typedef $$SnapshotsTableCreateCompanionBuilder = SnapshotsCompanion Function({
  required String id,
  required String projectId,
  required SnapshotReason reason,
  required String label,
  Value<String?> proposalId,
  Value<String?> restoredFromSnapshotId,
  required Map<String, dynamic> data,
  required int createdAt,
  Value<int> rowid,
});
typedef $$SnapshotsTableUpdateCompanionBuilder = SnapshotsCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<SnapshotReason> reason,
  Value<String> label,
  Value<String?> proposalId,
  Value<String?> restoredFromSnapshotId,
  Value<Map<String, dynamic>> data,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$SnapshotsTableReferences
    extends BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot> {
  $$SnapshotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('snapshots__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProposalsTable, List<Proposal>>
  _proposalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.proposals,
    aliasName: 'snapshots__id__proposals__snapshot_id',
  );

  $$ProposalsTableProcessedTableManager get proposalsRefs {
    final manager = $$ProposalsTableTableManager(
      $_db,
      $_db.proposals,
    ).filter((f) => f.snapshotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_proposalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SnapshotReason, SnapshotReason, String>
  get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restoredFromSnapshotId => $composableBuilder(
    column: $table.restoredFromSnapshotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> proposalsRefs(
    Expression<bool> Function($$ProposalsTableFilterComposer f) f,
  ) {
    final $$ProposalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proposals,
      getReferencedColumn: (t) => t.snapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProposalsTableFilterComposer(
            $db: $db,
            $table: $db.proposals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restoredFromSnapshotId => $composableBuilder(
    column: $table.restoredFromSnapshotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnapshotReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get restoredFromSnapshotId => $composableBuilder(
    column: $table.restoredFromSnapshotId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> proposalsRefs<T extends Object>(
    Expression<T> Function($$ProposalsTableAnnotationComposer a) f,
  ) {
    final $$ProposalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proposals,
      getReferencedColumn: (t) => t.snapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProposalsTableAnnotationComposer(
            $db: $db,
            $table: $db.proposals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnapshotsTable,
          Snapshot,
          $$SnapshotsTableFilterComposer,
          $$SnapshotsTableOrderingComposer,
          $$SnapshotsTableAnnotationComposer,
          $$SnapshotsTableCreateCompanionBuilder,
          $$SnapshotsTableUpdateCompanionBuilder,
          (Snapshot, $$SnapshotsTableReferences),
          Snapshot,
          PrefetchHooks Function({bool projectId, bool proposalsRefs})
        > {
  $$SnapshotsTableTableManager(_$AppDatabase db, $SnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<SnapshotReason> reason = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> proposalId = const Value.absent(),
                Value<String?> restoredFromSnapshotId = const Value.absent(),
                Value<Map<String, dynamic>> data = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion(
                id: id,
                projectId: projectId,
                reason: reason,
                label: label,
                proposalId: proposalId,
                restoredFromSnapshotId: restoredFromSnapshotId,
                data: data,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required SnapshotReason reason,
                required String label,
                Value<String?> proposalId = const Value.absent(),
                Value<String?> restoredFromSnapshotId = const Value.absent(),
                required Map<String, dynamic> data,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion.insert(
                id: id,
                projectId: projectId,
                reason: reason,
                label: label,
                proposalId: proposalId,
                restoredFromSnapshotId: restoredFromSnapshotId,
                data: data,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SnapshotsTable, Snapshot>(table),
                  $$SnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, proposalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (proposalsRefs) db.proposals],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$SnapshotsTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$SnapshotsTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (proposalsRefs)
                    await $_getPrefetchedData<
                      Snapshot,
                      $SnapshotsTable,
                      Proposal
                    >(
                      currentTable: table,
                      referencedTable: $$SnapshotsTableReferences
                          ._proposalsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SnapshotsTableReferences(
                            db,
                            table,
                            p0,
                          ).proposalsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.snapshotId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnapshotsTable,
      Snapshot,
      $$SnapshotsTableFilterComposer,
      $$SnapshotsTableOrderingComposer,
      $$SnapshotsTableAnnotationComposer,
      $$SnapshotsTableCreateCompanionBuilder,
      $$SnapshotsTableUpdateCompanionBuilder,
      (Snapshot, $$SnapshotsTableReferences),
      Snapshot,
      PrefetchHooks Function({bool projectId, bool proposalsRefs})
    >;
typedef $$ProposalsTableCreateCompanionBuilder = ProposalsCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required String projectId,
  required ProposalStatus status,
  required String summary,
  required String rawTranscript,
  required List<dynamic> summarySpans,
  required List<dynamic> changes,
  Value<String?> sourceVoidItemId,
  Value<String?> rejectedToVoidItemId,
  Value<String?> snapshotId,
  Value<int?> resolvedAt,
  Value<int> rowid,
});
typedef $$ProposalsTableUpdateCompanionBuilder = ProposalsCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> projectId,
  Value<ProposalStatus> status,
  Value<String> summary,
  Value<String> rawTranscript,
  Value<List<dynamic>> summarySpans,
  Value<List<dynamic>> changes,
  Value<String?> sourceVoidItemId,
  Value<String?> rejectedToVoidItemId,
  Value<String?> snapshotId,
  Value<int?> resolvedAt,
  Value<int> rowid,
});

final class $$ProposalsTableReferences
    extends BaseReferences<_$AppDatabase, $ProposalsTable, Proposal> {
  $$ProposalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('proposals__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VoidItemsTable _sourceVoidItemIdTable(_$AppDatabase db) => db
      .voidItems
      .createAlias('proposals__source_void_item_id__void_items__id');

  $$VoidItemsTableProcessedTableManager? get sourceVoidItemId {
    final $_column = $_itemColumn<String>('source_void_item_id');
    if ($_column == null) return null;
    final manager = $$VoidItemsTableTableManager(
      $_db,
      $_db.voidItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceVoidItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VoidItemsTable _rejectedToVoidItemIdTable(_$AppDatabase db) => db
      .voidItems
      .createAlias('proposals__rejected_to_void_item_id__void_items__id');

  $$VoidItemsTableProcessedTableManager? get rejectedToVoidItemId {
    final $_column = $_itemColumn<String>('rejected_to_void_item_id');
    if ($_column == null) return null;
    final manager = $$VoidItemsTableTableManager(
      $_db,
      $_db.voidItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _rejectedToVoidItemIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SnapshotsTable _snapshotIdTable(_$AppDatabase db) =>
      db.snapshots.createAlias('proposals__snapshot_id__snapshots__id');

  $$SnapshotsTableProcessedTableManager? get snapshotId {
    final $_column = $_itemColumn<String>('snapshot_id');
    if ($_column == null) return null;
    final manager = $$SnapshotsTableTableManager(
      $_db,
      $_db.snapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snapshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProposalsTableFilterComposer
    extends Composer<_$AppDatabase, $ProposalsTable> {
  $$ProposalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProposalStatus, ProposalStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get summarySpans => $composableBuilder(
    column: $table.summarySpans,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get changes => $composableBuilder(
    column: $table.changes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableFilterComposer get sourceVoidItemId {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableFilterComposer get rejectedToVoidItemId {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rejectedToVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SnapshotsTableFilterComposer get snapshotId {
    final $$SnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProposalsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProposalsTable> {
  $$ProposalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summarySpans => $composableBuilder(
    column: $table.summarySpans,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changes => $composableBuilder(
    column: $table.changes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableOrderingComposer get sourceVoidItemId {
    final $$VoidItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableOrderingComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableOrderingComposer get rejectedToVoidItemId {
    final $$VoidItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rejectedToVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableOrderingComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SnapshotsTableOrderingComposer get snapshotId {
    final $$SnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProposalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProposalsTable> {
  $$ProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProposalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get summarySpans =>
      $composableBuilder(
        column: $table.summarySpans,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get changes =>
      $composableBuilder(column: $table.changes, builder: (column) => column);

  GeneratedColumn<int> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableAnnotationComposer get sourceVoidItemId {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VoidItemsTableAnnotationComposer get rejectedToVoidItemId {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rejectedToVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SnapshotsTableAnnotationComposer get snapshotId {
    final $$SnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProposalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProposalsTable,
          Proposal,
          $$ProposalsTableFilterComposer,
          $$ProposalsTableOrderingComposer,
          $$ProposalsTableAnnotationComposer,
          $$ProposalsTableCreateCompanionBuilder,
          $$ProposalsTableUpdateCompanionBuilder,
          (Proposal, $$ProposalsTableReferences),
          Proposal,
          PrefetchHooks Function({
            bool projectId,
            bool sourceVoidItemId,
            bool rejectedToVoidItemId,
            bool snapshotId,
          })
        > {
  $$ProposalsTableTableManager(_$AppDatabase db, $ProposalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProposalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<ProposalStatus> status = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> rawTranscript = const Value.absent(),
                Value<List<dynamic>> summarySpans = const Value.absent(),
                Value<List<dynamic>> changes = const Value.absent(),
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<String?> rejectedToVoidItemId = const Value.absent(),
                Value<String?> snapshotId = const Value.absent(),
                Value<int?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProposalsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                status: status,
                summary: summary,
                rawTranscript: rawTranscript,
                summarySpans: summarySpans,
                changes: changes,
                sourceVoidItemId: sourceVoidItemId,
                rejectedToVoidItemId: rejectedToVoidItemId,
                snapshotId: snapshotId,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String projectId,
                required ProposalStatus status,
                required String summary,
                required String rawTranscript,
                required List<dynamic> summarySpans,
                required List<dynamic> changes,
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<String?> rejectedToVoidItemId = const Value.absent(),
                Value<String?> snapshotId = const Value.absent(),
                Value<int?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProposalsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                status: status,
                summary: summary,
                rawTranscript: rawTranscript,
                summarySpans: summarySpans,
                changes: changes,
                sourceVoidItemId: sourceVoidItemId,
                rejectedToVoidItemId: rejectedToVoidItemId,
                snapshotId: snapshotId,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProposalsTable, Proposal>(table),
                  $$ProposalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                sourceVoidItemId = false,
                rejectedToVoidItemId = false,
                snapshotId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$ProposalsTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$ProposalsTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (sourceVoidItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceVoidItemId,
                            referencedTable: $$ProposalsTableReferences
                                ._sourceVoidItemIdTable(db),
                            referencedColumn: $$ProposalsTableReferences
                                ._sourceVoidItemIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (rejectedToVoidItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rejectedToVoidItemId,
                            referencedTable: $$ProposalsTableReferences
                                ._rejectedToVoidItemIdTable(db),
                            referencedColumn: $$ProposalsTableReferences
                                ._rejectedToVoidItemIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (snapshotId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.snapshotId,
                            referencedTable: $$ProposalsTableReferences
                                ._snapshotIdTable(db),
                            referencedColumn: $$ProposalsTableReferences
                                ._snapshotIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProposalsTable,
      Proposal,
      $$ProposalsTableFilterComposer,
      $$ProposalsTableOrderingComposer,
      $$ProposalsTableAnnotationComposer,
      $$ProposalsTableCreateCompanionBuilder,
      $$ProposalsTableUpdateCompanionBuilder,
      (Proposal, $$ProposalsTableReferences),
      Proposal,
      PrefetchHooks Function({
        bool projectId,
        bool sourceVoidItemId,
        bool rejectedToVoidItemId,
        bool snapshotId,
      })
    >;
typedef $$AiQueueTableCreateCompanionBuilder = AiQueueCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required QueueKind kind,
  required QueueStatus status,
  Value<int> attempts,
  Value<int?> nextRetryAt,
  Value<String?> error,
  required Map<String, dynamic> payload,
  Value<String?> targetVoidItemId,
  Value<String?> targetProjectId,
  Value<int> rowid,
});
typedef $$AiQueueTableUpdateCompanionBuilder = AiQueueCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<QueueKind> kind,
  Value<QueueStatus> status,
  Value<int> attempts,
  Value<int?> nextRetryAt,
  Value<String?> error,
  Value<Map<String, dynamic>> payload,
  Value<String?> targetVoidItemId,
  Value<String?> targetProjectId,
  Value<int> rowid,
});

final class $$AiQueueTableReferences
    extends BaseReferences<_$AppDatabase, $AiQueueTable, AiJob> {
  $$AiQueueTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VoidItemsTable _targetVoidItemIdTable(_$AppDatabase db) =>
      db.voidItems.createAlias('ai_queue__target_void_item_id__void_items__id');

  $$VoidItemsTableProcessedTableManager? get targetVoidItemId {
    final $_column = $_itemColumn<String>('target_void_item_id');
    if ($_column == null) return null;
    final manager = $$VoidItemsTableTableManager(
      $_db,
      $_db.voidItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetVoidItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _targetProjectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('ai_queue__target_project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get targetProjectId {
    final $_column = $_itemColumn<String>('target_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiQueueTableFilterComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueueKind, QueueKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<QueueStatus, QueueStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$VoidItemsTableFilterComposer get targetVoidItemId {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get targetProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$VoidItemsTableOrderingComposer get targetVoidItemId {
    final $$VoidItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableOrderingComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get targetProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueueKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueueStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$VoidItemsTableAnnotationComposer get targetVoidItemId {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get targetProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiQueueTable,
          AiJob,
          $$AiQueueTableFilterComposer,
          $$AiQueueTableOrderingComposer,
          $$AiQueueTableAnnotationComposer,
          $$AiQueueTableCreateCompanionBuilder,
          $$AiQueueTableUpdateCompanionBuilder,
          (AiJob, $$AiQueueTableReferences),
          AiJob,
          PrefetchHooks Function({bool targetVoidItemId, bool targetProjectId})
        > {
  $$AiQueueTableTableManager(_$AppDatabase db, $AiQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<QueueKind> kind = const Value.absent(),
                Value<QueueStatus> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int?> nextRetryAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<Map<String, dynamic>> payload = const Value.absent(),
                Value<String?> targetVoidItemId = const Value.absent(),
                Value<String?> targetProjectId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiQueueCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                kind: kind,
                status: status,
                attempts: attempts,
                nextRetryAt: nextRetryAt,
                error: error,
                payload: payload,
                targetVoidItemId: targetVoidItemId,
                targetProjectId: targetProjectId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required QueueKind kind,
                required QueueStatus status,
                Value<int> attempts = const Value.absent(),
                Value<int?> nextRetryAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required Map<String, dynamic> payload,
                Value<String?> targetVoidItemId = const Value.absent(),
                Value<String?> targetProjectId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiQueueCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                kind: kind,
                status: status,
                attempts: attempts,
                nextRetryAt: nextRetryAt,
                error: error,
                payload: payload,
                targetVoidItemId: targetVoidItemId,
                targetProjectId: targetProjectId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiQueueTable, AiJob>(table),
                  $$AiQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({targetVoidItemId = false, targetProjectId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (targetVoidItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetVoidItemId,
                            referencedTable: $$AiQueueTableReferences
                                ._targetVoidItemIdTable(db),
                            referencedColumn: $$AiQueueTableReferences
                                ._targetVoidItemIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (targetProjectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetProjectId,
                            referencedTable: $$AiQueueTableReferences
                                ._targetProjectIdTable(db),
                            referencedColumn: $$AiQueueTableReferences
                                ._targetProjectIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AiQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiQueueTable,
      AiJob,
      $$AiQueueTableFilterComposer,
      $$AiQueueTableOrderingComposer,
      $$AiQueueTableAnnotationComposer,
      $$AiQueueTableCreateCompanionBuilder,
      $$AiQueueTableUpdateCompanionBuilder,
      (AiJob, $$AiQueueTableReferences),
      AiJob,
      PrefetchHooks Function({bool targetVoidItemId, bool targetProjectId})
    >;
typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  required String name,
  Value<String?> age,
  required String role,
  required String appearance,
  required String background,
  required String traits,
  required String habits,
  required String wantsNeedsFears,
  required String notes,
  Value<String?> sourceVoidItemId,
  Value<int> rowid,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> name,
  Value<String?> age,
  Value<String> role,
  Value<String> appearance,
  Value<String> background,
  Value<String> traits,
  Value<String> habits,
  Value<String> wantsNeedsFears,
  Value<String> notes,
  Value<String?> sourceVoidItemId,
  Value<int> rowid,
});

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VoidItemsTable _sourceVoidItemIdTable(_$AppDatabase db) => db
      .voidItems
      .createAlias('characters__source_void_item_id__void_items__id');

  $$VoidItemsTableProcessedTableManager? get sourceVoidItemId {
    final $_column = $_itemColumn<String>('source_void_item_id');
    if ($_column == null) return null;
    final manager = $$VoidItemsTableTableManager(
      $_db,
      $_db.voidItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceVoidItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProjectCharactersTable, List<ProjectCharacter>>
  _projectCharactersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectCharacters,
        aliasName: 'characters__id__project_characters__character_id',
      );

  $$ProjectCharactersTableProcessedTableManager get projectCharactersRefs {
    final manager = $$ProjectCharactersTableTableManager(
      $_db,
      $_db.projectCharacters,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectCharactersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habits => $composableBuilder(
    column: $table.habits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$VoidItemsTableFilterComposer get sourceVoidItemId {
    final $$VoidItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableFilterComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> projectCharactersRefs(
    Expression<bool> Function($$ProjectCharactersTableFilterComposer f) f,
  ) {
    final $$ProjectCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectCharacters,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectCharactersTableFilterComposer(
            $db: $db,
            $table: $db.projectCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habits => $composableBuilder(
    column: $table.habits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$VoidItemsTableOrderingComposer get sourceVoidItemId {
    final $$VoidItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableOrderingComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => column,
  );

  GeneratedColumn<String> get traits =>
      $composableBuilder(column: $table.traits, builder: (column) => column);

  GeneratedColumn<String> get habits =>
      $composableBuilder(column: $table.habits, builder: (column) => column);

  GeneratedColumn<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$VoidItemsTableAnnotationComposer get sourceVoidItemId {
    final $$VoidItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceVoidItemId,
      referencedTable: $db.voidItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoidItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.voidItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> projectCharactersRefs<T extends Object>(
    Expression<T> Function($$ProjectCharactersTableAnnotationComposer a) f,
  ) {
    final $$ProjectCharactersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectCharacters,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectCharactersTableAnnotationComposer(
                $db: $db,
                $table: $db.projectCharacters,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (Character, $$CharactersTableReferences),
          Character,
          PrefetchHooks Function({
            bool sourceVoidItemId,
            bool projectCharactersRefs,
          })
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> age = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<String> background = const Value.absent(),
                Value<String> traits = const Value.absent(),
                Value<String> habits = const Value.absent(),
                Value<String> wantsNeedsFears = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                age: age,
                role: role,
                appearance: appearance,
                background: background,
                traits: traits,
                habits: habits,
                wantsNeedsFears: wantsNeedsFears,
                notes: notes,
                sourceVoidItemId: sourceVoidItemId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String name,
                Value<String?> age = const Value.absent(),
                required String role,
                required String appearance,
                required String background,
                required String traits,
                required String habits,
                required String wantsNeedsFears,
                required String notes,
                Value<String?> sourceVoidItemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                age: age,
                role: role,
                appearance: appearance,
                background: background,
                traits: traits,
                habits: habits,
                wantsNeedsFears: wantsNeedsFears,
                notes: notes,
                sourceVoidItemId: sourceVoidItemId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharactersTable, Character>(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceVoidItemId = false, projectCharactersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectCharactersRefs) db.projectCharacters,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceVoidItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceVoidItemId,
                            referencedTable: $$CharactersTableReferences
                                ._sourceVoidItemIdTable(db),
                            referencedColumn: $$CharactersTableReferences
                                ._sourceVoidItemIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectCharactersRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          ProjectCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._projectCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, $$CharactersTableReferences),
      Character,
      PrefetchHooks Function({
        bool sourceVoidItemId,
        bool projectCharactersRefs,
      })
    >;
typedef $$ProjectCharactersTableCreateCompanionBuilder =
    ProjectCharactersCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      required String projectId,
      Value<String?> characterId,
      required CharacterMode mode,
      Value<String?> name,
      Value<String?> age,
      Value<String?> role,
      Value<String?> appearance,
      Value<String?> background,
      Value<String?> traits,
      Value<String?> habits,
      Value<String?> wantsNeedsFears,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ProjectCharactersTableUpdateCompanionBuilder =
    ProjectCharactersCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> projectId,
      Value<String?> characterId,
      Value<CharacterMode> mode,
      Value<String?> name,
      Value<String?> age,
      Value<String?> role,
      Value<String?> appearance,
      Value<String?> background,
      Value<String?> traits,
      Value<String?> habits,
      Value<String?> wantsNeedsFears,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$ProjectCharactersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectCharactersTable,
          ProjectCharacter
        > {
  $$ProjectCharactersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_characters__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('project_characters__character_id__characters__id');

  $$CharactersTableProcessedTableManager? get characterId {
    final $_column = $_itemColumn<String>('character_id');
    if ($_column == null) return null;
    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectCharactersTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectCharactersTable> {
  $$ProjectCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CharacterMode, CharacterMode, String>
  get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habits => $composableBuilder(
    column: $table.habits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectCharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectCharactersTable> {
  $$ProjectCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traits => $composableBuilder(
    column: $table.traits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habits => $composableBuilder(
    column: $table.habits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectCharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectCharactersTable> {
  $$ProjectCharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CharacterMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => column,
  );

  GeneratedColumn<String> get traits =>
      $composableBuilder(column: $table.traits, builder: (column) => column);

  GeneratedColumn<String> get habits =>
      $composableBuilder(column: $table.habits, builder: (column) => column);

  GeneratedColumn<String> get wantsNeedsFears => $composableBuilder(
    column: $table.wantsNeedsFears,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectCharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectCharactersTable,
          ProjectCharacter,
          $$ProjectCharactersTableFilterComposer,
          $$ProjectCharactersTableOrderingComposer,
          $$ProjectCharactersTableAnnotationComposer,
          $$ProjectCharactersTableCreateCompanionBuilder,
          $$ProjectCharactersTableUpdateCompanionBuilder,
          (ProjectCharacter, $$ProjectCharactersTableReferences),
          ProjectCharacter,
          PrefetchHooks Function({bool projectId, bool characterId})
        > {
  $$ProjectCharactersTableTableManager(
    _$AppDatabase db,
    $ProjectCharactersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectCharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectCharactersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String?> characterId = const Value.absent(),
                Value<CharacterMode> mode = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> age = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> appearance = const Value.absent(),
                Value<String?> background = const Value.absent(),
                Value<String?> traits = const Value.absent(),
                Value<String?> habits = const Value.absent(),
                Value<String?> wantsNeedsFears = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectCharactersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                characterId: characterId,
                mode: mode,
                name: name,
                age: age,
                role: role,
                appearance: appearance,
                background: background,
                traits: traits,
                habits: habits,
                wantsNeedsFears: wantsNeedsFears,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String projectId,
                Value<String?> characterId = const Value.absent(),
                required CharacterMode mode,
                Value<String?> name = const Value.absent(),
                Value<String?> age = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> appearance = const Value.absent(),
                Value<String?> background = const Value.absent(),
                Value<String?> traits = const Value.absent(),
                Value<String?> habits = const Value.absent(),
                Value<String?> wantsNeedsFears = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectCharactersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                characterId: characterId,
                mode: mode,
                name: name,
                age: age,
                role: role,
                appearance: appearance,
                background: background,
                traits: traits,
                habits: habits,
                wantsNeedsFears: wantsNeedsFears,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectCharactersTable, ProjectCharacter>(table),
                  $$ProjectCharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$ProjectCharactersTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$ProjectCharactersTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$ProjectCharactersTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$ProjectCharactersTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectCharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectCharactersTable,
      ProjectCharacter,
      $$ProjectCharactersTableFilterComposer,
      $$ProjectCharactersTableOrderingComposer,
      $$ProjectCharactersTableAnnotationComposer,
      $$ProjectCharactersTableCreateCompanionBuilder,
      $$ProjectCharactersTableUpdateCompanionBuilder,
      (ProjectCharacter, $$ProjectCharactersTableReferences),
      ProjectCharacter,
      PrefetchHooks Function({bool projectId, bool characterId})
    >;
typedef $VoidItemsFtsCreateCompanionBuilder = VoidItemsFtsCompanion Function({
  required String summary,
  required String rawTranscript,
  Value<int> rowid,
});
typedef $VoidItemsFtsUpdateCompanionBuilder = VoidItemsFtsCompanion Function({
  Value<String> summary,
  Value<String> rawTranscript,
  Value<int> rowid,
});

class $VoidItemsFtsFilterComposer
    extends Composer<_$AppDatabase, VoidItemsFts> {
  $VoidItemsFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnFilters(column),
  );
}

class $VoidItemsFtsOrderingComposer
    extends Composer<_$AppDatabase, VoidItemsFts> {
  $VoidItemsFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => ColumnOrderings(column),
  );
}

class $VoidItemsFtsAnnotationComposer
    extends Composer<_$AppDatabase, VoidItemsFts> {
  $VoidItemsFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get rawTranscript => $composableBuilder(
    column: $table.rawTranscript,
    builder: (column) => column,
  );
}

class $VoidItemsFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          VoidItemsFts,
          VoidItemsFt,
          $VoidItemsFtsFilterComposer,
          $VoidItemsFtsOrderingComposer,
          $VoidItemsFtsAnnotationComposer,
          $VoidItemsFtsCreateCompanionBuilder,
          $VoidItemsFtsUpdateCompanionBuilder,
          (
            VoidItemsFt,
            BaseReferences<_$AppDatabase, VoidItemsFts, VoidItemsFt>,
          ),
          VoidItemsFt,
          PrefetchHooks Function()
        > {
  $VoidItemsFtsTableManager(_$AppDatabase db, VoidItemsFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VoidItemsFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VoidItemsFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VoidItemsFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> summary = const Value.absent(),
                Value<String> rawTranscript = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoidItemsFtsCompanion(
                summary: summary,
                rawTranscript: rawTranscript,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String summary,
                required String rawTranscript,
                Value<int> rowid = const Value.absent(),
              }) => VoidItemsFtsCompanion.insert(
                summary: summary,
                rawTranscript: rawTranscript,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<VoidItemsFts, VoidItemsFt>(table),
                  BaseReferences<_$AppDatabase, VoidItemsFts, VoidItemsFt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $VoidItemsFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      VoidItemsFts,
      VoidItemsFt,
      $VoidItemsFtsFilterComposer,
      $VoidItemsFtsOrderingComposer,
      $VoidItemsFtsAnnotationComposer,
      $VoidItemsFtsCreateCompanionBuilder,
      $VoidItemsFtsUpdateCompanionBuilder,
      (VoidItemsFt, BaseReferences<_$AppDatabase, VoidItemsFts, VoidItemsFt>),
      VoidItemsFt,
      PrefetchHooks Function()
    >;
typedef $$ShotImagesTableCreateCompanionBuilder = ShotImagesCompanion Function({
  required String id,
  required int createdAt,
  required int updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  required String shotId,
  required int position,
  required String path,
  required ShotImageKind kind,
  Value<String?> license,
  Value<String?> author,
  Value<String?> sourceUrl,
  Value<int> rowid,
});
typedef $$ShotImagesTableUpdateCompanionBuilder = ShotImagesCompanion Function({
  Value<String> id,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> builtin,
  Value<bool> userEdited,
  Value<String?> seedId,
  Value<String> shotId,
  Value<int> position,
  Value<String> path,
  Value<ShotImageKind> kind,
  Value<String?> license,
  Value<String?> author,
  Value<String?> sourceUrl,
  Value<int> rowid,
});

final class $$ShotImagesTableReferences
    extends BaseReferences<_$AppDatabase, $ShotImagesTable, ShotImage> {
  $$ShotImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShotsTable _shotIdTable(_$AppDatabase db) =>
      db.shots.createAlias('shot_images__shot_id__shots__id');

  $$ShotsTableProcessedTableManager get shotId {
    final $_column = $_itemColumn<String>('shot_id')!;

    final manager = $$ShotsTableTableManager(
      $_db,
      $_db.shots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShotImagesTableFilterComposer
    extends Composer<_$AppDatabase, $ShotImagesTable> {
  $$ShotImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ShotImageKind, ShotImageKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  $$ShotsTableFilterComposer get shotId {
    final $$ShotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableFilterComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShotImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShotImagesTable> {
  $$ShotImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShotsTableOrderingComposer get shotId {
    final $$ShotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableOrderingComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShotImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShotImagesTable> {
  $$ShotImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get userEdited => $composableBuilder(
    column: $table.userEdited,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seedId =>
      $composableBuilder(column: $table.seedId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ShotImageKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get license =>
      $composableBuilder(column: $table.license, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  $$ShotsTableAnnotationComposer get shotId {
    final $$ShotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shotId,
      referencedTable: $db.shots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShotsTableAnnotationComposer(
            $db: $db,
            $table: $db.shots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShotImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShotImagesTable,
          ShotImage,
          $$ShotImagesTableFilterComposer,
          $$ShotImagesTableOrderingComposer,
          $$ShotImagesTableAnnotationComposer,
          $$ShotImagesTableCreateCompanionBuilder,
          $$ShotImagesTableUpdateCompanionBuilder,
          (ShotImage, $$ShotImagesTableReferences),
          ShotImage,
          PrefetchHooks Function({bool shotId})
        > {
  $$ShotImagesTableTableManager(_$AppDatabase db, $ShotImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShotImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShotImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShotImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                Value<String> shotId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<ShotImageKind> kind = const Value.absent(),
                Value<String?> license = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShotImagesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                shotId: shotId,
                position: position,
                path: path,
                kind: kind,
                license: license,
                author: author,
                sourceUrl: sourceUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<bool> builtin = const Value.absent(),
                Value<bool> userEdited = const Value.absent(),
                Value<String?> seedId = const Value.absent(),
                required String shotId,
                required int position,
                required String path,
                required ShotImageKind kind,
                Value<String?> license = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShotImagesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                builtin: builtin,
                userEdited: userEdited,
                seedId: seedId,
                shotId: shotId,
                position: position,
                path: path,
                kind: kind,
                license: license,
                author: author,
                sourceUrl: sourceUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShotImagesTable, ShotImage>(table),
                  $$ShotImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shotId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.shotId,
                        referencedTable: $$ShotImagesTableReferences
                            ._shotIdTable(db),
                        referencedColumn: $$ShotImagesTableReferences
                            ._shotIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShotImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShotImagesTable,
      ShotImage,
      $$ShotImagesTableFilterComposer,
      $$ShotImagesTableOrderingComposer,
      $$ShotImagesTableAnnotationComposer,
      $$ShotImagesTableCreateCompanionBuilder,
      $$ShotImagesTableUpdateCompanionBuilder,
      (ShotImage, $$ShotImagesTableReferences),
      ShotImage,
      PrefetchHooks Function({bool shotId})
    >;
typedef $$CharacterMapsTableCreateCompanionBuilder =
    CharacterMapsCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      required String projectId,
      required List<dynamic> nodes,
      required List<dynamic> edges,
      required List<dynamic> groups,
      required Map<String, dynamic> viewport,
      Value<int> rowid,
    });
typedef $$CharacterMapsTableUpdateCompanionBuilder =
    CharacterMapsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> projectId,
      Value<List<dynamic>> nodes,
      Value<List<dynamic>> edges,
      Value<List<dynamic>> groups,
      Value<Map<String, dynamic>> viewport,
      Value<int> rowid,
    });

final class $$CharacterMapsTableReferences
    extends BaseReferences<_$AppDatabase, $CharacterMapsTable, CharacterMap> {
  $$CharacterMapsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('character_maps__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterMapsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterMapsTable> {
  $$CharacterMapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get nodes => $composableBuilder(
    column: $table.nodes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get edges => $composableBuilder(
    column: $table.edges,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<dynamic>, List<dynamic>, String>
  get groups => $composableBuilder(
    column: $table.groups,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get viewport => $composableBuilder(
    column: $table.viewport,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMapsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterMapsTable> {
  $$CharacterMapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodes => $composableBuilder(
    column: $table.nodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edges => $composableBuilder(
    column: $table.edges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groups => $composableBuilder(
    column: $table.groups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get viewport => $composableBuilder(
    column: $table.viewport,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterMapsTable> {
  $$CharacterMapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get nodes =>
      $composableBuilder(column: $table.nodes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get edges =>
      $composableBuilder(column: $table.edges, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<dynamic>, String> get groups =>
      $composableBuilder(column: $table.groups, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get viewport =>
      $composableBuilder(column: $table.viewport, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterMapsTable,
          CharacterMap,
          $$CharacterMapsTableFilterComposer,
          $$CharacterMapsTableOrderingComposer,
          $$CharacterMapsTableAnnotationComposer,
          $$CharacterMapsTableCreateCompanionBuilder,
          $$CharacterMapsTableUpdateCompanionBuilder,
          (CharacterMap, $$CharacterMapsTableReferences),
          CharacterMap,
          PrefetchHooks Function({bool projectId})
        > {
  $$CharacterMapsTableTableManager(_$AppDatabase db, $CharacterMapsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterMapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterMapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterMapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<List<dynamic>> nodes = const Value.absent(),
                Value<List<dynamic>> edges = const Value.absent(),
                Value<List<dynamic>> groups = const Value.absent(),
                Value<Map<String, dynamic>> viewport = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterMapsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                nodes: nodes,
                edges: edges,
                groups: groups,
                viewport: viewport,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                required String projectId,
                required List<dynamic> nodes,
                required List<dynamic> edges,
                required List<dynamic> groups,
                required Map<String, dynamic> viewport,
                Value<int> rowid = const Value.absent(),
              }) => CharacterMapsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                nodes: nodes,
                edges: edges,
                groups: groups,
                viewport: viewport,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterMapsTable, CharacterMap>(table),
                  $$CharacterMapsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$CharacterMapsTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$CharacterMapsTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterMapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterMapsTable,
      CharacterMap,
      $$CharacterMapsTableFilterComposer,
      $$CharacterMapsTableOrderingComposer,
      $$CharacterMapsTableAnnotationComposer,
      $$CharacterMapsTableCreateCompanionBuilder,
      $$CharacterMapsTableUpdateCompanionBuilder,
      (CharacterMap, $$CharacterMapsTableReferences),
      CharacterMap,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$VoidItemsTableTableManager get voidItems =>
      $$VoidItemsTableTableManager(_db, _db.voidItems);
  $$SlotsTableTableManager get slots =>
      $$SlotsTableTableManager(_db, _db.slots);
  $$BeatsTableTableManager get beats =>
      $$BeatsTableTableManager(_db, _db.beats);
  $$ShotsTableTableManager get shots =>
      $$ShotsTableTableManager(_db, _db.shots);
  $$FramesTableTableManager get frames =>
      $$FramesTableTableManager(_db, _db.frames);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$ProposalsTableTableManager get proposals =>
      $$ProposalsTableTableManager(_db, _db.proposals);
  $$AiQueueTableTableManager get aiQueue =>
      $$AiQueueTableTableManager(_db, _db.aiQueue);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$ProjectCharactersTableTableManager get projectCharacters =>
      $$ProjectCharactersTableTableManager(_db, _db.projectCharacters);
  $VoidItemsFtsTableManager get voidItemsFts =>
      $VoidItemsFtsTableManager(_db, _db.voidItemsFts);
  $$ShotImagesTableTableManager get shotImages =>
      $$ShotImagesTableTableManager(_db, _db.shotImages);
  $$CharacterMapsTableTableManager get characterMaps =>
      $$CharacterMapsTableTableManager(_db, _db.characterMaps);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
