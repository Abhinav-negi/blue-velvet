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
- Built: `lib/features/character_map/{map_providers,map_screen,routes}.dart`; route `character-map` = `/project/:projectId/map` (top-level via existing `characterMapRoutes`). No packages added.
- Every edit (add/drag/link/group/remove/pan-zoom) goes through `editMap` -> `charactersDao.mapFor/upsertMap` at once; drag position is widget-local only until pan end. Members read via db DAOs (not features/characters). Tap node -> `pushNamed('character-sheet', {projectId, memberId})`. Long-press node -> sheet: link to X (label dialog: seed quick-picks + free text), group (new/assign/clear), remove. Tap an edge label to edit/delete.
- Quick-pick labels = names in assets/seed/relationship_labels.json (60, via rootBundle). Group colours: sage/ember/amber/slate -> AppColors tokens.
- Gotchas: in tests warm the seed asset with `rootBundle.loadString` in `setUpAll` (loading inside the test hung the second test); Lucide font loaded like other goldens. Touch slop eats ~17px of the first drag move, so test asserts greaterThan, not exact.
- Commands: flutter analyze -> No issues; flutter test -> 153 pass, 2 fail (shell goldens, expected); check_boundaries exit 0; Color(0x grep empty.
- Screenshot: test/features/character_map/goldens/map.png (checked: glyphs render, group ring, labelled link).
- Left: nothing in scope. No entry point to /project/:id/map exists (router.dart and characters are frozen) — someone must link it, e.g. a button on the Characters screen: `context.pushNamed('character-map', pathParameters: {'projectId': id})`.
- Section note: MAP-01 route `character-map` is unlinked; add an entry point (Characters screen app bar). Edge label tap and node long-press are the only edit gestures.
