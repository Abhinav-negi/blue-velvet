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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
