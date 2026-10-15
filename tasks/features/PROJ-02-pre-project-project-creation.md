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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
