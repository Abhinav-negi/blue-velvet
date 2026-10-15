# SB-01 — Frames per beat
Needs: BEAT-01     Wave: 6

## Goal
List of frames for a beat (add, reorder, duplicate, delete) with shot details, notes, characters, screenplay-block link and caption.

## Read
- docs/ARCHITECTURE.md
- plan/areas/07-storyboard.md
- docs/DATA_MODEL.md (frames)

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: duplicate copies details and stroke file; delete removes both
3. Widget test: shot details (size, angle, movement, lens, duration) save and show in the caption

## Rules
Keep out of lib/features/storyboard/canvas/.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
