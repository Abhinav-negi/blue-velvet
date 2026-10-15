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
- Routes: `shots` (/shots) and `shot` (/shots/:id) in lib/features/shots/routes.dart. Nothing links to /shots yet (Home is another folder): orchestrator/Home must add an entry using goNamed('shots').
- No Shots DAO exists in core, so providers query `db.shots` / `db.shotImages` directly. Filter + search (name, description, tags) run in memory.
- Files folder: `filesDirProvider` (default getApplicationDocumentsDirectory); picker: `imagePickerProvider`. Both overridable. `addUserImage` copies to shot_images/<uuid>.<ext>, inserts kind=userFile row (path relative).
- Sketches: treated as images from the gallery; no drawing canvas here (storyboard's job).
- Riverpod 3: StateProvider needs `flutter_riverpod/legacy.dart`.
- Not done (out of scope for this task's Done-when): attach to frame, ask-for-options, fetch.
- Results: flutter analyze clean; flutter test 84 pass; check_boundaries exit 0; token guard empty.
