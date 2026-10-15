# SET-02 — Backup UI
Needs: DB-04, SET-01     Wave: 5

## Goal
Sign in with Google, back up now, automatic backup after changes when online, and restore.

## Read
- docs/ARCHITECTURE.md
- plan/areas/12-backup-settings.md
- docs/SETUP_GOOGLE.md

## May touch / must not touch
May: lib/features/settings/** · test/features/settings/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake service): Back up now shows progress, then a last-backup time
3. Test: automatic backup is debounced (no more than once per 10 minutes)
4. Widget test: Restore asks for confirmation before replacing data

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
