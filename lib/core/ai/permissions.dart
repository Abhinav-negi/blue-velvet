/// The 8 AI switches (DATA_MODEL 8.1 / AI_CONTRACT 7). [key] is the JSON key
/// in `projects.ai_permissions` and `settings.ai_permission_defaults`.
enum AiPermission {
  autoSummary('auto_summary'),
  characterExtraction('character_extraction'),
  beatGeneration('beat_generation'),
  autoPlacement('auto_placement'),
  screenplayScaffold('screenplay_scaffold'),
  grammarCleanup('grammar_cleanup'),
  shotSuggestions('shot_suggestions'),
  internetFetch('internet_fetch');

  const AiPermission(this.key);
  final String key;
}

/// True only when the switch is explicitly `true`; a missing key is false.
bool aiAllowed(Map<String, dynamic> permissions, AiPermission p) =>
    permissions[p.key] == true;
