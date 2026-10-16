# SET-01 — Settings + AI permissions
Needs: UI-02, DB-01     Wave: 4

## Goal
Global settings (AI defaults, API key, theme) and each project's Settings tab with the 8 AI switches.

## Read
- docs/ARCHITECTURE.md
- plan/areas/12-backup-settings.md
- story-organizer-functional-spec.md (§14)

## May touch / must not touch
May: lib/features/settings/** · test/features/settings/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: a new project inherits the global defaults; toggling a project switch persists
3. Test: the API key saves to secure storage and is never shown in full
4. Widget test: theme toggle switches frame colours; paper colours unchanged

## Rules
None beyond the orchestrator brief.

## Evidence
- Decisions: `settings_providers.dart` holds `newProjectAiPermissions(db)` (stored `ai_permission_defaults` overlaid on DATA_MODEL 8.1 values; always 8 keys), global/project permission setters, `setTheme`, `maskKey`. `SettingsScreen(projectId)` = project switches + global defaults + light-theme switch + API key (masked "•••• last4", save/remove via key_store). Route `settings` (/project/:projectId/settings) already existed; `routes.dart` now passes projectId. No router change needed.
- Not wired (not my files): home_screen.dart `_create` still inserts `aiPermissions: const {}`; it must use `await newProjectAiPermissions(db)`. sample_project.dart copies raw stored defaults (empty if unset) - should use it too.
- Gotchas: Drift widget tests need taps outside `runAsync`, then `runAsync` delay, then pumps; end with unmount + pump(1s). Settings tab body changed, so test/core/shell goldens may need regenerating (see run below).
- Run: analyze, test, boundaries, Color(0x grep: see final report.
