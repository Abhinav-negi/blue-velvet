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
- Decisions: `pdf_layout.dart` = pure model (ScreenplayLayout.fromJson of screenplay_format.json: Letter 8.5x11, margins 1/1/1.5/1, 12 pt font, 12 pt line = 6 lpi, per-element indents/spacing/alignment, 10 cpi word wrap, blank-line merge = max(prev after, next before)). `screenplay_pdf.dart` only consumes it: MultiPage, one 12 pt-high widget per wrapped line (pdf's Text line height follows font metrics = 13.5 pt, so per-line SizedBox gives exactly 27 lines per 9 in of body after header; page number top right 0.5 in down from page 2, "N.").
- Font: Courier Prime Regular only, loaded via rootBundle (app) / File (tests). No bold/italic file exists, so scene headings are regular weight (uppercase only, no bold/underline).
- Share: added `shareBytesProvider` (filename, Uint8List) next to `shareFileProvider` (left unchanged); ExportScreen tile "Screenplay PDF (.pdf)"; load logic shared with Fountain via `_load`.
- Gotchas: pdf output uses `/Type/Page/` (no space) for page counting; pw.Text `height`/`lineSpacing` do not change single-line height. Not done: (MORE)/(CONT'D), title page, parenthetical hanging indent, scene numbers, keep-heading-with-next (ponytail note in screenplay_pdf.dart).
- Sample PDF (not committed): /home/abhinav/Projects/lynch-wt/EXP-02/build/exp02_sample.pdf, 1 page (sample project has only a few short blocks), written by test/features/export/sample_pdf_tool_test.dart (also writes build/exp02_long.pdf, 5 pages, to check 27 lines/page).
- Ran: flutter analyze (no issues), flutter test (all pass), check_boundaries (0), Color(0x grep (empty).
- Left: items under Not done.
