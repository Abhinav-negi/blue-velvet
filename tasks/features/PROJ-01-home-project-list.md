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
- Built lib/features/home/home_screen.dart: ConsumerWidget; project list (ProjectsDao.watchAll), Void entry (goNamed 'void'), inbox icon + ember badge (hidden at 0) from a countAll(filter: status=pending) selectOnly over proposals in dbProvider; 'New project' FAB -> title dialog -> inserts shortFilm/16:9 empty project -> goNamed('overview'). Badge uses emberFill (amber is mic-only).
- Tests: test/features/home/home_test.dart (create->list->open shell; badge 3 / hidden at 0; golden test/features/home/goldens/home.png, opened and checked: 2 projects, badge 2).
- Gotchas: drift in widget tests needs tester.runAsync for DB seeding and an unmount + pump(1ms) before closing, else pending zero-timer / hang (see finish() helper). Live badge update after insert inside a test hung, so badge tests seed before pumping.
- Results: analyze clean; check_boundaries exit 0; Color(0x grep empty; flutter test: home tests pass, 3 FAIL in test/core/shell/app_shell_test.dart.
- CONFLICT: that frozen test taps the old placeholder 'Open a project' button and does not override dbProvider, so Home now throws. Needs a test/core fix by orchestrator: override dbProvider with AppDatabase(NativeDatabase.memory()), seed a project, tap its title instead of 'Open a project' (runAsync for seeding, finish() pattern from home_test.dart).
- Left: nothing else in scope (no project delete/sample project).
