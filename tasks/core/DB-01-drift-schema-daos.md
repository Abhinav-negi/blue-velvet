# DB-01 — Drift schema + DAOs
Needs: INF-01, CON-01     Wave: 2

## Goal
Implement every table in docs/DATA_MODEL.md in Drift at schemaVersion 1, with basic DAOs and FTS5 search for void items. Features never edit the schema afterwards.

## Read
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md

## May touch / must not touch
May: lib/core/data/** · test/core/data/** · drift_schemas/
Must not: lib/features/ · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. `dart run build_runner build --delete-conflicting-outputs` succeeds
3. test/core/data/db_test.dart inserts and reads one row in every table (in-memory DB)
4. An FTS test finds a void item by a word in its summary and by a word in its raw transcript
5. Schema dumped to drift_schemas/ (for future migration tests); migration rule restated in a comment at the top of db.dart

## Rules
None beyond the orchestrator brief.

## Evidence
Done. All 15 tables at schemaVersion 1 (lib/core/data: tables.dart, converters.dart, extras.drift, db.dart, daos.dart).
- Decisions: indexes (incl. DESC and the partial unique `project_characters(project_id, character_id) WHERE mode='linked'`), the FTS5 table and its 3 sync triggers live in extras.drift so they are part of the schema dump. build.yaml enables the drift_dev `fts5` module (required, otherwise the virtual table is silently skipped). Enums are Dart enums stored as snake_case TEXT via EnumConverter (unknown value throws). JSON columns use StringListConverter / JsonMapConverter / JsonListConverter (shape-level, not per-field classes; features may wrap them). Timestamps are plain integer ms. `PRAGMA foreign_keys = ON` in beforeOpen.
- DAOs are minimal (VoidItems incl. `search`, Projects, Characters(+members, map), Beats(+frames), Settings, AiQueue). No DAO for templates/slots/shots/shot_images/proposals/snapshots yet: DB-02 and later add what they need; use `db.select(db.templates)` meanwhile. Search quotes each term and ANDs them.
- Gotchas: generated code copies converter expressions, so converter consts must be public (strListJson, mapJson, listJson). Remaining build warning "Duplicate orderings/filters ... proposalsRefs on VoidItems" is harmless (two FKs from proposals to void_items; add @ReferenceName if the manager API is ever used). Linux sqlite3 supports FTS5 (tests pass).
- Docs reading: DATA_MODEL snapshots.created_at only (no updated_at) followed literally; `proposal_id` / `frames.block_id` have no FK, per doc.
- Commands: build_runner build OK; `dart run drift_dev schema dump lib/core/data/db.dart drift_schemas/` -> drift_schemas/drift_schema_v1.json; flutter analyze: No issues; flutter test: 6 pass; check_boundaries.sh exit 0.
- Left: nothing. Next schema change must bump schemaVersion, add onUpgrade step, dump v2, add migration test.
