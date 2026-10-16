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

### Evidence (BEAT-03)
- Added lib/features/beats/template_switch.dart: `beatsAiProvider` (local AiClient, tests override), `proposeSwitch` (calls remapTemplate only if auto_placement is on; AI failure or switch off => all beats unplaced), `applySwitch` (one transaction: sets projects.template_id, slot_id and contiguous positions; beats only updated, never deleted), `TemplateSwitchScreen` (draggable preview, Confirm), `startSwitch` (template picker). Entry: "Switch template" button on BeatsScreen.
- Direct user edit pattern (like beat_ops.dart): plain Drift writes in a transaction, not proposal_engine.
- Gotcha: Drift `.watch().first` hangs under testWidgets' fake zone; use `.get()`. Board golden board.png regenerated (new button).
- Ran: flutter analyze (no issues), flutter test (186 pass), check_boundaries.sh (0), Color(0x grep (empty).
- Left: AI failure reason is not shown to the user (silent fall back to unplaced).
