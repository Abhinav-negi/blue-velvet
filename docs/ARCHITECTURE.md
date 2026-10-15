# Lynch architecture

Decisions: D-08 (Riverpod, go_router), D-04 (Drift), D-06 (one AI file), D-14 (seed data), D-20 (feature isolation).

## Folder layout
```
lib/
  main.dart            app entry, ProviderScope
  router.dart          the only file that imports every feature's routes.dart
  core/
    theme/             tokens.dart, theme (design.md §14)
    data/              Drift database, migrations, seed loader, backup
    ai/                ai.dart: the only file that calls Gemini
    widgets/           shared widgets used by 2+ features
  features/
    capture/ void/ home/ proposals/ beats/ script/ storyboard/
    characters/ character_map/ shots/ settings/ export/
      routes.dart      the feature's GoRoute list (its only public surface)
      ...              screens, widgets, providers private to the feature
assets/fonts/          Literata, Courier Prime, Inter + OFL licences
assets/seed/           built-in libraries as JSON (never hard-coded in Dart)
docs/                  contracts (data model, seed schema): source of truth
tool/                  check_boundaries.sh, seed validation
```

## The import rule
A file in `lib/features/<a>/` may import only `dart:`, third-party packages, `package:lynch/core/**` and files inside its own folder. It never imports `lib/features/<b>/` (package or relative path). `lib/router.dart` may import each feature's `routes.dart`.
If two features need the same code, move it to `lib/core/`.
Enforce with `bash tool/check_boundaries.sh` (exit 1 on a violation); run it before every commit.

## Add a feature
1. Create `lib/features/<name>/` with `routes.dart` exporting `final <name>Routes = <RouteBase>[...]`.
2. Put screens and providers inside the folder; import only `core/`.
3. Add one line to `lib/router.dart` to include `<name>Routes`.
4. Run `bash tool/check_boundaries.sh`, `flutter analyze`.

## Remove a feature
1. Delete `lib/features/<name>/`.
2. Delete its one line (and import) in `lib/router.dart`.
3. Run the boundary check and `flutter analyze`. Nothing else may reference it. Its tables stay in the schema (see the migration rule).

## Migration rule
All tables are declared up front in `lib/core/data`. The schema changes only through a versioned Drift migration (bump `schemaVersion`, add a step in `onUpgrade`) with a test that migrates from the previous version. Never edit an old migration step. Reference data changes only in `assets/seed/*.json` (bump the seed version), never in Dart.

## Other rules
- AI output is a proposal; only the user's Approve applies it (D-17).
- Colours, spacing and radii come from `tokens.dart` only; no raw values in widgets.
- The Gemini key is read from `--dart-define-from-file=.env.json` and never committed.
