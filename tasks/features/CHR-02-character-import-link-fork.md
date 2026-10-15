# CHR-02 — Character import, link, fork
Needs: CHR-01, BEAT-01     Wave: 6

## Goal
Import from the pool or another project (linked by default), fork to a local copy, and auto-filled 'appears in'.

## Read
- docs/ARCHITECTURE.md
- plan/areas/08-characters.md

## May touch / must not touch
May: lib/features/characters/** · test/features/characters/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: editing a linked character changes it in both projects; a forked one changes only locally
3. Test: adding a character to a beat updates its 'appears in' list

## Rules
None beyond the orchestrator brief.

## Evidence
- Decisions: `importCharacter` (linked, reuses existing linked row) and `forkMember` (copies global sheet into the row, keeps row id and character_id as origin) in characters_providers.dart. Pool screen has an Import (download icon) button per row; sheet screen shows Fork when the membership is linked. "From another project" = the pool, since it lists every character from every project. `appearsInProvider` is now a live StreamProvider over beats, so adding a character to a beat updates the list.
- Tests: test/features/characters/chr02_test.dart (linked edit visible in both projects; fork diverges both ways; appears-in updates on beat change, project and global view). Provider tests use ProviderContainer + listen (reading `.future` of the stream provider hung).
- Commands: flutter analyze -> No issues; flutter test -> 139 pass, 2 fail (shell goldens 400/800, stale in worktree, regenerated uncommitted on master; fail at baseline too); check_boundaries -> exit 0; Color(0x grep -> empty.
- Packages needed: none. Not done: unlink/delete UI (not in scope).
- Section note: appearsInProvider is now a StreamProvider; use `.value` as before.
