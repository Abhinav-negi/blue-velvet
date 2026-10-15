# RES-07 — Research: aspect ratios + composition guides
Needs: CON-02     Wave: 2

## Goal
Aspect-ratio choices and exact overlay geometry for the storyboard canvas.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§10.4)

## May touch / must not touch
May: assets/seed/aspect_ratios.json · assets/seed/guides.json · assets/seed/sources/aspect_ratios.md · assets/seed/sources/guides.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/aspect_ratios.json` and `dart tool/validate_seed.dart assets/seed/guides.json` → exit 0
2. ≥ 8 ratios (incl. 2.39:1, 1.85:1, 16:9, 4:3, 1:1, 9:16) with numeric value and typical use
3. guides.json covers rule of thirds, golden ratio grid, golden spiral, centre cross, diagonals, title-safe, action-safe in normalised 0–1 coordinates; safe-area percentages cited
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
