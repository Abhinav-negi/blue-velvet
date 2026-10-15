# EXP-01 — Fountain export
Needs: SCR-01, RES-03     Wave: 7

## Goal
Export a project's screenplay as Fountain text.

## Read
- docs/ARCHITECTURE.md
- assets/seed/screenplay_format.json

## May touch / must not touch
May: lib/features/export/** · test/features/export/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Unit test: a fixture screenplay with every element type exports to the expected .fountain text exactly
3. Widget test: export opens the share sheet with a .fountain file

## Rules
export/ folder: one EXP task at a time.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
