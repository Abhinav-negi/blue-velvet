# SB-05 — Shape assist + ruler
Needs: SB-02     Wave: 4

## Goal
Hold at the end of a stroke to snap it to a line, circle, ellipse, rectangle or arrow; a ruler for straight lines.

## Read
- docs/ARCHITECTURE.md
- plan/areas/07-storyboard.md
- design.md (§8.5)

## May touch / must not touch
May: lib/features/storyboard/** · test/features/storyboard/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Unit tests: the recogniser classifies fixture strokes for each of the 5 shapes and leaves a scribble alone
3. Test: a hold ≥ the threshold triggers snapping; shorter does not
4. Test: strokes drawn along the ruler are straight within 1 px

## Rules
Pure recogniser in its own file. Add new files under canvas/.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
