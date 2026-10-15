# AI-06 — AI: scaffold, remap, suggestions
Needs: AI-01     Wave: 4

## Goal
Draft screenplay/script skeletons from the user's facts only, propose slot placement when switching templates, and give structure suggestions on request.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (scaffold, remapTemplate, suggestStructure)
- story-organizer-functional-spec.md (§9.2, §10.1)

## May touch / must not touch
May: lib/core/ai/scaffold.dart · lib/core/ai/remap.dart · lib/core/ai/prompts/scaffold* · test/core/ai/scaffold* · test/core/ai/remap* · test/fixtures/ai/scaffold/**
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: scaffold output containing a dialogue element is rejected (the AI never writes dialogue)
3. Test: remap returns a slot for every input beat; none dropped
4. Test: suggestions are returned flagged as suggestions, never as ops

## Rules
None beyond the orchestrator brief.

## Evidence
Files: lib/core/ai/scaffold.dart (scaffoldBeat, parseScaffold, hasUngrounded), remap.dart (remapTemplate, parsePlacements, suggestStructure, StructureSuggestion), prompts/scaffold_prompts.dart (SHARED_RULES verbatim + instructions + schemas), test/core/ai/scaffold_test.dart (MockClient, inline fixtures; no fixtures dir needed).
Decisions: validation failure -> retry once with a "broke the rules" note, then AiMalformedResponse (AI_CONTRACT 9.3). Gates: scaffold=screenplay_scaffold, remap=auto_placement, suggestStructure ungated (explicit user request). Film needs blocks and no rows; youtube/short the reverse; say must be "". Remap rejects dropped/duplicated beats and unknown slot ids (never fills in silently). Suggestions are StructureSuggestion (isSuggestion true), not ops. Grounding (9.2) is a cheap flag: ungrounded=true, not a rejection.
Gotchas: do not run `dart format` on lib/core/ai (it reformats frozen files; I reverted that). app_shell_test failed once under load ("did not complete"), passes on rerun.
Commands: flutter analyze -> No issues found; flutter test -> all 43 pass; bash tool/check_boundaries.sh -> exit 0.
Left: callers (proposal engine/UI) must wrap results in addScaffold / moveBeat ops; ungrounded flag has no diacritic/stem folding beyond trailing s.
