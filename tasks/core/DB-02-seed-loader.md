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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
