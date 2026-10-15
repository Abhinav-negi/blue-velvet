# BEAT-01 — Beat board
Needs: PROJ-01, DB-02     Wave: 5

## Goal
Beat cards on the board grouped by template slot (or a plain list with no template); add and edit beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md
- design.md (§8.3)

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: beats appear under their slots; empty slots show no warning
3. Widget test: no-template mode shows an ordered list
4. Screenshot of the board in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
- Board = `lib/features/beats/beats_screen.dart` (takes `projectId`; routes.dart passes it), data in `beats_providers.dart` (project template id, beats via `beatsDao.watchForProject`, frame-existence set, `saveBeat`). Reuses BEAT-04 `slotsProvider`.
- Template mode: slot headers in slot order (each with + to add a beat into it), beats under them, empty slots are just a header (no warning). Beats whose slot is null/not in the template go under "Unplaced". No template: plain list in `position` order. Entry to library: "Templates" button -> `goNamed('templates', pathParameters: {'projectId': id})`.
- Card: paper surface, 16 dp radius, thin teal band in template mode (one tint for all slots; per-act colours not done), script icon if `blocks` non-empty, image icon if frames exist.
- Add (FAB / slot +) and edit (tap card) use a bottom sheet (title + description).
- Not done (scope): long-press drag reorder, split/merge, characters/links on beats. Move-to-slot is not in the editor yet.
- Screenshot: test/features/beats/goldens/board.png (checked visually).
- Commands: flutter analyze, flutter test, bash tool/check_boundaries.sh, hex grep: see final run below.
- Dependencies needed: none.
- Section note: BEAT-01 added `projectBeatsProvider`, `projectTemplateProvider`, `saveBeat` in beats_providers.dart; reorder/split/merge/move-to-slot still open.
