# DB-03 — Proposal engine + snapshots
Needs: DB-01, CON-03     Wave: 3

## Goal
Pure logic that applies a proposal's change-ops in one transaction, creates a snapshot on approve, restores snapshots, and undoes the last approve. The only code path that changes project content from a proposal.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (change-ops)
- docs/DATA_MODEL.md

## May touch / must not touch
May: lib/core/data/proposal_engine* · lib/core/data/snapshots* · test/core/data/proposal_engine* · test/core/data/snapshots*
Must not: lib/core/data/db.dart (schema) · lib/features/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. A test per change-op type applies it and asserts the resulting rows
3. Test: applying a subset of ops (per-change accept) applies only those
4. Test: approve creates a snapshot; restore makes project state equal the snapshot and itself creates a snapshot; undo restores the pre-approve state
5. Test: frames and stroke files are unchanged by any op or restore

## Rules
None beyond the orchestrator brief.

## Evidence
Files: lib/core/data/proposal_engine.dart (ProposalEngine.approve / undoLastApprove, all 10 ops), lib/core/data/snapshots.dart (SnapshotService.capture / create / restore), test/core/data/proposal_engine_test.dart (21 tests).
Decisions:
- Class is `SnapshotService` because `Snapshots` is the Drift table name.
- Approve snapshot = state BEFORE ops (reason proposal_approved, stored in proposals.snapshot_id); undo = restore that snapshot, then proposal -> pending, snapshot_id NULL. Undo therefore also writes a `restored` snapshot.
- Restore follows DATA_MODEL 13.1: replaces project row, project_characters, beats (cascade removes frames, re-inserted from snapshot), character_map; then inserts a `restored` snapshot of the post-restore state. Stroke files are never read/written.
- Snapshot rows are raw SQL rows (snake_case keys, enums as snake text); JSON columns stored parsed. `resolved` sheet added for linked characters. is_sample stays 0/1.
- Restore nulls dangling refs (template_id, slot_id, character_id, shot_id) so a deleted seed/global row cannot FK-fail the restore.
- mergeBeats must re-parent frames (contract), so frames change beat_id/position only; strokes_path, thumbnail, notes, updated_at stay. Every other op leaves frame rows byte-identical (tested).
- Bad op / unresolved ref / dialogue block / non-empty `say` / unknown slot throws ProposalException inside the transaction -> whole approve rolls back (tested). Unmatched character names are soft: left unlinked, returned as notes by approve().
- Permission gates (AI_CONTRACT section 8) and grounding are NOT checked here; that is the validator's job. Engine trusts `accepted` flags.
Gotchas: Drift data classes compare lists by identity, so tests compare frames via toJson().toString().
Commands: flutter analyze -> No issues found; flutter test -> all 35 pass; bash tool/check_boundaries.sh -> exit 0.
Left: nothing for DB-03. Callers (UI) must call approve/undo only; nothing wired into features yet.

### Fix round (after independent review)
- mergeBeats rejects duplicate ids. approve rethrows any non-ProposalException (bad casts) as ProposalException after rollback. Only `accepted == true` ops run. `_slot` checks the slot belongs to the project's template. addScaffold checks project type (screenplay=blocks, Say/Show=rows) and required text/show. Unused `_charRefs` removed.
- restore: first inserts a `manual` snapshot "Before restore", then upserts beats (no delete-all), never touches existing frame rows, re-inserts only missing snapshot frames, keeps beats absent from the snapshot that own frames (moved to end of their slot; frameless extras are deleted). A linked project_character whose global character is gone is restored as `forked` with the snapshot's `resolved` sheet.
- Consequence (by design, Done-when 5): undoing a mergeBeats leaves the re-parented frames on the survivor beat; the merged-away beat comes back empty. Tests adjusted accordingly (merge removed from the restore==snapshot equality test; frames test asserts only beat_id changes).
- undoLastApprove: latest approve = resolved_at, then snapshot created_at, then snapshot id. Throws if a restore taken after that approve went back to a snapshot older than it (checked in `_restoredSince` by rowid order); undo chains (undo of newer approve restores a newer snapshot) are not blocked.
- Global `characters` behaviour unchanged (pending user decision): linked editCharacter edits the global row, undo does not revert it, addCharacter leaves a global row. Isolated in `_editCharacter`/`_addCharacter` (engine) and `SnapshotService._restoreCharacters`.
- Strengthened stroke test: new test adds a frame (own stroke file) and edits another after approve, undoes, asserts frame rows and all stroke file bytes unchanged.
Commands: flutter analyze -> No issues found; flutter test -> all 48 pass; bash tool/check_boundaries.sh -> exit 0.
Section note: none.
