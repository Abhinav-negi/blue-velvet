# PROJ-04 — Sample project (S5)
Needs: DB-02, DB-03     Wave: 4

## Goal
Ship the spec §19 playground/watchman story as a fully built sample project, loaded once on first launch and deletable.

## Read
- docs/ARCHITECTURE.md
- story-organizer-functional-spec.md (§19)
- docs/DATA_MODEL.md
- docs/SEED_SCHEMA.md

## May touch / must not touch
May: lib/features/home/** · test/features/home/** · assets/seed/sample_project.json
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. assets/seed/sample_project.json exists with summary, 2 characters, ≥ 3 beats in a 5-point template, scaffolds, ≥ 1 frame with strokes, and a character-map edge "afraid of"
3. Test: first launch loads it once; a second launch does not duplicate it; deleting it keeps it deleted
4. Test: its content passes DB-03's snapshot round trip

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
