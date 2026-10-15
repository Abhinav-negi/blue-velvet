# BEAT-02 — Beat reorder, split, merge
Needs: BEAT-01     Wave: 6

## Goal
Long-press drag to reorder within and across slots; split and merge beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/05-beats-templates.md

## May touch / must not touch
May: lib/features/beats/** · test/features/beats/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: dragging a beat to another slot updates slot and order
3. Test: split produces two beats whose descriptions join to the original; merge reverses it
4. Widget test: with disableAnimations on, a reorder completes without animation

## Rules
None beyond the orchestrator brief.

## Evidence
- Code: lib/features/beats/beat_ops.dart (`moveBeat`, `splitBeat`, `mergeBeats`); UI in beats_screen.dart (LongPressDraggable cards, DragTarget on each card = insert before, on slot header = index 0, thin end zone per slot = append; per-card menu: Split (dialog, split at cursor) / Merge with next).
- Decisions: positions are project-global and renumbered 0..n-1 after every op. `moveBeat(flat: true)` used in no-template mode (beats keep stale slotIds there, so slot filtering would misplace). Moving into an empty slot appends to the global end (ponytail). Split: first beat keeps frames/script/say-show (nothing lost), new beat '<title> (2)' follows with the rest of the description; whitespace at the cut is dropped so a+' '+b == original. Merge mirrors proposal_engine _merge: first id survives, frames re-parented in order, blocks/sayShow appended, characters unioned, description joined with ' ', others deleted, no frame loss. Survivor title kept.
- No animation is added by the reorder; the disableAnimations test checks no running animations after drop.
- Gotcha: drift `db.transaction` inside a widget test with live streams hung, so split/merge are tested in plain test/features/beats/beat_ops_test.dart.
- Commands: flutter analyze -> No issues found; flutter test -> all pass except test/core/shell/app_shell_test.dart 400/800 dp goldens (known: regenerated goldens uncommitted on master); check_boundaries.sh exit 0; Color(0x grep empty. board.png regenerated and viewed (menu icon on cards).
- Packages needed: none. Left: nothing.
Section note: BEAT-02: use `moveBeat`/`splitBeat`/`mergeBeats` from beat_ops.dart; positions are project-global and contiguous.
