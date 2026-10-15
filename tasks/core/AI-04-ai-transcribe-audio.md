# AI-04 — AI: transcribe audio
Needs: AI-01, SPK-03     Wave: 4

## Goal
Send recorded audio to Gemini and get an accurate en-IN transcript, within the limits SPK-03 measured.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (transcribe)
- docs/spikes/SPK-03-gemini.md

## May touch / must not touch
May: lib/core/ai/transcribe.dart · test/core/ai/transcribe* · test/fixtures/audio/**
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test (MockClient): request carries the audio mime type and base64 body; response parses to text
3. Test: audio larger than the measured inline limit is split into chunks and the transcripts joined in order
4. Live smoke on a sample recording: transcript in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
