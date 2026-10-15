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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
