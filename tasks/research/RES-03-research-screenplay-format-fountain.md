# RES-03 — Research: screenplay format + Fountain
Needs: CON-02     Wave: 2

## Goal
Exact formatting rules for the screenplay editor, PDF export and Fountain export.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§10.1, §16.2)

## May touch / must not touch
May: assets/seed/screenplay_format.json · assets/seed/sources/screenplay_format.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/screenplay_format.json` → exit 0
2. Every element in spec §10.1 has left/right margins (inches), capitalisation and spacing rules, cited
3. ≥ 8 transitions; page rules (US Letter and A4, 12 pt Courier, ~55 lines, MORE/CONT'D); Fountain syntax for every element with an example
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
- Wrote assets/seed/screenplay_format.json (24 items) + sources/screenplay_format.md. Indents are absolute from page edge, US Letter (scene/action 1.5/1.0, dialogue 2.5/2.5, parenthetical 3.1/3.0, character 3.7/1.0, transition 6.0/1.0).
- Gotchas: Nicholl and Final Draft pages unreachable; sources disagree on character indent (3.7 vs 3.8). A4 values, MORE details, scene-number positions, transition list are convention/derived (noted in sources md). Schema has no "shot" element in Fountain; handled as forced heading/action.
- Ran: dart tool/validate_seed.dart assets/seed/screenplay_format.json -> OK, exit 0.
- Left: optionally verify against Nicholl / Final Draft docs.
