# QA-01 — End-to-end + accessibility pass
Needs: BEAT-01, BEAT-02, BEAT-03, BEAT-04, CAP-01, CAP-02, CAP-03, CAP-04, CHR-01, CHR-02, EXP-01, EXP-02, EXP-03, EXP-04, MAP-01, PROJ-01, PROJ-02, PROJ-03, PROJ-04, PROP-01, PROP-02, PROP-03, RES-01, RES-02, RES-03, RES-04, RES-05, RES-06, RES-07, RES-08, RES-09, SB-01, SB-02, SB-03, SB-04, SB-05, SB-06, SB-07, SCR-01, SCR-02, SCR-03, SCR-04, SET-01, SET-02, SHOT-01, SHOT-02, SHOT-03, SHOT-04, VOID-01, VOID-02, VOID-03, VOID-04     Wave: 9

## Goal
Walk the spec §19 example end to end on the phone and check accessibility, restore and export, to call v1 done.

## Read
- story-organizer-functional-spec.md (§19)
- design.md (§12)
- docs/ARCHITECTURE.md

## May touch / must not touch
May: test/integration/** · docs/QA.md
Must not: lib/ (report bugs as new tasks instead of fixing)

## Done when
1. docs/QA.md records each §19 step as pass/fail with a screenshot
2. At 1.3× system font size no screen overflows (screenshots of 6 key screens)
3. Every seed file loads (count check in Evidence) and `for f in assets/seed/*.json; do dart tool/validate_seed.dart "$f"; done` → all exit 0
4. Backup → clear data → restore keeps the sample project intact
5. Every failure is filed as a new task proposal in Evidence

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time).

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
