# PROP-03 — History + undo
Needs: PROP-01     Wave: 6

## Goal
Snapshot list, view the project as it was, restore, and an Undo bar after approve (S3).

## Read
- docs/ARCHITECTURE.md
- plan/areas/04-proposals.md

## May touch / must not touch
May: lib/features/proposals/** · test/features/proposals/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: after approve an Undo bar shows; Undo restores the previous state
3. Widget test: restoring a snapshot adds a new history entry

## Rules
Not in parallel with PROP-02.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
