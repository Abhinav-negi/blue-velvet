# NAV-01 — Entry points for unlinked screens
Needs: EXP-04, MAP-01, CHR-01, SHOT-01, SHOT-04, PROP-03     Wave: 7

## Goal
Every finished screen is reachable from the UI. Today these routes have no entry point: `export`, `history`, `character-map`, `character-pool`, `shots`, `shot-fetch`. Check `templates` too.

## Read
- docs/ARCHITECTURE.md
- design.md (§7, only the screens you add a button to)
- lib/router.dart and lib/features/*/routes.dart (route names; read only)

## May touch / must not touch
May: lib/features/home/** · lib/features/characters/** · lib/features/beats/** · and the matching test/features/<same>/** folders
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Project overview links to Export and History (route names, `pathParameters: {'projectId': id}`)
3. Characters tab links to the character pool and the character map
4. Home links to the shot library (`shots`); the template library links to `shot-fetch`
5. One widget test per link: tapping it navigates to the named route (use a test GoRouter with stub pages for the targets)

## Rules
- Cross-feature navigation by route name only (D-20). Small, quiet entries (icon button in the heading row or a list tile), design tokens only.
- Goldens in your folders that change: regenerate with `--update-goldens` and say which. Do not touch `test/core/shell/goldens` (orchestrator).

## Evidence
- Added: overview tiles Export/History (keys overview-export/overview-history); Home app-bar camera button -> `shots`; Characters tile 'Character map' (character-pool tile already existed); template library app-bar download button -> `shot-fetch`. `templates` already linked from beats_screen.dart.
- Tests: nav_links_test.dart in test/features/{home,characters,beats}, stub GoRouter targets. Overview test wraps the screen in a Scaffold (ListTile needs Material).
- Golden regenerated: test/features/home/goldens/home.png (new app-bar icon).
- Results: analyze clean, check_boundaries exit 0, no Color(0x. flutter test: all pass except test/core/shell/app_shell_test.dart (2 tests, 400dp and 800dp; Home tab body changed) -> orchestrator regenerates shell goldens.
