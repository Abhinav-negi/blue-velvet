# SPK-01 — Spike: S Pen input in Flutter
Needs: -     Wave: 1

## Goal
Measure what Flutter actually reports for the S Pen on the S25 Ultra, so the canvas design rests on facts. Throwaway app; the findings document is the output.

## Read
- plan/areas/07-storyboard.md
- plan/OPEN-QUESTIONS.md

## May touch / must not touch
May: spikes/spen/ · docs/spikes/SPK-01-spen.md
Must not: lib/ · pubspec.yaml (root) · plan/

## Done when
1. `cd spikes/spen && flutter build apk --debug` → Built
2. docs/spikes/SPK-01-spen.md records measured on the S25 Ultra: pressure min/max, PointerDeviceKind seen, side-button `buttons` bit (or "not reported"), whether palm touches arrive while the pen is down
3. The doc answers the OPEN-QUESTIONS S Pen item (yes/no + fallback) and gives concrete recommendations for SB-02 and SB-03

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time). The user holds the pen; ask them to run the listed gestures.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
