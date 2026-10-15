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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
