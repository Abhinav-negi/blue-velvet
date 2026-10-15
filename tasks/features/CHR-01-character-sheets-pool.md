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
- Built: sheet form (all 9 §11.1 fields + derived "Appears in" from beats.character_ids), project list (linked resolved via global row, forked via own columns), pool screen. New character from a project = global row + linked project_characters row. Pool-created = global row only.
- Decision: router.dart is frozen, so the pool routes are nested inside charactersRoutes (project shell): /project/:projectId/characters/pool (name 'character-pool'), pool/new ('pool-character-new'), pool/:id ('pool-character'); project sheet 'character-sheet' (:memberId), 'character-new'. Pool is reached via a "Character pool" row on the Characters tab.
- Editing a linked member edits the global row; forked edits its own columns (no fork action yet: CHR-02).
- Schema gaps: none. Pool only shows `characters` rows (forked-only copies are project-local by design).
- Results: flutter analyze no issues; flutter test all pass; check_boundaries exit 0; token grep empty. No new packages.
- Left: CHR-02 import/link/fork; promote from Void; AI extraction.
