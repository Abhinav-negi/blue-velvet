# AI-02 — Offline AI queue
Needs: AI-01, DB-01     Wave: 4

## Goal
Captures made offline wait in ai_queue and run automatically when the phone is online, in order, with retries.

## Read
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md (ai_queue)
- docs/AI_CONTRACT.md

## May touch / must not touch
May: lib/core/ai/queue.dart · test/core/ai/queue*
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: an item queued while offline (fake connectivity) runs when online flips
3. Test: a failing item keeps its row with error count and next-retry time; others still run
4. Test: items run oldest first

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
