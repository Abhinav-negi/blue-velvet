# SCR-04 — Script ↔ board swipe
Needs: SCR-01, SB-01     Wave: 7

## Goal
Beat detail pager: script on the left, storyboard on the right, two-dot indicator.

## Read
- docs/ARCHITECTURE.md
- design.md (§7.2)
- plan/areas/06-script.md

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: swiping right shows the beat's frames; the indicator updates
3. Widget test: the pager shows Say/Show for YouTube projects

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)

### SCR-04 evidence
- Decisions: new `lib/features/script/beat_pager.dart` (PageView: script page + board page, two dots keyed `dot-N[-active]`). Wraps the editor in script_screen.dart; ScaffoldSuggestions stays below the pager. Frames read via `db.beatsDao.watchFrames` (no storyboard import); the board page shows simple numbered tiles (shot caption + notes), no stroke thumbnails (those need the files dir provider from storyboard). "Open board" button pushes route name `board`.
- Gotcha: pager adds a dot row, so `test/features/script/goldens/scene.png` was regenerated (script folder, mine). No shell goldens failed.
- Commands: flutter analyze clean; flutter test all pass (197); check_boundaries exit 0; Color(0x grep empty.
- Left: real stroke thumbnails on the board page (needs shared thumbnail widget in core).
