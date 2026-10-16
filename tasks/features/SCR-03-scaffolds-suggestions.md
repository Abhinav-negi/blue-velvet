# SCR-03 — Scaffolds + suggestions
Needs: SCR-01, SCR-02, AI-06     Wave: 7

## Goal
Draft a skeleton when a beat is created (if permitted), and structure suggestions on request, shown as suggestions.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test (fake AI): a new beat gets a scaffold only when the permission is on
3. Widget test: suggestions render with the SuggestedText style and are not saved until accepted

## Rules
None beyond the orchestrator brief.

## Evidence
- Decisions: new-beat detection is script-side: the first time the Script tab shows a beat with empty blocks/say_show (and `screenplay_scaffold` is on) it calls `scaffoldBeat` once per screen session (`_asked` set). "Suggest structure" button (same op) is the on-request path, shown only when the permission is on. Result renders in `AppType.proposal` under the editor with Accept/Dismiss; Accept inserts a one-op pending `addScaffold` proposal and immediately runs `ProposalEngine.approve` (`acceptScaffold`), so the engine is the only writer (D-17/D-18, History/Undo); nothing is written before. Local `scriptAiProvider` (override in tests).
- Gotchas: scaffoldBeat wants `project_type` as `short_film` (not enum `.name`). Editors read the beat only at init, so Accept bumps a key (`_rev`) and passes the freshly saved beat. Character names come from `beatCharacterNames` (project member name, else library name).
- Commands: flutter analyze (No issues), flutter test (187 passed), tool/check_boundaries.sh (0), Color(0x grep (empty).
- Left: auto-scaffold re-runs after app restart for still-empty beats.
