# BEAT-01 — Beat board
Needs: PROJ-01, DB-02     Wave: 5

## Goal
Beat cards on the board grouped by template slot (or a plain list with no template); add and edit beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md
- design.md (§8.3)

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: beats appear under their slots; empty slots show no warning
3. Widget test: no-template mode shows an ordered list
4. Screenshot of the board in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
