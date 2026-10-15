# VOID-03 — Void edit, change type, merge, AI edit
Needs: VOID-01, AI-03     Wave: 5

## Goal
Edit by hand, change type (re-applies structure), merge items, and ask the AI to edit, shown as a diff to approve.

## Read
- docs/ARCHITECTURE.md
- plan/areas/02-void.md
- docs/AI_CONTRACT.md (editItem)

## May touch / must not touch
May: lib/features/void/** · test/features/void/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: merging 2 items keeps both transcripts and produces one item
3. Widget test: an AI edit (fake) shows a DiffView and only applies on approve
4. Test: changing type re-runs organize structure for the new type (fake)

## Rules
Shares the void/ folder: not in parallel with VOID-02.

## Evidence
- Built: `void_actions.dart` (logic: proposeItemEdit, itemDiff, applyDraft, saveManual, mergeItems, `voidAiProvider`), `void_item_menu.dart` (app-bar menu: Edit / Edit with AI / Change type / Merge with...). Tests: `test/features/void/void_edit_test.dart` (fake AiClient subclass, no network).
- Decisions: Change type = `editItem` with a "change type to X" instruction, type forced to the chosen one, shown through the same DiffView approve dialog (AI output never silent). Merge is deterministic (no AI): first item survives; summaries joined with a space, transcripts with a blank line, spans shifted, tags/used-in unioned, list structure fields concatenated, other items deleted. Hand edit clears spans if the summary changed (S4 would be wrong).
- Merge entry: from the item screen, pick other items in a checklist (no multi-select on the grid).
- Used `editItem` directly, not `AiQueueRunner` (not wired into the app). Core need: an app-level `AiClient` provider and queue wiring; `voidAiProvider` in void_actions.dart is a local stand-in (readSecureGeminiKey) and should be replaced by the core provider.
- Golden: `detail.png` regenerated (new "..." app-bar menu); looked at it, fine. grid.png unchanged.
- Gotcha: the menu watches `voidItemsProvider` so the merge picker has data (reading a stream provider that nobody watches gives null).
- Commands: flutter analyze -> No issues found; flutter test -> 127 passed; check_boundaries.sh -> exit 0; Color(0x grep -> empty.
- Packages needed: none.
- Not done: no free-text tag editor (hand edit covers summary only; tags pass through).
- Section note: VOID-03: void item actions live in void_actions.dart/void_item_menu.dart; `voidAiProvider` is a stand-in until core exposes an AiClient provider.
