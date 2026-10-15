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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
