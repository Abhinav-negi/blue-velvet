# SPK-03 Gemini free tier (run 2026-10-15)

Script: `spikes/gemini/bin/smoke.dart` (run `cd spikes/gemini && dart run bin/smoke.dart [model]`). Key read from `.env.json`, sent only in `x-goog-api-key`.

## Result summary
| Check | Result |
|---|---|
| Audio transcription (inline m4a) | Works, near-verbatim |
| Structured JSON (`responseMimeType: application/json` + `responseSchema`) | Works, schema respected |
| Sentence-to-transcript offsets in the JSON | Works if the prompt says "0-based character offsets into your own transcript"; vague wording made the model invent timestamps (5000, 12000) |
| Google Search grounding on free tier | NOT available: HTTP 429 RESOURCE_EXHAUSTED on every retry |

## Model
- Used: **`gemini-3.5-flash`** (stable ID, no `-preview`), free of charge. Also confirmed transcript works on `gemini-3.8-flash`; its structured call hit repeated 503/hung, so it was not fully verified.
- `gemini-2.5-flash` returns 404 "no longer available to new users". Do not use 2.5.
- `gemini-flash-latest` returned 503 at test time. Pin an exact ID in `lib/ai/ai.dart`, because aliases move.
- Free-tier pricing (3.8/3.6 Flash: input, output, caching "Free of charge"): https://ai.google.dev/gemini-api/pricing

## Reliability finding
The 3.x Flash models returned HTTP 503 "high demand" often (several of ~10 calls; usually cleared after 1 to 3 retries of 5-15 s). AI-01 needs retry with backoff on 503 and 429, and a user-visible "try again" path (the raw audio must be kept until transcription succeeds, subject to the spec's delete-after rule).
Thinking tokens are large (879 to 2718 on a 12 s clip) and slow the call; consider a low thinking level for transcription.

## Free-tier rate limits
- Google no longer publishes fixed free-tier numbers in the docs. Limits are per project (not per key), measured as RPM, TPM, RPD; RPD resets at midnight Pacific; preview/experimental models are stricter; actual values are shown only in AI Studio: https://ai.google.dev/gemini-api/docs/rate-limits and https://aistudio.google.com/rate-limit
- Not observed: I never hit a 429 on plain generation during ~12 calls, so the limits are comfortably above single-user "one capture at a time" use. The exact numbers still need a look in AI Studio (needs the user's login; I could not read it).

## Inline audio
- Max inline request size: **20 MB total** (prompt plus all files). Larger: Files API. Source: https://ai.google.dev/gemini-api/docs/audio
- Max audio length: 9.5 hours per prompt; 32 tokens per second of audio (about 1,920 per minute). Measured: 12 s clip = 309 audio tokens.
- Accepted: WAV, MP3, AIFF, AAC, OGG, FLAC, M4A, Opus, WebM and more. We sent AAC in an m4a container as `audio/mp4`; it worked.
- Rule of thumb: AAC 64 kbps is about 0.5 MB per minute, so 20 MB is about 40 minutes. Base64 adds 33%, so keep recordings under about 25 minutes inline, or switch to the Files API above that.

## Search grounding
- Not on the free tier for Gemini 3+ models. Pricing page: paid tier gets 5,000 free grounded prompts per month (shared across Gemini 3 and newer), then $14 per 1,000. Free column: not available. https://ai.google.dev/gemini-api/pricing
- Confirmed live: `tools: [{google_search: {}}]` on `gemini-3.5-flash` gave 429 "exceeded your current quota" on 5 attempts, while ungrounded calls worked.

## Free-tier data-use terms
- Unpaid services: Google uses prompts, files and responses "to provide, improve, and develop" its products and ML; human reviewers may read and annotate them (disconnected from account, key and project first). Google says: do not submit sensitive, confidential or personal information. Paid services: not used for improvement. EEA, Switzerland and UK: paid-service terms apply even on free quota.
- Source: https://ai.google.dev/gemini-api/terms (pricing page also marks "Used to improve our products: Yes" for free, "No" for paid).

## Answers to OPEN-QUESTIONS
1. **Free-tier limits for audio transcription and Search grounding?** Transcription: works free, up to 20 MB inline, exact RPM/RPD only visible in AI Studio. Search grounding: not free. So the "leaning" fallback applies: fetch (area 10) must use a free search API or a manual URL paste, or the user enables billing (5,000 grounded prompts per month free there, but then free-tier data-use terms no longer apply either).
2. **Is "Google may use inputs to improve its products" acceptable for story ideas?** Technically fine, but it is a product decision for the user: the free tier states human reviewers may read inputs and outputs, and it includes voice audio. Mitigation: the key is single-user and billing-free; if unacceptable, enable billing on the project (pay-per-use, tiny at this volume), which switches to the no-training terms. Revisit D-06 only then.

## Recommendations
- **AI-01 (client in lib/ai/ai.dart):** pin `gemini-3.5-flash` in one constant; send key in `x-goog-api-key` header, never in the URL; retry 503/429 with backoff (5 s steps, up to 4 tries); parse `candidates[0].content.parts[].text`; map 404 "no longer available" to a clear error.
- **AI-04 (transcription / cleaning):** inline `audio/mp4` base64 via `record` AAC output; one call can return transcript plus cleaned text via responseSchema. Cap inline at about 20 MB (about 25 min). Verify with a real Indian-accented voice in CAP-02: the sample is Gemini TTS ("Kore" voice asked for Indian English), so it is synthetic, clean, and does NOT prove accuracy on real accents, noise or rambling.
- **AI-07 (summary to transcript spans):** use `start`/`end` integer character offsets in the schema and say so explicitly in the prompt; always validate `0 <= start < end <= transcript.length` and fall back to no highlight. Offsets index the model's returned transcript, so store that transcript (not a separate one) as the source. Do not plan on Search grounding in the free tier.
