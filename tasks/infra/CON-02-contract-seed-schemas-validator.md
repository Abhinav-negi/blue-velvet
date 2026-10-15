# CON-02 — Contract: seed schemas + validator
Needs: -     Wave: 1

## Goal
Write docs/SEED_SCHEMA.md (format of every built-in library file) and a validator so research tasks can check their own output before the app exists.

## Read
- plan/areas/13-built-in-libraries.md
- story-organizer-functional-spec.md (§6, §9.3, §10, §13)

## May touch / must not touch
May: docs/SEED_SCHEMA.md · tool/validate_seed.dart · tool/fixtures/
Must not: lib/ · pubspec.yaml · assets/

## Done when
1. SEED_SCHEMA.md defines, with an example item each: templates.json, shots_camera.json, shots_look.json, screenplay_format.json, project_types.json, song_structures.json, relationship_labels.json, aspect_ratios.json, guides.json
2. Every file is `{"version": int, "items": [...]}` and every item has a stable slug `id`; the reserved built-in template IDs are listed (so project_types.json can reference them)
3. Shot image fields defined: file, license, author, source_url; allowed licenses: PD, CC0, CC-BY, CC-BY-SA
4. `dart tool/validate_seed.dart tool/fixtures/<valid>.json` → exit 0 for one valid fixture per file type; an invalid fixture → non-zero exit with a readable message

## Rules
Validator uses only `dart:` libraries so it runs without the Flutter project. The sources/*.md format is defined here too.

## Evidence
Done. Files: docs/SEED_SCHEMA.md, tool/validate_seed.dart, tool/fixtures/valid/<9 files>, tool/fixtures/invalid/{templates,shots_camera,guides}.json + invalid/b/guides.json (fixtures are named by file type because the validator detects the schema from the file name; invalid ones sit in their own folder).
Decisions: schemas for non-spec'd files (screenplay_format rules-bag, project_types, song_structures, relationship_labels, aspect_ratios, guides normalised 0-1 shapes line/rect/circle/polyline) are my design; shots_camera = shot_size/angle/movement/lens, shots_look = composition/lighting (not enforced). default_template accepts the 7 reserved ids or youtube-*/shorts-* prefix; no cross-file checks except relationship inverse, since files are validated singly.
Gotchas: validator checks image files exist only if an images/ dir sits next to the JSON. Cross-file refs (default_aspect_ratio, template ids actually existing) are not verified; an integration check could come later.
Results: all 9 valid fixtures -> exit 0; 4 invalid -> exit 1 with path messages; `dart analyze tool/validate_seed.dart` -> No issues (dart 3 switch syntax used, no pubspec needed).
Left: nothing.
