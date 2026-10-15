# PROP-01 — Proposal review
Needs: UI-03, DB-03, PROJ-01     Wave: 5

## Goal
Proposal stack (oldest first), review screen with DiffView, per-change accept, Approve all, Reject (discard or to Void), Defer, edit text.

## Read
- docs/ARCHITECTURE.md
- plan/areas/04-proposals.md
- design.md (§8.2)

## May touch / must not touch
May: lib/features/proposals/** · test/features/proposals/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: accepting 2 of 3 changes applies only those (via DB-03)
3. Widget test: Reject → to Void creates a void item with the transcript
4. Widget test: Defer leaves the proposal pending; approve fires a medium haptic

## Rules
proposals/ folder: PROP-02 and PROP-03 run after this one, not alongside each other.

## Evidence
Decisions:
- /proposals = inbox (pending, oldest first, all projects); child route `proposal` (/proposals/:id) = review screen. Only routes.dart in the folder changed; router.dart untouched.
- Per-change accept = checkbox; flags are held locally and written to proposals.changes (`accepted`) just before `ProposalEngine.approve`, which is the only thing that touches project data (D-17). Button reads "Approve all" or "Approve N of M".
- Reject sheet: Discard or Send to the Void (void item type `other`, status ready, summary + raw transcript + spans copied; proposals.rejected_to_void_item_id set). Defer = pop, no write.
- Approve then `HapticFeedback.mediumImpact`; engine soft-fail notes show as SnackBars. Engine does not check permission gates; none checked here (AI_CONTRACT: Approve is the authority).
- "Edit text" edits the proposal summary only (not individual op fields). "Show what I said" lights all stored spans (per-sentence tap S4 not built; splitSentences lives in features/void, off-limits).
- Diff lines: editBeat and setSummary show before/after from the DB; editCharacter shows new fields only (ponytail note in code).
Gotchas: reading `.value` of the FutureProvider/StreamProvider in tests needs a real-async delay inside runAsync before pump. No Undo bar (PROP-03), no ask-for-changes (PROP-02).
Commands: flutter pub get ok; flutter analyze -> No issues; flutter test -> 127 pass (3 new in test/features/proposals/proposals_test.dart); check_boundaries.sh exit 0; Color(0x grep empty.
Packages needed: none.
Section note: PROP-02/03 can reuse `ProposalActions` + providers in lib/features/proposals/proposals_providers.dart; the review screen is proposal_screen.dart. Inbox icon badge count not built here (home owns it).
