# DB-02 — Seed loader
Needs: DB-01, CON-02     Wave: 3

## Goal
Load every assets/seed/*.json into the database on first launch, and on a seed version bump update built-in rows without overwriting rows the user edited.

## Read
- docs/ARCHITECTURE.md
- docs/SEED_SCHEMA.md
- docs/DATA_MODEL.md

## May touch / must not touch
May: lib/core/data/seed* · test/core/data/seed* · test/fixtures/seed/**
Must not: lib/core/data/db.dart (schema) · lib/features/ · assets/seed/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: fresh DB + fixture seeds → row counts equal item counts
3. Test: version bump updates non-edited built-in rows and leaves `user_edited` rows untouched
4. Test: a missing or malformed seed file is skipped with a logged error; the others still load
5. Test: seed names map to DATA_MODEL names (`short-film` → `short_film`, `proportion` → `runtime_proportion`, `source_urls` → sources) in one mapping function

## Rules
Parse items into the same model classes that fetched entries will use (fetch-and-convert reuses them).

## Evidence
Files: lib/core/data/seed_loader.dart (SeedLoader), lib/core/data/seed_mapping.dart (the one mapping: mapSeedTemplate / mapSeedShot), test/core/data/seed_loader_test.dart.
Decisions:
- Only templates, shots_camera, shots_look load: they are the only seed files with tables (templates, slots, shots, shot_images). project_types / screenplay_format / etc. have no table; features read them from the asset bundle.
- Models = Drift Companions in DATA_MODEL names (what fetch-and-convert will also produce). Row id = seed_id (`three-act`, `three-act/act-1`, `<shot>/<file>`), deterministic, so re-runs and FKs line up.
- Merge = one `INSERT ... ON CONFLICT(seed_id) DO UPDATE ... WHERE builtin AND NOT user_edited` (Drift DoUpdate+where); created_at kept on update; nothing deleted.
- Per-file version gate: settings `seed_version` JSON `{"templates":1,...}`; file loads only if its version is greater. Each file is one transaction; whole file mapped before writing, so a malformed item skips that file (logged via `log` callback, default debugPrint).
- Mapping: short-film->short_film, youtube-video->youtube; shot_size->size; proportion->runtime_proportion; template source_urls[0]->source_url; shot sources URL -> {title: host, url}.
Gotchas: shot_images are keyed by `<shot>/<file>`; an image removed from the seed is not deleted (rule: never delete). Not yet wired into app startup (no caller; main.dart is not in my scope) -> call `SeedLoader(db).load()` once after opening the DB.
Commands: flutter analyze -> No issues found; flutter test -> all 19 pass (incl. real assets/seed load test); check_boundaries.sh -> exit 0; Color(0x grep -> empty. No new dependencies. No schema change.
Left: wire load() into startup.
