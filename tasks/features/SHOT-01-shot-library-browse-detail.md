# SHOT-01 — Shot library browse + detail
Needs: DB-02, UI-02     Wave: 4

## Goal
Browse by category, search, view entries with reference images and licenses, and add your own images or sketches.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md
- docs/DATA_MODEL.md (shots, shot_images)

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: category filter and search narrow the list
3. Widget test: detail shows image credit (author + license) for built-in images
4. Test: adding an image from a file stores it in the files folder and links it

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
