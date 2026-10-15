# BEAT-04 — Template library screen
Needs: DB-02, UI-02     Wave: 4

## Goal
Browse built-in and saved templates, view slots, create and edit templates by hand.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md
- docs/DATA_MODEL.md (templates, slots)

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: built-in templates list from seed; opening one shows ordered slots with descriptions
3. Widget test: creating a template with 3 slots saves it; editing a built-in marks it user_edited

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
