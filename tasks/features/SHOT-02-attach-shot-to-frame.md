# SHOT-02 — Attach shot to frame
Needs: SHOT-01, SB-07     Wave: 8

## Goal
From a frame, search and attach a shot entry; its reference images show beside the drawing.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: attaching "Low angle" to a frame stores it and shows its images beside the canvas
3. Widget test: the frame caption shows the attached shot name

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
