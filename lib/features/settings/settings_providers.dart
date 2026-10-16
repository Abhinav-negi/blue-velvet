import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// DATA_MODEL 8.1 example values, used while `ai_permission_defaults` is unset.
const contractAiDefaults = <String, bool>{
  'auto_summary': true,
  'character_extraction': true,
  'beat_generation': true,
  'auto_placement': true,
  'screenplay_scaffold': true,
  'grammar_cleanup': true,
  'shot_suggestions': false,
  'internet_fetch': false,
};

const _defaultsKey = 'ai_permission_defaults';

Map<String, bool> _parseDefaults(String? raw) {
  final stored = raw == null ? const {} : jsonDecode(raw) as Map;
  return {
    for (final p in AiPermission.values)
      p.key: stored[p.key] is bool
          ? stored[p.key] as bool
          : contractAiDefaults[p.key]!,
  };
}

/// The `ai_permissions` a NEW project must start with: the global defaults,
/// all 8 keys. Project creation (home / PROJ-02) must call this.
Future<Map<String, dynamic>> newProjectAiPermissions(AppDatabase db) async =>
    _parseDefaults(await db.settingsDao.get(_defaultsKey));

final globalAiDefaultsProvider = StreamProvider<Map<String, bool>>(
  (ref) =>
      ref.watch(dbProvider).settingsDao.watch(_defaultsKey).map(_parseDefaults),
);

Future<void> setGlobalAiDefault(
  AppDatabase db,
  AiPermission p,
  bool value,
) async {
  final next = {...await newProjectAiPermissions(db), p.key: value};
  await db.settingsDao.put(
    _defaultsKey,
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
