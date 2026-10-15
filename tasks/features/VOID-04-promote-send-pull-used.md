# VOID-04 — Promote, send, pull, used
Needs: VOID-01, PROJ-02, PROP-01     Wave: 6

## Goal
Promote a story idea to a pre-project, send an item to a project as a proposal, pull an item in from inside a project, mark items used.

## Read
- docs/ARCHITECTURE.md
- plan/areas/02-void.md

## May touch / must not touch
May: lib/features/void/** · test/features/void/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: Send to project creates a pending proposal and marks the item used
3. Widget test: Promote opens the pre-project review
4. Test: a used item stays in the Void and can be reused

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
