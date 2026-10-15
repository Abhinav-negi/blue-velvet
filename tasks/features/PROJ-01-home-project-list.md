# PROJ-01 — Home + project list
Needs: UI-02, DB-01     Wave: 4

## Goal
Home: project list, Void entry, global pending-proposals badge, and creating an empty characters-first project.

## Read
- docs/ARCHITECTURE.md
- plan/areas/03-home-projects.md
- design.md (§7)

## May touch / must not touch
May: lib/features/home/** · test/features/home/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: creating a project with only a title shows it in the list and opens its shell
3. Widget test: badge shows the count of pending proposals across projects and hides at 0
4. Screenshot of Home in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
