# SB-03 — Canvas input modes
Needs: SB-02     Wave: 4

## Goal
Stylus vs finger modes, palm rejection, S Pen side button = eraser (per SPK-01), zoom and pan.

## Read
- docs/ARCHITECTURE.md
- docs/spikes/SPK-01-spen.md
- plan/areas/07-storyboard.md

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: in stylus mode, touch events pan and never draw; in finger mode, touch draws
3. Test: pointer events with the side-button bit set erase
4. On device: palm resting while drawing leaves no marks (screenshot or note in Evidence)

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time). Add new files under canvas/; keep edits to the canvas widget minimal.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
