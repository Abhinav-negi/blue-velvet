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
- Decisions: 11 sections (7 required + post-chorus, interlude, instrumental-break, breakdown) and 8 arrangements. Sources are Wikipedia only (reference trust; studiobinder/masterclass 403). Arrangement `sequence` uses section ids only; AABA maps A=verse, B=bridge; 12-bar blues uses verse + instrumental-break.
- Gotchas: the Wikipedia Chorus page 404s; used Refrain. Verse-chorus URL contains an en dash, stored percent-encoded.
- Commands: `dart tool/validate_seed.dart assets/seed/song_structures.json` -> OK, 19 items, exit 0; every JSON URL grep-verified in sources md.
- Left: nothing. Source md notes are generic; could add a book source (e.g. Berklee songwriting texts) later.
