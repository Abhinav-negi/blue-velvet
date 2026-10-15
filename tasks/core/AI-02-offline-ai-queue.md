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
- Class is `AiQueueRunner` (lib/core/ai/queue.dart); `AiQueue` is the drift table name. Inputs: `db`, `online` (Stream<bool>; `connectivityStream()` adapts connectivity_plus), `runJob(AiJob)`, injectable `now`, `maxAttempts`=5, `baseBackoff`=30s (doubles per attempt).
- Retryable = AiNetworkError, AiHttpError 429/5xx; anything else -> status failed at once. After maxAttempts -> failed. Retry failure keeps row needsAi with attempts, error, next_retry_at; other jobs keep running.
- start() resets stuck `processing` rows to `needs_ai`. A Timer re-drains at the earliest next_retry_at. Uses only AiQueueDao.due/enqueue plus direct db.update (DAO frozen).
- Not wired: nothing constructs the runner yet; the integrator must supply runJob (maps job.kind to AiClient ops and writes results) and call start().
- Results: analyze clean, flutter test all pass, check_boundaries exit 0. Timer rescheduling is untested.
