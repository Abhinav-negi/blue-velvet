# BEAT-02 — Beat reorder, split, merge
Needs: BEAT-01     Wave: 6

## Goal
Long-press drag to reorder within and across slots; split and merge beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: dragging a beat to another slot updates slot and order
3. Test: split produces two beats whose descriptions join to the original; merge reverses it
4. Widget test: with disableAnimations on, a reorder completes without animation

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
