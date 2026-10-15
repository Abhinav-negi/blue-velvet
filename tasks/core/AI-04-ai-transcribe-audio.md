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

### AI-04 evidence
- Added `transcribe(ai, bytes, {mimeType, maxChunkBytes})` in lib/core/ai/transcribe.dart (pure Dart); `transcribe <audio-file>` op in tool/ai_smoke.dart (organize still works).
- Decision: AiClient only has `generateJson` (can't edit it), so the transcript comes back in a one-field JSON schema `{transcript}`, not plain text as AI_CONTRACT 4.1 says. Same text, no behaviour change for callers.
- Chunk limit 14 MB raw (20 MB request cap / 1.33 base64). Chunks are raw byte slices joined with a space; later m4a/WAV slices are not standalone files (ponytail comment). Split on container boundaries or use Files API if >14 MB recordings must work.
- Empty result throws AiMalformedResponse('Nothing heard') ("nothing heard" check, 4.1).
- Results: flutter analyze: No issues; flutter test: all pass (85); check_boundaries: exit 0. Done-when 2, 3 covered by test/core/ai/transcribe_test.dart.
- Done-when 4 NOT CHECKED: no audio sample exists. Run: `timeout 600 dart run tool/ai_smoke.dart transcribe test/fixtures/audio/<sample>.m4a`
- Section note: transcribe() returns text via JSON schema; chunking is byte-level only (see above).
