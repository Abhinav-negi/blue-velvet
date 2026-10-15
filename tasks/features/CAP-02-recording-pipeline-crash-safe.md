# CAP-02 — Recording pipeline (crash-safe)
Needs: CAP-01, AI-04, AI-02     Wave: 5

## Goal
Record in chunks, then transcribe → organize (Void) or buildProposal (project), delete audio after the transcript is saved; offline captures queue. Recovers orphaned chunks after a crash (S2).

## Read
- docs/ARCHITECTURE.md
- plan/areas/01-capture.md
- docs/spikes/SPK-02-mic.md
- docs/AI_CONTRACT.md

## May touch / must not touch
May: lib/features/capture/** · test/features/capture/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: on success the audio files are deleted and the raw transcript is stored
3. Test: offline stop enqueues a needsAi item
4. Test: on app start, orphaned chunks are found and queued
5. On device: kill the app mid-recording, reopen → the recording is recovered (Evidence)

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time).

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
