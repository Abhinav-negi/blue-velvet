# SPK-03 — Spike: Gemini free tier
Needs: -     Wave: 1

## Goal
Verify the Gemini free tier does what the plan assumes: audio transcription, structured JSON output, and Google Search grounding, plus the real limits.

## Read
- plan/DECISIONS.md (D-06, D-07)
- plan/OPEN-QUESTIONS.md

## May touch / must not touch
May: spikes/gemini/ · docs/spikes/SPK-03-gemini.md
Must not: lib/ · pubspec.yaml (root) · plan/

## Done when
1. `dart run spikes/gemini/bin/smoke.dart` (key from `.env.json`) prints a transcript of a short sample m4a and a JSON object matching a given schema
2. docs/spikes/SPK-03-gemini.md records: exact model ID used, free-tier rate limits with source links, max inline audio size, whether Search grounding is available on the free tier and its limit
3. The doc answers the two Gemini items in OPEN-QUESTIONS, including the free-tier data-use terms (with link)

## Rules
Needs the user's Gemini API key in `.env.json` (gitignored). Never print or commit the key.

## Evidence
Done 2026-10-15. Full findings: docs/spikes/SPK-03-gemini.md.
- Decisions: model gemini-3.5-flash (stable, free). Sample made with Gemini TTS (gemini-2.5-flash-preview-tts, voice Kore) then ffmpeg -> spikes/gemini/samples/idea.m4a (no espeak installed). Synthetic: does not prove Indian-accent accuracy.
- Gotchas: 3.x flash models often 503 (retry works); gemini-2.5-flash 404 for new users; Search grounding gives 429 on free tier (paid only, 5,000/month); vague start/end schema fields yield fake timestamps, prompt must say character offsets; wall time is slow (thinking tokens), run takes 1-3 min.
- Commands: `cd spikes/gemini && dart run bin/smoke.dart gemini-3.5-flash` -> transcript OK, schema JSON OK with valid offset spans, grounded = 429. Only dependency: http in spikes/gemini.
- Left: exact free RPM/RPD (only visible in AI Studio, needs user login); real-voice accent check (CAP-02).
