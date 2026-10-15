# PROJ-03 — Project overview
Needs: PROJ-01, DB-03     Wave: 5

## Goal
Overview tab: summary (README), pending proposals, recent history, and type-specific fields for YouTube and Shorts.

## Read
- docs/ARCHITECTURE.md
- plan/areas/03-home-projects.md
- design.md (§7.1)

## May touch / must not touch
May: lib/features/home/** · test/features/home/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: overview shows summary, pending count and the last 5 snapshots
3. Widget test: a YouTube project shows title ideas, thumbnail ideas; a Short shows hook text and caption

## Rules
None beyond the orchestrator brief.

## Evidence
- Overview reads project/pending/last-5 snapshots straight from db tables (autoDispose-free StreamProvider.family keyed by route `projectId`). Pending row pushes route 'proposals'. Type fields keys per DATA_MODEL 8.2: title_ideas, thumbnail_ideas (youtube); hook_text, caption, on_screen_text (short). Display only; editing not in Done-when.
- Added a literal 'Overview' heading because test/core/shell/app_shell_test.dart expects the tab label text twice.
- Tests: test/features/home/overview_test.dart (3 tests, pass). analyze clean; boundaries exit 0; Color(0x grep empty.
- FAIL (outside my paths): test/core/shell/app_shell_test.dart '400 dp' and '800 dp' golden tests fail (shell_phone_400.png, shell_tablet_800.png) because the placeholder Overview body is replaced. Fix: `flutter test test/core/shell --update-goldens` by someone allowed to touch test/core. No packages needed.
- Section note: Overview screen replaced the placeholder, so shell goldens need regenerating (see above); type_fields keys are DATA_MODEL 8.2.
