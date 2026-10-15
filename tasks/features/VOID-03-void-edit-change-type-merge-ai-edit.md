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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
