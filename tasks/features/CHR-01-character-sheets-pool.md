# CHR-01 — Character sheets + pool
Needs: PROJ-01, DB-01     Wave: 5

## Goal
Character sheets with all spec §11.1 fields, the global pool, and each project's character list.

## Read
- docs/ARCHITECTURE.md
- plan/areas/08-characters.md

## May touch / must not touch
May: lib/features/characters/** · test/features/characters/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: creating a character saves every field
3. Widget test: the pool lists characters from all projects

## Rules
characters/ folder: CHR-02 runs after this.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
