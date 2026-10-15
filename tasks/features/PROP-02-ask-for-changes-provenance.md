# PROP-02 — Ask for changes + provenance
Needs: PROP-01, AI-05     Wave: 6

## Goal
Ask for changes on a proposal, "Show what I said", and tap a sentence to highlight its transcript source (S4).

## Read
- docs/ARCHITECTURE.md
- plan/areas/04-proposals.md

## May touch / must not touch
May: lib/features/proposals/** · test/features/proposals/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake AI): Ask for changes replaces the proposal ops with the revised ones
3. Widget test: tapping a proposed sentence highlights its transcript span

## Rules
Not in parallel with PROP-03.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
