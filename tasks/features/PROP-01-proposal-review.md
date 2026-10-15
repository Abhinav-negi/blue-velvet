# PROP-01 — Proposal review
Needs: UI-03, DB-03, PROJ-01     Wave: 5

## Goal
Proposal stack (oldest first), review screen with DiffView, per-change accept, Approve all, Reject (discard or to Void), Defer, edit text.

## Read
- docs/ARCHITECTURE.md
- plan/areas/04-proposals.md
- design.md (§8.2)

## May touch / must not touch
May: lib/features/proposals/** · test/features/proposals/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: accepting 2 of 3 changes applies only those (via DB-03)
3. Widget test: Reject → to Void creates a void item with the transcript
4. Widget test: Defer leaves the proposal pending; approve fires a medium haptic

## Rules
proposals/ folder: PROP-02 and PROP-03 run after this one, not alongside each other.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
