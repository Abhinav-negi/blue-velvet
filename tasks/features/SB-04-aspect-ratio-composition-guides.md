# SB-04 — Aspect ratio + composition guides
Needs: SB-02, RES-07     Wave: 4

## Goal
The canvas fits the project/frame aspect ratio in portrait and landscape, with toggleable overlays from guides.json.

## Read
- docs/ARCHITECTURE.md
- assets/seed/aspect_ratios.json
- assets/seed/guides.json
- design.md (§8.5)

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: for 2.39:1 and 9:16 in portrait and landscape the drawable rect has the right ratio (±1 px)
3. Test: each guide in guides.json renders lines at its normalised coordinates
4. Screenshot: 2.39:1 with rule of thirds

## Rules
Add new files under canvas/; keep edits to the canvas widget minimal.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
