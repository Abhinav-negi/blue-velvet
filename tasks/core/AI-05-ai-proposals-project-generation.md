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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
