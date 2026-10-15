# SCR-01 — Screenplay editor
Needs: BEAT-01, RES-03     Wave: 6

## Goal
Block-based screenplay editor on paper in Courier Prime: elements, Enter/Tab switching, element chip, no toolbar while writing.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md
- design.md (§8.4)
- assets/seed/screenplay_format.json

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: Enter/Tab transitions follow the element order in plan/areas/06-script.md
3. Widget test: tapping the chip changes the element type
4. Screenshot of a scene in Evidence

## Rules
script/ folder: not in parallel with SCR-02.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
