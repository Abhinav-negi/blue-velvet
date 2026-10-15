# AI-07 — AI: fetch & convert + shot options
Needs: AI-01, SPK-03, DB-02     Wave: 4

## Goal
Gather source text in the app (Wikipedia + Wikimedia Commons APIs, optional Brave Search key, pasted/shared URLs; D-21) and convert it with one Gemini call into a template or shot entry draft with sources (or say it can't); answer "what shots work for…" from the library plus fetched drafts.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (fetchConvert, shotOptions)
- docs/SEED_SCHEMA.md
- docs/spikes/SPK-03-gemini.md

## May touch / must not touch
May: lib/core/ai/fetch.dart · lib/core/ai/prompts/fetch* · test/core/ai/fetch* · test/fixtures/ai/fetch/**
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: fixture drafts (DATA_MODEL names, per AI_CONTRACT fetchConvert) save into the same templates/slots/shots rows the seed loader writes
3. Test: an un-convertible result returns a 'cannotConvert' outcome, not a made-up format
4. Test: every draft carries ≥ 1 source URL
5. Test (fake HTTP): with no Brave key, search uses only Wikipedia/Commons, and returned `sources` are a subset of the fetched URLs; live smoke of a "Kishōtenketsu" template draft in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
Decisions: lib/core/ai/fetch.dart = FetchConvert (gather: Wikipedia+Commons action API always, Brave only with key, pasted URLs via AiClient.getText; one Gemini call; parseFetchResult validates, drops sources not fetched, cannot_convert / no cited source -> CannotConvert), saveFetchDraft (builds seed-shaped map, reuses mapSeedTemplate/mapSeedShot, then flips builtin=false, seed_id=null, overrides project_types/sources with DATA_MODEL values; no lib/core/data change), shotOptions (LibraryShot list; fetched drafts are passed in as extra LibraryShot with temp ids; wants_fetch only when internet_fetch on). Prompts in lib/core/ai/prompts/fetch_prompts.dart (SHARED_RULES copied verbatim). AiClient got only `getText(Uri, {headers})` (descriptive User-Agent).
Gotchas: draft images are not downloaded/saved (spec: after approval; image_candidates kept on ShotDraft). Image candidate URLs must come from Commons imageinfo URLs. Do not run `dart format` on ai_client.dart (reformats existing code).
Commands: flutter analyze -> No issues found; flutter test -> All tests passed (42); check_boundaries.sh -> exit 0; grep -rln package:http lib -> only ai_client.dart.
Live smoke (1 Gemini call, `dart run tool/ai_smoke_fetch.dart`, exit 0): PASS. Kishotenketsu TEMPLATE with 4 slots (Introduction (ki), Development (sho), Twist (ten), Conclusion (ketsu)), sources [Kishotenketsu -> https://en.wikipedia.org/wiki/Kish%C5%8Dtenketsu]. runtime_proportion null; project_types came back [] (the smoke passed no PROJECT_TYPES hint; the UI should ask the user to pick).
Left: UI wiring, image download on approval, Brave key storage.
