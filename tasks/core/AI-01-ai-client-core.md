# AI-01 — AI client core
Needs: INF-01, DB-01, CON-03     Wave: 3

## Goal
The single gateway to Gemini: HTTP call, JSON-schema output, retries, timeouts, key lookup, and a permission gate that reads the project's AI switches.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md
- docs/spikes/SPK-03-gemini.md (if present)

## May touch / must not touch
May: lib/core/ai/ai_client.dart · lib/core/ai/errors.dart · lib/core/ai/permissions.dart · test/core/ai/client*
Must not: lib/features/ · lib/core/data/db.dart · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Tests with `package:http/testing` MockClient: success parses JSON; 429 then 200 retries and succeeds; malformed JSON → typed error
3. Test: a gated call with its permission off does not hit the network
4. Key lookup order: secure storage, then `--dart-define` GEMINI_API_KEY; test covers both

## Rules
No other file in the app may import `package:http`. Model ID comes from one constant.

## Evidence
- API: `AiClient.generateJson(prompt, schema, extraParts, gate, permissions)` returns the decoded JSON object. `gate` + project `ai_permissions` map -> `AiPermissionDenied` before any I/O (missing key = false). Ungated ops omit `gate`.
- Key: injected `readStoredKey` (default FlutterSecureStorage key `gemini_api_key`), then `--dart-define GEMINI_API_KEY`, else `AiNoKey`. Key only in `x-goog-api-key` header; error messages are fixed strings (network exceptions are not echoed).
- Retry 429/503, 4 tries, delay = `retryStep` (5 s) x attempt; tests use Duration.zero. Timeout 5 min per request. Timeouts/socket errors -> `AiNetworkError`, not retried.
- Model constant `geminiModel = 'gemini-3.5-flash'` in ai_client.dart; 404 message mentions it.
- Gotcha: private named param `this._dartDefineKey` is used (Dart 3.12 private named params), so the public arg name is `dartDefineKey`.
- Results: flutter analyze -> No issues found; flutter test -> 28 pass (8 new in test/core/ai/client_test.dart); check_boundaries exit 0; `grep -rln package:http lib` -> only ai_client.dart.
- Left: no thinking-level config, no Files API (>20 MB audio); add in AI-04 if needed.
