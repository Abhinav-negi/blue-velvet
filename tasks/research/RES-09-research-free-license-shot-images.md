# RES-09 — Research: free-license shot images
Needs: RES-02, RES-08     Wave: 3

## Goal
Find a free-license reference image for every shot entry where a good one exists, so the shot library is visual on day one.

## Read
- docs/SEED_SCHEMA.md
- assets/seed/shots_camera.json
- assets/seed/shots_look.json
- plan/DECISIONS.md (D-15)

## May touch / must not touch
May: assets/seed/images/ · assets/seed/shots_camera.json · assets/seed/shots_look.json (image fields only) · assets/seed/sources/images.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. Both shots files still pass `dart tool/validate_seed.dart`
2. Every referenced image file exists and every file in assets/seed/images is referenced (check script output in Evidence)
3. Every image has license ∈ {PD, CC0, CC-BY, CC-BY-SA}, author and source_url
4. Each image ≤ 1280 px long side and ≤ 300 KB; `du -sh assets/seed/images` ≤ 40 MB
5. Evidence states coverage: entries with an image vs. text-only

## Rules
Source: Wikimedia Commons. No NC or ND licenses, no film stills. Pick images that clearly show the technique; leave text-only rather than use a weak example.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
