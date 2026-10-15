# PROJ-04 — Sample project (S5)
Needs: DB-02, DB-03     Wave: 4

## Goal
Ship the spec §19 playground/watchman story as a fully built sample project, loaded once on first launch and deletable.

## Read
- docs/ARCHITECTURE.md
- story-organizer-functional-spec.md (§19)
- docs/DATA_MODEL.md
- docs/SEED_SCHEMA.md

## May touch / must not touch
May: lib/features/home/** · test/features/home/** · assets/seed/sample_project.json
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. assets/seed/sample_project.json exists with summary, 2 characters, ≥ 3 beats in a 5-point template, scaffolds, ≥ 1 frame with strokes, and a character-map edge "afraid of"
3. Test: first launch loads it once; a second launch does not duplicate it; deleting it keeps it deleted
4. Test: its content passes DB-03's snapshot round trip

## Rules
None beyond the orchestrator brief.

## Evidence
- Decisions: sample_project.json has its own format (local keys, ids generated at load; template `five-point`, slot ids `five-point/<slot>`). `lib/features/home/sample_project.dart`: `loadSampleProject` (guarded by settings `sample_project_created` + any `is_sample` row, one transaction, adds rows only), `deleteSampleProject` (project cascade + only the global characters it created and nobody else links). HomeScreen watches `sampleInitProvider` (first launch load, no main.dart change); long-press on the sample tile deletes it. Stroke file written to `strokes/<frame_id>.json` under `sampleFilesDirProvider` (path_provider docs dir). If seed templates are not loaded the sample gets no template/slots.
- Gotchas: existing home tests now override `sampleInitProvider` with a no-op (otherwise the sample appears in their DB). Other tests that open Home with an empty DB (void, proposals, shell) did not break. Sample stroke files are not removed on delete (orphans, harmless). No pending proposal/history in the sample.
- Conflict: `dart tool/validate_seed.dart assets/seed/sample_project.json` exits 2 ("unknown seed file", tool says sample has its own format, not validated); tool/ is outside my scope. So `for f in assets/seed/*.json` loop reports this one file.
- Commands: flutter analyze clean; flutter test 153 pass, 2 expected shell goldens fail; check_boundaries exit 0; Color(0x grep empty. Tests: test/features/home/sample_project_test.dart (content, no duplicate, delete stays deleted, delete only sample, snapshot capture/restore round trip).
- No packages needed. Left: nothing.
- Section note: Sample lives in features/home/sample_project.dart; Home tests must override `sampleInitProvider` (and `sampleFilesDirProvider` if it runs for real). Validator ignores sample_project.json format.
