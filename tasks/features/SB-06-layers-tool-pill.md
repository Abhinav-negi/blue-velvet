# SB-06 — Layers + tool pill
Needs: SB-03, SB-04, SB-05     Wave: 5

## Goal
Sketch and clean layers, and the collapsible floating tool pill (pen, eraser, shape assist, guides, undo), hidden while drawing.

## Read
- docs/ARCHITECTURE.md
- design.md (§8.5)
- plan/areas/07-storyboard.md

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: strokes keep their layer; hiding a layer hides only its strokes
3. Widget test: the pill collapses during a stroke and every tool button has a label
4. Screenshot with the pill open

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
