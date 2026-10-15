# BEAT-03 — Template switch
Needs: BEAT-02, AI-06     Wave: 7

## Goal
Switch a project's template: AI proposes where each beat goes, the user confirms or drags, and no beat is ever lost.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test (fake AI): after switching, the beat count is unchanged
3. Widget test: the remap preview lets a beat be dragged before confirming
4. Test: with Auto-placement off, beats land unplaced for manual placement

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
