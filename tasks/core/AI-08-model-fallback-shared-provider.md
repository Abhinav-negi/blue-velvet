# AI-08 — Model fallback + one shared AiClient provider
Needs: AI-01     Wave: 7

## Goal
D-23: AiClient calls `gemini-3.5-flash`; on a **daily-quota** 429 it retries the same request on `gemini-3.5-flash-lite`. Also replace the four feature-local AiClient providers with one app-wide provider in core.

## Read
- lib/core/ai/ai_client.dart, lib/core/ai/key_store.dart, test/core/ai/client_test.dart
- lib/core/data/providers.dart (how core providers are declared)
- The four local providers: lib/features/beats/template_switch.dart (beatsAiProvider), lib/features/script/scaffold_suggestions.dart (scriptAiProvider), lib/features/shots/shot_options.dart (shotAiProvider), lib/features/void/void_actions.dart (voidAiProvider), plus every file that reads/overrides them (`grep -rn "AiProvider" lib test`)

## May touch / must not touch
May: lib/core/ai/ai_client.dart · new lib/core/ai/ai_provider.dart · test/core/ai/client_test.dart · the feature files and tests found by the grep above (only to switch to the shared provider) · tool/ai_smoke.dart (only if it references `geminiModel`)
Must not: pubspec.yaml · docs/ · other lib/core/ai files · plan/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: daily-quota 429 on flash (body mentions a per-day quotaId, e.g. `GenerateRequestsPerDayPerProjectPerModel-FreeTier`) → next request goes to the lite model URL and its 200 result is returned, with no backoff retries on flash first
3. Test: a plain 429/503 (no per-day quota in body) keeps today's retry behaviour on flash
4. Test: after a daily-quota fallback, the next call on the same client goes straight to lite (no wasted flash call)
5. Test: lite also daily-quota 429 → AiHttpError(429) with a message saying today's free quota is used up
6. `grep -rn "AiClient(" lib --include=*.dart` → only lib/core/ai/ai_client.dart and lib/core/ai/ai_provider.dart

## Rules
- ai_client.dart stays pure Dart (no Flutter/Riverpod imports); the provider lives in ai_provider.dart.
- Detect daily quota from the error body text, never log or echo the body/key.
- "Remember flash is spent" can be an in-memory field on the client; mark its ceiling with a `ponytail:` comment (resets on app restart).
- No live Gemini calls in tests (MockClient only).

## Evidence
- Done 2026-10-16. `aiClientProvider` in lib/core/ai/ai_provider.dart; 4 local providers removed, tests override it.
- Client: `geminiModelLite` const; body containing "PerDay" on 429 sets `_flashSpent` (in-memory, ponytail) and retries on lite with a fresh retry budget; second per-day 429 throws AiHttpError(429, "Today's free Gemini quota is used up...").
- Tests added in test/core/ai/client_test.dart (group "daily-quota fallback"). Ran: analyze clean, flutter test all pass, check_boundaries exit 0, grep AiClient( = only ai_client.dart + ai_provider.dart.
