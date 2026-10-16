# AI-05 — AI: proposals + project generation
Needs: AI-01, DB-03     Wave: 4

## Goal
Build proposals (change-ops) from new input, generate a new project's initial content, and revise a proposal by instruction, respecting AI permissions.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (buildProposal, generateProject, reviseProposal, detectProjectMention)

## May touch / must not touch
May: lib/core/ai/proposals.dart · lib/core/ai/prompts/proposals* · test/core/ai/proposals* · test/fixtures/ai/proposals/**
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: fixture outputs parse into ops that DB-03's engine applies without error
3. Test: with Character extraction off, no addCharacter ops are requested or accepted
4. Test: detectProjectMention returns the matching project ID (or none) for fixture inputs
5. Live smoke on the spec §19 transcript: ops + wordsCheck result in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
- API (lib/core/ai/proposals.dart): `buildProposal`, `reviseProposal`, `generateProject`, `detectProjectMention`, `allowedOps`, `changesSchema`. Output ops carry `id` (uuid) + `accepted` (false when ungrounded per wordsCheck, or when the user had it off in a revise). Never writes data; ProposalEngine applies.
- Decisions: per-call op enum from the switches (empty -> `changes` left out of schema); forbidden ops dropped with a note, ops on a dropped beat_ref go too; slot fields stripped when auto_placement off or no template; character_names filtered to existing characters when extraction off. Hard failures (bad refs, dialogue block, quoted text not said, wrong blocks/rows for project type, placeBeatInSlot on placed beat) retry once with a note, then AiMalformedResponse. Names/titles are grounded separately (prefix trick) so one-word names are not exempt as sentence starts. Context shape = AI_CONTRACT section 5 (beats[].id/slot_id, characters[].project_character_id/name, template.slots[].slot_id/seed_id, project.type).
- File has `ignore_for_file: curly_braces_in_flow_control_structures` (flat guard list).
- Tests: test/core/ai/proposals_test.dart (fixtures in test/fixtures/ai/proposals): engine applies build+generate fixtures; extraction off -> no addCharacter requested/accepted; detect cases; revise keeps ids/flags.
- Commands: flutter analyze -> No issues found; flutter test -> all 139+ pass; check_boundaries.sh -> exit 0.
- Done-when 5 (live smoke): NOT DONE. `dart run tool/ai_smoke.dart proposals <file>` (new op, written) hit 503 then persistent 429 "Rate limit or quota exceeded" across ~6 tries over ~10 min. Re-run: `timeout 600 dart run tool/ai_smoke.dart proposals <transcript-file>` with the AI_CONTRACT 2.3 transcript; paste ops + wordsCheck here.
- Packages needed: none (uses existing uuid, http).
- Section note: proposals.dart expects PROJECT_CONTEXT per AI_CONTRACT 5; callers must pass `beats[].slot_id` (null when unplaced) and `characters[].name`.
- 2026-10-16 (orchestrator, after AI-08 fallback): `timeout 600 dart run tool/ai_smoke.dart proposals test/fixtures/ai/proposals/generate.json` → live buildProposal OK on the §19 transcript: setSummary, addCharacter Kid, addCharacter Watchman, addBeat b1, all accepted; `wordsCheck: summary [], ungrounded ops []`. Done-when 5 PASS.
- Smoke-tool nit: the generateProject wordsCheck line runs over `jsonEncode(op)` (so uuids/keys show up as "ungrounded"); check op text fields only. The live setSummary repeated the transcript almost word for word after a short summary.
