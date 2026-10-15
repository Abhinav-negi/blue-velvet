# VOID-02 — Void filter + search
Needs: VOID-01     Wave: 5

## Goal
Filter by type, tag, date and used/unused; full-text search across summary and transcript.

## Read
- docs/ARCHITECTURE.md
- plan/areas/02-void.md

## May touch / must not touch
May: lib/features/void/** · test/features/void/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: each filter narrows results; filters combine
3. Widget test: search finds an item by a transcript-only word

## Rules
Shares the void/ folder: not in parallel with VOID-03.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
