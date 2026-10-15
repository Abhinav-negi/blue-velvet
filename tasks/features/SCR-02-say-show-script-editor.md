# SCR-02 — Say/Show script editor
Needs: BEAT-01     Wave: 6

## Goal
Two-column Say/Show script for YouTube and Shorts beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md
- story-organizer-functional-spec.md (§6.1)

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: adding a row creates Say and Show cells that persist
3. Widget test: a film project shows the screenplay editor, a YouTube project shows Say/Show

## Rules
script/ folder: not in parallel with SCR-01.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
