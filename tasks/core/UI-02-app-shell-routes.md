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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
