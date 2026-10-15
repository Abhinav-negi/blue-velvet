# EXP-04 — Script PDF + story bible
Needs: SCR-02, CHR-01     Wave: 7

## Goal
Export a Say/Show script PDF and a story bible PDF (summary + character sheets), shared via the share sheet.

## Read
- docs/ARCHITECTURE.md
- plan/areas/11-export.md

## May touch / must not touch
May: lib/features/export/** · test/features/export/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Sample PDFs of both attached in Evidence
3. Test: the story bible includes every character's filled fields

## Rules
export/ folder: one EXP task at a time.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
