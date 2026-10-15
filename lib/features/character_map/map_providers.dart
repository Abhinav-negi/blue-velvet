import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

/// Group colour names (DATA_MODEL 11) to muted palette tokens.
const groupColors = <String, Color>{
  'sage': AppColors.sage,
  'ember': AppColors.emberFill,
  'amber': AppColors.amber,
  'slate': AppColors.tealFill,
};

/// Map JSON as plain maps; one project, one row.
class MapData {
  MapData(this.nodes, this.edges, this.groups, this.viewport);
  final List<Map<String, dynamic>> nodes, edges, groups;
  final Map<String, dynamic> viewport;

  factory MapData.empty() =>
      MapData([], [], [], {'x': 0.0, 'y': 0.0, 'zoom': 1.0});

  factory MapData.of(CharacterMap? r) => r == null
      ? MapData.empty()
      : MapData(
          _maps(r.nodes),
          _maps(r.edges),
          _maps(r.groups),
          Map<String, dynamic>.from(r.viewport),
        );

  static List<Map<String, dynamic>> _maps(List<dynamic> l) => [
    for (final e in l) Map<String, dynamic>.from(e as Map),
  ];
}

final mapProvider = StreamProvider.family<MapData, String>((ref, projectId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.characterMaps)
        ..where((t) => t.projectId.equals(projectId)))
      .watchSingleOrNull()
      .map(MapData.of);
});

final _poolProvider = StreamProvider<List<Character>>(
  (ref) => ref.watch(dbProvider).charactersDao.watchAll(),
);

/// project_characters id -> display name (linked = pool row, forked = own).
final mapNamesProvider = StreamProvider.family<Map<String, String>, String>((
  ref,
  projectId,
) {
  final db = ref.watch(dbProvider);
  final pool = ref.watch(_poolProvider).value ?? const <Character>[];
  final byId = {for (final c in pool) c.id: c.name};
  return db.charactersDao
      .watchMembers(projectId)
      .map(
        (ms) => {
          for (final m in ms)
            m.id:
                (m.mode == CharacterMode.forked
                    ? m.name
                    : byId[m.characterId]) ??
                '',
        },
      );
});

/// Quick-pick labels from the RES-06 seed.
final relationshipLabelsProvider = FutureProvider<List<String>>((ref) async {
  final j = jsonDecode(
    await rootBundle.loadString('assets/seed/relationship_labels.json'),
  ) as Map<String, dynamic>;
  return [for (final i in j['items'] as List) (i as Map)['name'] as String];
});

/// Applies [change] to the stored map and saves at once.
Future<void> editMap(
  AppDatabase db,
  String projectId,
  void Function(MapData d) change,
) async {
  final row = await db.charactersDao.mapFor(projectId);
  final d = MapData.of(row);
  change(d);
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.charactersDao.upsertMap(
    CharacterMapsCompanion.insert(
      id: row?.id ?? const Uuid().v4(),
      projectId: projectId,
      nodes: d.nodes,
      edges: d.edges,
      groups: d.groups,
      viewport: d.viewport,
      createdAt: row?.createdAt ?? now,
      updatedAt: now,
    ),
  );
}

String newId() => const Uuid().v4();
