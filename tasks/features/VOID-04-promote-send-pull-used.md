# VOID-04 — Promote, send, pull, used
Needs: VOID-01, PROJ-02, PROP-01     Wave: 6

## Goal
Promote a story idea to a pre-project, send an item to a project as a proposal, pull an item in from inside a project, mark items used.

## Read
- docs/ARCHITECTURE.md
- plan/areas/02-void.md

## May touch / must not touch
May: lib/features/void/** · test/features/void/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: Send to project creates a pending proposal and marks the item used
3. Widget test: Promote opens the pre-project review
4. Test: a used item stays in the Void and can be reused

## Rules
None beyond the orchestrator brief.

## Evidence
Decisions
- void_send.dart: `promoteIdea` (story idea only, not already promoted; sets status preProject; menu then does goNamed('project-from-idea')), `sendToProject` (AI call first, then one transaction: PENDING proposal with buildProposal's changes + `markUsed`), `projectContext` (AI_CONTRACT 5 built from DB; no blocks text), `markUsed` (adds project id once, never removes).
- Item menu (void_item_menu.dart): "Promote to project" (only unpromoted story idea) and "Send to project..." (project picker dialog). Sending never changes item status; item stays in the Void and can be sent again (new proposal each time, used list not duplicated).
- Pull in: route `void-pick` (/void/pick/:projectId, void_pick_screen.dart) lists Void items; tap = send to that project.
Gotchas
- Fake AI for buildProposal must use words from the raw text; test returns summary + empty changes.
Commands: flutter analyze -> No issues; flutter test -> all pass (223); check_boundaries -> 0; Color(0x grep -> empty. No golden changes.
Tests: test/features/void/void_send_test.dart (5): send+used+reuse, pull, promote opens review, promote hidden otherwise, promoteIdea guard.
What's left (orchestrator): no in-project entry point exists yet. Add a button in a project (e.g. Beats/Proposals screen) calling `context.pushNamed('void-pick', pathParameters: {'projectId': id})`.
