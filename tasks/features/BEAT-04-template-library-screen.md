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
- Files: lib/features/beats/{template_library_screen,template_detail_screen,template_edit_screen,template_providers}.dart; route `templates` = /project/:projectId/beats/templates (child of `beats` in routes.dart); test/features/beats/template_library_test.dart.
- Decisions: no templates DAO exists and lib/core is frozen, so providers query db.templates/db.slots directly. Detail/edit open via Navigator.push (one route only). Saving a built-in sets template.user_edited; slots are updated by id and only changed ones get user_edited; removed slots deleted; new slots builtin=false. Delete only for non-builtin. Reorder via up/down buttons.
- Gotchas: shell highlights Overview tab on the templates route (router matches section by top route name; router.dart frozen). Tests: ListView is lazy so use a tall view; seed with SeedLoader(read: File) inside runAsync (rootBundle not used).
- Results: analyze clean, flutter test 83 pass, check_boundaries exit 0, token grep empty.
- Left: nothing for this task. Nothing links to the `templates` route yet (BEAT-01 board should).
