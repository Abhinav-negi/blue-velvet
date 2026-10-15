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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
