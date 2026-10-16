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
- Decisions: `fountain.dart` toFountain(title, beatBlocks) is pure. Title page = `Title:`; scene heading not starting INT/EXT/EST/I/E gets forced `.`; non-"TO:" transition forced `>`; character/transition/heading uppercased; parenthetical wrapped in (); empty blocks skipped. Beat order = beats.position (same as script screen).
- Share seam: `shareFileProvider` (export_screen.dart) = (filename, content) -> writes temp file + SharePlus. Tests override it. EXP-02/04 reuse it and add tiles to ExportScreen. Route: /project/:projectId/export (name `export`); no entry point yet from other features (can't edit them).
- Gotcha: ExportScreen reads beats with a one-shot `db.select(db.beats)` not the DAO stream (stream `.first` hangs/pending timer in widget tests). Widget test unmounts tree before final pump.
- Ran: flutter analyze (no issues), flutter test (186 pass), check_boundaries (0), Color(0x grep (empty).
- Left: nothing.
