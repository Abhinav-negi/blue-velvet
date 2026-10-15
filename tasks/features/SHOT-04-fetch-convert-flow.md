# SHOT-04 — Fetch & convert flow
Needs: SHOT-01, BEAT-04, AI-07     Wave: 5

## Goal
Ask for a template or shot from the web, see a preview with sources, save to the library only on approval.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md
- story-organizer-functional-spec.md (§15.4)

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake AI): the preview shows sources; Save adds it to the library; Cancel adds nothing
3. Widget test: a cannotConvert result shows an explanation, nothing saved
4. Test: with Internet fetch off, the action is disabled

## Rules
shots/ folder: not in parallel with SHOT-03.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
