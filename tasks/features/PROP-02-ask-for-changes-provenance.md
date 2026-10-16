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
- Decisions: `ProposalActions.revise(id, instruction, ai)` builds PROJECT_CONTEXT (project, beats, characters; `template: null`, so revisions cannot re-place beats into slots - ponytail), calls core `reviseProposal`, then overwrites only the proposal row (summary, summary_spans, changes). Real guard: throws ProposalException unless status is pending. AI never touches project data (test asserts 0 beats). Screen: "Ask for changes" button (dialog), summary split with `splitSentences` into tappable `sentence-N` InkWells; tap shows transcript with only that sentence's spans lit; "Show what I said" still lights all.
- Gotchas: after a revision the changeLines future lags one frame behind the proposal stream, so build returns an empty Scaffold while lengths differ (else RangeError). `_accepted` reset to null after revise. Dialog TextEditingController is not disposed (exit animation reads it; "used after dispose" otherwise). Seed test project now has `beat_generation: true` and a 2-sentence summary. Test uses `AiClient(client: MockClient)` via `aiClientProvider` override.
- Not done: AiException messages shown as snackbar only; no test for the error path; template slots not sent to the AI.
- Commands: flutter analyze, flutter test, tool/check_boundaries.sh, Color(0x grep - see final report.
