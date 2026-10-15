# EXP-02 — Screenplay PDF
Needs: SCR-01, RES-03     Wave: 7

## Goal
Export the screenplay as an industry-format PDF.

## Read
- docs/ARCHITECTURE.md
- assets/seed/screenplay_format.json

## May touch / must not touch
May: lib/features/export/** · test/features/export/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: the PDF uses Courier Prime 12 pt and the margins from screenplay_format.json (checked on the layout model)
3. Sample PDF of the sample project attached in Evidence

## Rules
export/ folder: one EXP task at a time.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
