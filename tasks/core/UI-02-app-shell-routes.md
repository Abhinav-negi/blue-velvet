# UI-02 — App shell + routes
Needs: UI-01     Wave: 3

## Goal
The navigable skeleton: router composed from each feature's routes.dart, placeholder screens, home, project shell (top tabs on phones, left rail ≥ 600 dp), bottom bar with mic dock slot and inbox.

## Read
- docs/ARCHITECTURE.md
- design.md (§7, §8.1)
- plan/areas/03-home-projects.md

## May touch / must not touch
May: lib/router.dart · lib/main.dart · lib/core/widgets/app_shell* · lib/features/*/routes.dart · lib/features/*/*_screen.dart (placeholders only) · test/core/shell/**
Must not: lib/core/theme/ · lib/core/data/ · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Every feature folder has routes.dart exporting its routes, and lib/router.dart only concatenates them
3. Widget test: from Home, open a project and visit all 6 tabs (Overview, Characters, Beats, Script, Board, Settings)
4. Widget test: at 400 dp width the tabs are on top; at 800 dp a left rail; the bottom bar (64 dp) with a 64 dp mic slot shows on both
5. Screenshots at phone and tablet width attached in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
Decisions:
- No `project` feature folder, so the shell is lib/core/widgets/app_shell.dart (pure UI: takes tabs + callbacks, core never imports features). router.dart wraps the 6 tab routes in a `ShellRoute` and picks the selected tab from `state.topRoute.name`.
- Route names: home, void, proposals, overview, characters, beats, script, board, settings. Project tabs live at /project/:projectId/<tab>. Overview is in features/home (`overviewRoutes`, besides `homeRoutes`). capture, character_map, shots, export export empty route lists (no screens yet).
- Home is a placeholder with an "Open a project" button using projectId `new` (no data layer yet). Inbox icon pushes `proposals` outside the shell.
- Mic slot is a 64 dp amber button, semantics label "Record idea", empty onTap; CAP-01 replaces it (AppShell has an `onMic` param).
- Tabs row is SingleChildScrollView+Row (not ListView) so off-screen tabs stay findable in tests.
Gotchas: flutter_test renders Ahem boxes; the shell test loads Inter/Literata/Lucide fonts by hand (Lucide path from ~/.pub-cache, brittle if lucide version changes). debugShowCheckedModeBanner is off in main.dart.
Commands: flutter analyze -> No issues found; flutter test -> 9 pass; bash tool/check_boundaries.sh -> exit 0.
Screenshots: test/core/shell/goldens/shell_phone_400.png, shell_tablet_800.png (regenerate: flutter test --update-goldens test/core/shell).
Left: project title in top bar (needs data), real mic dock (CAP-01), inbox badge.
