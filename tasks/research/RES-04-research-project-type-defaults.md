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
Done 2026-10-15.
Differs from spec §6:
- Short film length 2-30 min -> 2-40 min: Academy short = 40 min or less incl. credits (Sundance: under 50).
- Long film length 60+ min -> 50+ min: Sundance feature = 50 min+; Academy feature = over 40. Grey zone 40-50 min stays unassigned.
- Short length <=60-90 s -> 15 s-3 min: YouTube Help now says Shorts up to 3 min.
- Short film default template "simple 5-point" = id five-point; long film 8-sequence = eight-sequence (same intent, now real IDs).
- Aspect ids: 16-9, 2-39-1, 9-16. aspect_ratios.json did not exist yet; validator only checks slug form. RES for aspect ratios must use these exact ids.
Unchanged from spec: writing sections, storyboard yes, characters, YouTube 5-30 min (no source contradicts it; typical, not a hard rule), extra fields.
Gotchas: schema has no template options field; I added `template_options` (default first, 2-4 IDs, all verified in templates.json). Validator ignores unknown keys. Docs/SEED_SCHEMA.md is frozen, so the orchestrator should add the field there.
Commands: validate_seed.dart -> OK, exit 0; python check of template_options subset of templates.json ids, default first, 2-4 long -> True; every URL in the JSON is in sources/project_types.md (no MISSING).
Left: nothing. YouTube Help page does not state 9:16 itself; Wikipedia (reference) backs aspect ratios.
