import 'dart:convert';

import 'package:lynch/core/ai/permissions.dart';

import 'db.dart';

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

/// Settings key holding the global defaults (DATA_MODEL §7).
const aiDefaultsKey = 'ai_permission_defaults';

/// All 8 keys: stored value when it is a bool, else the contract default.
Map<String, bool> parseAiDefaults(String? raw) {
  final stored = raw == null ? const {} : jsonDecode(raw) as Map;
  return {
    for (final p in AiPermission.values)
      p.key: stored[p.key] is bool
          ? stored[p.key] as bool
          : contractAiDefaults[p.key]!,
  };
}

/// The `ai_permissions` a NEW project must start with: the global defaults,
/// all 8 keys. Every project-creation path must call this.
Future<Map<String, dynamic>> newProjectAiPermissions(AppDatabase db) async =>
    parseAiDefaults(await db.settingsDao.get(aiDefaultsKey));
