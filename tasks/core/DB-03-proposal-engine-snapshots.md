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
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
