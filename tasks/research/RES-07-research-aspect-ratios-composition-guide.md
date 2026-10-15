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
- Decisions: 9 ratios (ids 16-9, 2-39-1, 9-16 fixed by project_types; added 1-85-1, 4-3, 1-1, 1-37-1, 1-43-1, 2-76-1). 7 guides. Safe areas use EBU R95 (action 3.5% margin = 93%, title 5% margin = 90%), not legacy 90/80.
- Golden spiral: 121-point polyline from quarter arcs in nested squares of a phi rectangle, x scaled by 1/phi to fill 0-1 (stretches on non-golden frames; focal point lower right).
- Gotcha: Wikipedia Safe_area page gives no percentages; EBU R95 PDF did.
- Ran: validate_seed on both files -> exit 0 (9 and 7 items). Done-when 2: 9 ratios incl. all six required PASS. 3: 7 guides all required PASS. 4: every item has sources, all 5 URLs listed in sources md PASS.
- Left: nothing.
