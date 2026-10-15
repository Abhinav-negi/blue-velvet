# RES-01 — Research: story templates
Needs: CON-02     Wave: 2

## Goal
Built-in structure templates so beats can be arranged on day one.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§6, §9)

## May touch / must not touch
May: assets/seed/templates.json · assets/seed/sources/templates.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/templates.json` → exit 0
2. Contains the reserved IDs from SEED_SCHEMA.md (three-act, eight-sequence, save-the-cat, heros-journey, five-point, story-circle, kishotenketsu) plus ≥ 2 YouTube and ≥ 2 Shorts structures
3. Where slot proportions are given, they sum to 1.0 ± 0.05 per template (checked by a one-line script, output in Evidence)
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. 

## Evidence
Done. 13 templates (7 reserved, 3 youtube-*, 3 shorts-*). Generator was a throwaway python script (not kept).
- validate_seed.dart exit 0 ("OK templates.json (13 items)").
- Proportion sums (python): three-act 1.0, eight-sequence 1.0, save-the-cat 0.97, youtube-hook-segments-cta 1.0, youtube-story-arc 1.0, youtube-listicle 1.0, shorts-hook-build-payoff 1.0, shorts-loop 1.0, shorts-problem-solution 1.0; heros-journey/five-point/story-circle/kishotenketsu have no proportions (no source).
- All source URLs appear in assets/seed/sources/templates.md (checked by script).
Gotchas: sources are mostly Wikipedia (reference trust); did not read Snyder/Vogler/Gulino books. YouTube/Shorts proportions are heuristics (flagged in sources file); official YouTube help pages were the only primary sources found. Eight-sequence slot text is generic. save-the-cat proportions derived from the 110-page positions.
Left: optionally swap in publisher/author pages (savethecat.com, Gulino book) for stronger primaries.
