# SPK-02 — Spike: mic sharing for live words + recording
Needs: -     Wave: 1

## Goal
Find out whether `speech_to_text` (live words) and `record` (audio file) can use the mic at the same time on Android, and how long live listening lasts.

## Read
- plan/areas/01-capture.md
- plan/OPEN-QUESTIONS.md

## May touch / must not touch
May: spikes/mic/ · docs/spikes/SPK-02-mic.md
Must not: lib/ · pubspec.yaml (root) · plan/

## Done when
1. `cd spikes/mic && flutter build apk --debug` → Built
2. docs/spikes/SPK-02-mic.md records on the S25 Ultra: do both receive audio together (yes/no), max continuous listening before speech_to_text stops, whether `en_IN` is available
3. The doc picks the capture approach (both together, or waveform-then-transcript fallback) with the reason, for CAP-01/CAP-02

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time).

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
