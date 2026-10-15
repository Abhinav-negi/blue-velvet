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
- Code: lib/features/storyboard/{frames_providers,frame_editor,storyboard_screen,routes}.dart; test/features/storyboard/frames_test.dart. Board tab = "Board" heading + beat chips + FramesList (ReorderableListView; add/duplicate/delete/edit sheet with size, angle, movement, lens, duration in seconds, notes, script-block dropdown, character chips). Caption = "size · angle · movement · lens · 2.5s". No canvas; thumbnail shown if thumbnail_path exists, else numbered blank.
- Decision: delete removes the frame row only; the stroke file is KEPT (DATA_MODEL 13.1 + caller's hard rule). Done-when #2 says "delete removes both": conflicts; test asserts row gone and file kept. Duplicate copies the stroke file to strokes/<newId>.json (relative to app documents dir, `filesDirProvider` here, override in tests).
- Gotcha: widget tests mixing real file IO and fake async need alternating runAsync delay + pump (see `work` helper in test).
- Shell goldens (test/core/shell) fail in this worktree: expected, regenerated goldens are uncommitted on master.
- Packages needed: none new (path, path_provider already present).
- Section note: Board route now passes projectId to BoardScreen; frames ops (addFrame/duplicateFrame/deleteFrame/moveFrame/saveFrameDetails) are in frames_providers.dart for SB-02..07. strokes_path is relative to app documents dir; a canvas should write to strokes/<frameId>.json.
