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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
