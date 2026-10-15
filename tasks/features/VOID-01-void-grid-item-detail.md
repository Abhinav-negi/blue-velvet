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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
