# SB-07 — Canvas in frames
Needs: SB-01, SB-06     Wave: 7

## Goal
Open a frame full-screen in the canvas, save strokes to its file, and show thumbnails in the frame list.

## Read
- docs/ARCHITECTURE.md
- plan/areas/07-storyboard.md

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: drawing, closing and reopening a frame shows identical strokes
3. Widget test: the frame list thumbnail updates after drawing
4. On device: the spec §19 step 7 flow (2.39:1, rule of thirds, three frames) works; screenshots in Evidence

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time).

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
