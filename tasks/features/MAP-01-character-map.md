# MAP-01 — Character map
Needs: CHR-01, RES-06     Wave: 6

## Goal
Per-project map: character nodes, labelled links with quick-pick labels, free drag, groups and colours, zoom/pan, tap to open the sheet.

## Read
- docs/ARCHITECTURE.md
- plan/areas/09-character-map.md
- design.md (§8.6)
- assets/seed/relationship_labels.json

## May touch / must not touch
May: lib/features/character_map/** · test/features/character_map/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: node positions and edges persist across reload
3. Widget test: label quick-picks come from the seed; free text also works
4. Widget test: tapping a node opens the character sheet
5. Screenshot in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
