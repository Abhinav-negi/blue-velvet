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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
