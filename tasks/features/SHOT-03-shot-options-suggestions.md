# SHOT-03 — Shot options + suggestions
Needs: SHOT-01, AI-07     Wave: 5

## Goal
Ask 'what shots work for…' and get library entries plus fetched drafts; per-frame suggestions when permitted.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake AI): results show library entries and fetched drafts, clearly marked
3. Test: with Shot suggestions off, no request is made

## Rules
shots/ folder: not in parallel with SHOT-04.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
