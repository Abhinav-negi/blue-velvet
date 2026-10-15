# EXP-03 — Storyboard PDF
Needs: SB-07     Wave: 8

## Goal
Export frames in a grid with shot details and notes, grouped by beat.

## Read
- docs/ARCHITECTURE.md
- plan/areas/11-export.md

## May touch / must not touch
May: lib/features/export/** · test/features/export/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: frames render from stroke data (not cached images) in beat order
3. Sample PDF of the sample project attached in Evidence

## Rules
export/ folder: one EXP task at a time.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
