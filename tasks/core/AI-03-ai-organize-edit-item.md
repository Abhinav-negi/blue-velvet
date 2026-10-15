# AI-03 — AI: organize + edit item
Needs: AI-01     Wave: 4

## Goal
Turn a transcript into a Void item draft (type, summary, structure, tags, spans), and edit an item by instruction, both following the 'your words' rules.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (organize, editItem)
- assets/seed/song_structures.json (if present)

## May touch / must not touch
May: lib/core/ai/organize.dart · lib/core/ai/prompts/organize* · lib/core/ai/words_check.dart · test/core/ai/organize* · test/fixtures/ai/** · tool/ai_smoke.dart
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: recorded response fixtures for each of the 7 item types parse into drafts
3. Test: `wordsCheck(summary, transcript)` flags a capitalised name in the summary that is absent from the transcript, and passes a clean one
4. `dart run tool/ai_smoke.dart organize test/fixtures/transcripts/playground.txt` (live key) prints a draft; output and wordsCheck result in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
