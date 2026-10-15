# SB-02 — Canvas core
Needs: SPK-01, CON-01, UI-01     Wave: 3

## Goal
The drawing engine: pointer capture, pressure-sensitive strokes via perfect_freehand, pen and eraser, colours and sizes, undo/redo, and saving/loading strokes in the DATA_MODEL format.

## Read
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md (stroke format)
- docs/spikes/SPK-01-spen.md
- design.md (§8.5)

## May touch / must not touch
May: lib/features/storyboard/canvas/** · test/features/storyboard/canvas/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: strokes → JSON → strokes round trip is lossless (points, pressure, tool, layer)
3. Test: undo/redo across 50 strokes restores exact state
4. Test: eraser removes intersected strokes only
5. On device: a 10-second S Pen scribble renders with visible pressure variation (screenshot in Evidence)

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time). Expose the canvas as one widget with input, overlay and tool hooks so SB-03/04/05 add files rather than rewrite it.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
