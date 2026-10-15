# RES-04 — Research: project-type defaults
Needs: CON-02     Wave: 2

## Goal
Defaults for short film, long film, YouTube video and Short, checked against current practice (replaces the guessed table in spec §6).

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§6)

## May touch / must not touch
May: assets/seed/project_types.json · assets/seed/sources/project_types.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/project_types.json` → exit 0
2. Exactly 4 items with: typical length, default_template_id (a reserved ID), template options (2–4 IDs, default first), writing section, aspect ratio, type-specific fields
3. Evidence lists every value that differs from spec §6 and why
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
