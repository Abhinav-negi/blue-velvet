# RES-02 — Research: shots, camera (size, angle, movement)
Needs: CON-02     Wave: 2

## Goal
Shot-library entries for shot size, camera angle and camera movement.

## Read
- docs/SEED_SCHEMA.md
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§13)

## May touch / must not touch
May: assets/seed/shots_camera.json · assets/seed/sources/shots_camera.md
Must not: lib/ · pubspec.yaml · docs/ · other seed files

## Done when
1. `dart tool/validate_seed.dart assets/seed/shots_camera.json` → exit 0
2. ≥ 10 shot sizes (extreme close-up to extreme wide), ≥ 8 angles, ≥ 12 movements (incl. dolly zoom, Dutch angle, over-the-shoulder)
3. Every entry has description, when_to_use, effect and ≥ 2 tags
4. Every item has ≥ 1 source URL, and each one is listed in the matching `assets/seed/sources/*.md`

## Rules
Write descriptions in your own words; never paste paragraphs from sources (copyright). Prefer primary, reputable sources (books, film-school or industry references). Data only, no app code. No images in this task (RES-09).

## Evidence
Done. assets/seed/shots_camera.json: 46 items (15 shot_size, 13 angle, 18 movement), images [] (RES-09 adds).
- Sources: StudioBinder camera-shots guides (reference) + Wikipedia per-topic pages; all URLs HTTP-checked 200 and listed in sources/shots_camera.md. MasterClass returned 403, so not used. Text paraphrased from my own knowledge, not copied.
- Gotcha: StudioBinder pages were confirmed to exist but not read in full; Wikipedia trust marked community.
- Commands: dart tool/validate_seed.dart assets/seed/shots_camera.json -> OK, exit 0; per-category counts via python; every item has >=2 tags and sources found in the md.
- Left: nothing. Generator script was in scratchpad (not kept).
