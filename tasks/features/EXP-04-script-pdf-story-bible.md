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
- Decisions: `script_pdf.dart` = pure `ScriptModel` (say_show rows, empty rows/fields dropped) + `scriptPdf` (two-column Say | Show table, Letter, 54 pt margins). `bible_pdf.dart` = pure `BibleModel` (title, summary, per-character name + non-empty fields) + `BibleModel.load(db, projectId)` + `biblePdf`. Sheet resolution: member's own non-null value overrides the library character (`m.x ?? c.x`); linked rows have no own values so they read the library row, forked rows override. Members ordered by created_at. ExportScreen shows all four tiles with format-hinting labels (Screenplay PDF = films, Script PDF = YouTube/Shorts, Story bible); no per-type hiding (avoids async gating that broke the older widget tests).
- Fonts: Literata-VF (body) + Inter-VF (captions) work in the pdf package: it embeds the default (Regular) instance (pdffonts: Literata-Regular, Inter-Regular, embedded). No bold/italic; headings differ by size only.
- Gotchas: sample project is a short_film, so the script PDF uses a 12-row Say/Show fixture; bible PDF uses the sample project's title/summary/characters. Sample PDFs are not committed.
- Sample PDFs (not committed): /home/abhinav/Projects/lynch-wt/EXP-04/build/exp04_script.pdf = 3 pages; build/exp04_bible.pdf = 1 page (written by test/features/export/script_bible_test.dart).
- Done-when 3: test 'bible includes every non-empty field...' checks every filled field (linked + forked override case) in the model; empty fields are absent.
- Ran: flutter analyze (no issues), flutter test (all pass), check_boundaries (0), Color(0x grep (empty).
- Left: nothing; no page-break keep-together for character blocks, no beat headings in script (ponytail).
