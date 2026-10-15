# AI-07 — AI: fetch & convert + shot options
Needs: AI-01, SPK-03, DB-02     Wave: 4

## Goal
Search the web and convert results into a template or shot entry draft with sources (or say it can't), and answer 'what shots work for…' from the library plus fetched drafts.

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
5. Live smoke: fetch "Kishōtenketsu" template draft in Evidence (or the SPK-03 fallback if grounding isn't free)

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
