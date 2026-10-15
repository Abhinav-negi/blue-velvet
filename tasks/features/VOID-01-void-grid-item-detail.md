# VOID-01 — Void grid + item detail
Needs: UI-02, DB-01, UI-03     Wave: 4

## Goal
The Infinite Void: masonry grid newest first, type icon + Literata text, item detail with type structure, raw transcript and tap-a-sentence highlight (S4).

## Read
- docs/ARCHITECTURE.md
- design.md (§8.7)
- plan/areas/02-void.md
- docs/DATA_MODEL.md (void_items)

## May touch / must not touch
May: lib/features/void/** · test/features/void/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: items render newest first with type icons
3. Widget test: tapping a summary sentence highlights its transcript span
4. Screenshot of grid and detail in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
- Decisions: masonry = two Columns, each card to the shorter column by summary length (proxy, not measured). Route `void-item` = /void/:id (child of `void`). Detail splits summary with the AI_CONTRACT 2.1 splitter; tapping sentence i lights spans with sentence_index i via shared TranscriptHighlight (sentence turns teal). Structure view is generic (dialogue lines, lyric sections, else non-empty fields). Own Drift providers in lib/features/void/void_providers.dart.
- Gotchas: drift streams in testWidgets need `t.runAsync` for seeding/waiting and an unmount + pump(Duration.zero) at test end (else pending-timer failure/hang). Detail golden's back arrow shows a box (MaterialIcons font not loaded in tests); test artefact only.
- Results: flutter analyze: No issues; flutter test: all 36 pass; check_boundaries exit 0; Color(0x grep: empty.
- Screenshots: test/features/void/goldens/grid.png, detail.png (viewed, correct).
- Left: filters/search, long-press move, edit, type change (other tasks).
