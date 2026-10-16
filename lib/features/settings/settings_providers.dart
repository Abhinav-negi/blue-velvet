export 'package:lynch/core/data/ai_defaults.dart';

import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/ai_defaults.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

final globalAiDefaultsProvider = StreamProvider<Map<String, bool>>(
  (ref) => ref
      .watch(dbProvider)
      .settingsDao
      .watch(aiDefaultsKey)
      .map(parseAiDefaults),
);

Future<void> setGlobalAiDefault(
  AppDatabase db,
  AiPermission p,
  bool value,
) async {
  final next = {...await newProjectAiPermissions(db), p.key: value};
  await db.settingsDao.put(
    aiDefaultsKey,
    jsonEncode(next),
    DateTime.now().millisecondsSinceEpoch,
  );
}

final projectAiPermissionsProvider =
    StreamProvider.family<Map<String, dynamic>, String>(
      (ref, id) => ref
          .watch(dbProvider)
          .projectsDao
          .watchAll()
          .map(
            (all) =>
                all.where((p) => p.id == id).firstOrNull?.aiPermissions ??
                const {},
          ),
    );

Future<void> setProjectAiPermission(
  AppDatabase db,
  String projectId,
  AiPermission p,
  bool value,
) async {
  final row = await db.projectsDao.byId(projectId);
  if (row == null) return;
  await db.projectsDao.upsert(
    row
        .toCompanion(true)
        .copyWith(
          aiPermissions: Value({...row.aiPermissions, p.key: value}),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
  );
}

Future<void> setTheme(AppDatabase db, bool light) => db.settingsDao.put(
  'theme',
  light ? 'light' : 'dark',
  DateTime.now().millisecondsSinceEpoch,
);

/// "•••• 1234": never the whole key.
String maskKey(String key) =>
    key.length <= 4 ? '••••' : '•••• ${key.substring(key.length - 4)}';
