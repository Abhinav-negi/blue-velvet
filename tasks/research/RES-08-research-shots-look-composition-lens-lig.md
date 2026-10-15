# RES-08 — Research: shots, look (composition, lens, lighting)
Needs: CON-02     Wave: 2

## Goal
Shot-library entries for composition, lens feel and lighting.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§13)

## May touch / must not touch
May: assets/seed/shots_look.json · assets/seed/sources/shots_look.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/shots_look.json` → exit 0
2. ≥ 10 composition, ≥ 8 lens, ≥ 10 lighting entries
3. Every entry has description, when_to_use, effect and ≥ 2 tags
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. No images in this task (RES-09).

## Evidence
- Wrote 34 items (11 composition, 11 lens, 12 lighting), images empty. Sources: StudioBinder (URLs taken from web search results) plus Wikipedia (HTTP 200 checked).
- Gotcha: studiobinder.com returns 403 to curl, so StudioBinder pages were not fetched directly; text is from knowledge plus search summaries, paraphrased. Headroom, triangle, golden-hour, practical/motivated have only hub-page or Wikipedia support; stronger sources could be added later.
- Ran: dart tool/validate_seed.dart assets/seed/shots_look.json -> OK, exit 0. Category counts and source/URL-in-sources.md check pass.
- Left: nothing; RES-09 adds images.
