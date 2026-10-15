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
Decisions: Undo = SnackBar action ("Undo", 6 s) shown by ProposalScreen._approve; survives the pop to the inbox. Calls ProposalActions.undo -> engine.undoLastApprove; ProposalException text shown in a snackbar. History: `history` route /project/:projectId/history (list, newest first) -> `snapshot` route (read-only view: title, summary, beats, characters) with "Restore this version". Restore confirm dialog adds a linked-characters warning (shared sheets, every project) when any project_characters mode == linked. Entry point: History icon in ProposalScreen app bar. All in lib/features/proposals/history_screen.dart + providers.
Gotchas: SnackBar animates in; pump 500 ms before tapping Undo in tests. Restore adds 2 entries (Before restore + Restored: ...).
Commands: flutter analyze -> No issues; boundaries exit 0; Color(0x grep empty; flutter test -> 139 pass, 2 fail: test/core/shell/app_shell_test.dart 400/800 dp golden tests (shell goldens already modified in main working tree, not mine; orchestrator regenerates).
Not tested: linked-characters warning text (only the unlinked case asserted). No packages needed.
Section note: PROP-03: history route `history`/`snapshot` live in proposalsRoutes; no UI entry from project screens yet (only from the proposal review app bar) - add a link when the project hub is built.
