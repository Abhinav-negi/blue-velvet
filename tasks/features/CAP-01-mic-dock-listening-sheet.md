# CAP-01 — Mic dock + listening sheet
Needs: UI-02, SPK-02     Wave: 4

## Goal
The mic: idle amber button, expanding listening sheet with pulsing dot, timer, waveform and live words, processing state, haptics. Uses the approach SPK-02 chose.

## Read
- docs/ARCHITECTURE.md
- design.md (§8.1, §9, §11)
- plan/areas/01-capture.md
- docs/spikes/SPK-02-mic.md

## May touch / must not touch
May: lib/features/capture/** · test/features/capture/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget tests (fake recognizer): idle → listening → processing → idle; long-press = hold-to-talk
3. Mic button has a screen-reader label and is 64 dp; with Remove animations on, transitions are instant
4. On device: screenshot of the listening sheet showing live words (en-IN)

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time).

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
