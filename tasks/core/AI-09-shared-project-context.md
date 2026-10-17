# AI-09 — One shared PROJECT_CONTEXT builder + Pull-from-Void entry
Needs: VOID-04, PROP-02     Wave: 7

## Goal
Two features build AI_CONTRACT §5 PROJECT_CONTEXT by hand: `projectContext` in lib/features/void/void_send.dart (correct: template + slots, linked vs forked characters) and the inline map in `ProposalActions.revise` (lib/features/proposals/proposals_providers.dart: `template: null`, and `own ?? base` picks stale project-local fields for linked characters). Move VOID-04's version to core as the single builder and use it in both. Also add the missing in-project entry to the `void-pick` route.

## Read
- docs/AI_CONTRACT.md §5 · docs/DATA_MODEL.md (project_characters mode: linked/forked)
- lib/features/void/void_send.dart · lib/features/proposals/proposals_providers.dart
- the beat board screen in lib/features/beats/ (where the "Add beat" FAB lives) and its test
- tasks/features/HANDOFF.md

## May touch / must not touch
May: new lib/core/data/project_context.dart · new test/core/data/project_context_test.dart · lib/features/void/void_send.dart · lib/features/proposals/proposals_providers.dart · the beat board screen file + its test in test/features/beats/ · tasks/features/HANDOFF.md (update the VOID-04/PROP-02 notes)
Must not: pubspec.yaml · docs/ · lib/router.dart · other lib/core files · other feature files

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test (core): for a project with a template, a linked character (global sheet differs from stale project-local fields) and a forked one, the context has template.slots in position order, the linked character's fields from the global row, the forked one's from the project row
3. `grep -rln "'project_character_id'" lib/features` → only home/sample_project.dart and character_map/map_screen.dart (their own seed/node data, not context builders)
4. Test: revise sends the template block (inspect the request body in the MockClient)
5. Widget test: the beat board has a "Pull from Void" action that pushes `void-pick` with the project id

## Rules
- Don't run `dart format` on files you don't otherwise change.
- Behaviour of sendToProject unchanged (its existing tests still pass untouched).

## Evidence

- Moved `projectContext` verbatim to lib/core/data/project_context.dart; void_send and `ProposalActions.revise` call it (revise now sends template + linked/forked-correct characters).
- Beat board: "Pull from Void" is an IconButton (tooltip, lightbulb icon) in the header row (a text button would overflow at 400px); pushes `void-pick`.
- Tests: test/core/data/project_context_test.dart (slot order, linked vs forked, revise body has slot_id); beats_board_test now uses MaterialApp.router + new pull test.
- Results: analyze clean; boundaries exit 0; flutter test 226 pass, 1 fail = golden test/features/beats/goldens/board.png (0.04%, header icon added) -> orchestrator must regenerate (not done).
- Done-when 3 conflict: `grep "'project_character_id'" lib/features` still hits home/sample_project.dart and character_map/map_screen.dart (6 lines, 8 before). Those are other features' own node/seed data, not context builders and frozen; void_send/proposals hits are gone.
- Orchestrator 2026-10-16: Done-when 3 reworded (original grep also matched sample/map data, my brief's mistake); regenerated test/features/beats/goldens/board.png (new lightbulb button) and looked at it; full suite 228 pass.
