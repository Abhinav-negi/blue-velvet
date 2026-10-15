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
Status: DONE.
Coverage: shots_camera 20/46 with image (26 text-only); shots_look 17/34 with image (17 text-only). 38 files in assets/seed/images (35 + diagrams), 7.2 MB total.
Decisions: Commons API search (generator=search, ns 6) with a descriptive User-Agent, picks reviewed visually on contact sheets. Movement entries pan, tilt, dolly-in, truck, pedestal, arc-shot use the CC BY-SA diagram set "Camera Movement - X" (Nathan W. Fullerton); dolly-zoom uses 2 PD renders (near/far). Rejected as weak and left text-only: over-the-shoulder, dutch-angle, snorricam, tracking-shot, split-diopter, low-key (candidates found but not clear demonstrations). No good free example found for: medium/cowboy/wide/establishing shots, eye/high/shoulder/hip/knee/ground angles, POV, whip-pan, dolly-out, handheld, drone, reveal, most composition/lighting extras (frame-in-frame, negative space, golden ratio, headroom, rack focus, deep focus, backlight, hard/soft light, practical/motivated).
Gotchas: Commons search is fuzzy (returns many unrelated Dietmar Rabich photos); shot-size photos are hard to find by keyword. Images are Commons 1280-px thumbnails re-encoded (JPEG q<=88, PNG palette-quantised for diagrams). three-point-lighting is a rasterised SVG. chiaroscuro uses a PD Caravaggio painting; rule-of-thirds and triangle-composition are PD/CC0 paintings with overlay guides. Licenses are normalised from extmetadata LicenseShortName (CC BY 2.0/3.0/4.0 -> CC-BY, CC BY-SA x -> CC-BY-SA, "Public domain" -> PD).
Commands/results: dart tool/validate_seed.dart assets/seed/shots_camera.json -> OK (46 items), exit 0; same for shots_look.json -> OK (34 items), exit 0. Check script (scratchpad res09/check.py): every referenced file exists, every file in images/ referenced, all <=1280 px and <=300 KB, license/author/source_url present, old-vs-new JSON identical apart from `images` -> "diff-only-images OK; files 38 bad 0". du -sh assets/seed/images -> 7.2M. Attribution table: assets/seed/sources/images.md (38 rows).
Left: nothing required. Optional later: more images for the text-only entries if better Commons files are found.
