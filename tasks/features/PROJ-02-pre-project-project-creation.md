# PROJ-02 — Pre-project → project creation
Needs: PROJ-01, AI-05, DB-03, DB-02     Wave: 5

## Goal
Review a story idea, approve, pick project type and one of 2–4 templates (default first), then generate the project through the proposal engine.

## Read
- docs/ARCHITECTURE.md
- plan/areas/03-home-projects.md
- story-organizer-functional-spec.md (§7)
- assets/seed/project_types.json (if present)

## May touch / must not touch
May: lib/features/home/** · test/features/home/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: template options come from project_types.json for the chosen type, default first
3. Test (fake AI): generation creates summary, characters and beats via DB-03 and leaves storyboards empty
4. Test: with Beat generation off, no beats are created

## Rules
None beyond the orchestrator brief.

## Evidence
Decisions
- Route `project-from-idea` (/idea/:voidItemId) in home/routes.dart; Home lists void items with status `pre_project` and opens it. `idea_screen.dart` = UI, `idea_project.dart` = seed loading (project_types + aspect_ratios JSON via rootBundle; template rows from DB, default first) + `createProjectFromIdea`.
- createProjectFromIdea: AI call first (failure leaves nothing), then ONE transaction: insert project (summary '' , template, aspect ratio name e.g. "2.39:1", newProjectAiPermissions) -> pending proposal with the draft's changes -> ProposalEngine.approve (D-17) -> `created` snapshot -> void item gets promotedProjectId/usedInProjectIds/status ready. Throws StateError if the idea was already promoted.
- The user-typed working title is required and always wins; the AI title is ignored (contract: AI title only if user didn't give one; we ask up front instead).
- Edited summary is used for generation only; not saved back to the void item (spans would go stale).
Gotchas
- Nothing sets VoidStatus.preProject yet and `lib/features/void` is out of scope: the Void item screen needs a "Promote to project" action that sets status preProject (or goNamed('project-from-idea', pathParameters: {'voidItemId': id})).
- Ungrounded ops (words not in the raw text) come back accepted=false and are skipped by the engine; test raw text must contain every field value.
- "Ask for changes" / "add more input" on the pre-project review are not built (only edit summary).
Commands: flutter analyze -> No issues; flutter test -> all pass (218); check_boundaries -> 0; Color(0x grep -> empty. No golden changes.
Tests: test/features/home/idea_project_test.dart (3).
