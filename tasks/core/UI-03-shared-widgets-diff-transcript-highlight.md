# UI-03 — Shared widgets: diff + transcript highlight
Needs: UI-01, CON-03     Wave: 3

## Goal
Reusable widgets the Void and Proposals both need: DiffView (added/removed/changed), SuggestedText (italic + amber rule), TranscriptHighlight (lights up spans).

## Read
- docs/ARCHITECTURE.md
- design.md (§6.1, §8.2)
- docs/AI_CONTRACT.md (span format)

## May touch / must not touch
May: lib/core/widgets/** (except app_shell*) · test/core/widgets/**
Must not: lib/features/ · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget tests: DiffView renders added, removed and changed lines with an icon or word, not colour alone
3. Widget test: TranscriptHighlight with the AI_CONTRACT example spans highlights exactly the expected substrings
4. Screenshot of a demo of all three on dark frame and paper in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
- Files: lib/core/widgets/{diff_view,suggested_text,transcript_highlight}.dart; test/core/widgets/shared_widgets_test.dart.
- Decisions: DiffView takes `List<DiffLine>` (added/removed/changed) + `onPaper` (removed = red pencil on paper, ember on frame). Each row has a plus/minus icon and a Semantics label "Added"/"Removed"; removed is also struck through. TranscriptHighlight takes `HighlightRange(start,end)` (UTF-16, end exclusive, per AI_CONTRACT 2), merges overlaps, ignores bad spans; lit = teal (secondary) fill, not amber. SuggestedText = AppType.proposal + 4 dp amber rule (DiffColors.proposalRule). Faint-fill opacity constants (0.12, 0.3) are private literals in the widgets.
- Gotchas: Semantics label merges with child text, so tests match the Semantics widget, not bySemanticsLabel. Goldens need fonts loaded by hand (as test/core/shell).
- Results: flutter analyze clean; flutter test all pass; check_boundaries exit 0; no Color(0x outside theme.
- Screenshots: test/core/widgets/goldens/widgets_dark.png, test/core/widgets/goldens/widgets_paper.png
- Left: nothing.
