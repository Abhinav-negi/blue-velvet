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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
