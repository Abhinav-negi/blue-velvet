# RES-05 — Research: song structures
Needs: CON-02     Wave: 2

## Goal
Song sections and common arrangements for Lyric items in the Void.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§5.1)

## May touch / must not touch
May: assets/seed/song_structures.json · assets/seed/sources/song_structures.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/song_structures.json` → exit 0
2. ≥ 7 section types (intro, verse, pre-chorus, chorus, bridge, hook, outro) with descriptions
3. ≥ 5 common arrangements as ordered section lists
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
