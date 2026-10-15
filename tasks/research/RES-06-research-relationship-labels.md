# RES-06 — Research: relationship labels
Needs: CON-02     Wave: 2

## Goal
Quick-pick relationship labels for the character map.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§12)

## May touch / must not touch
May: assets/seed/relationship_labels.json · assets/seed/sources/relationship_labels.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/relationship_labels.json` → exit 0
2. ≥ 40 labels across 6 groups: family, social, romantic, professional, conflict, debt/obligation
3. Directional labels have an `inverse` (parent ↔ child, owes money to ↔ is owed by)
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
- Wrote 60 labels: family 15, social 8, romantic 7, professional 10, conflict 10, debt_obligation 10. Directional ones come in inverse pairs (parent-of/child-of, owes-money-to/is-owed-by); symmetric ones carry `symmetric: true`.
- Each item has a `sources` list (optional in validator, required by Done-when 4); every URL is in sources/relationship_labels.md.
- Gotcha: no authoritative taxonomy exists, so sources are Wikipedia reference pages per group (studiobinder/masterclass 403). Schema has no description field, so none added.
- Ran: `dart tool/validate_seed.dart assets/seed/relationship_labels.json` -> OK 60 items, exit 0.
- Left: nothing.
