# HANDOFF — 2026-10-16
State: session 5 done, all ready work merged on master. Analyze clean, 211 tests pass, boundaries pass. Merged: BEAT-03, SCR-03 (accept = one-op addScaffold proposal, auto-approved), SCR-04, EXP-01, EXP-02, EXP-04, SET-01, NAV-01 (new). Core: themeModeProvider, SettingsDao.watch, writeSecureGeminiKey, lib/core/data/ai_defaults.dart (new projects inherit global AI defaults).
In flight: AI-09 (main folder).
Blocked: AI-05 smoke — gemini-3.5-flash free tier is 20 requests/day/model and was spent (429 RESOURCE_EXHAUSTED); PROJ-02, PROP-02, CAP-03, VOID-04 wait on it. AI-04 needs a voice clip. SPK-01/SPK-02 need the phone. DB-04 needs the Google OAuth client.
Next step: get the user's answer on the AI model (asked twice, unanswered): A) keep flash, wait for the daily reset, or B) flash with automatic flash-lite fallback on daily-quota 429 (recommended; gemini-3.5-flash-lite answered OK on 2026-10-16). Then re-run `timeout 600 dart run tool/ai_smoke.dart proposals test/fixtures/ai/proposals/generate.json` and unblock PROJ-02/PROP-02/CAP-03.
Carry forward:
- Worth a small core task (with or after option B): one app-wide AiClient provider. Today beats, script, shots and void each define a local one.
- User asked for a CTO view of a Claude MCP-connector proposal: answered "not now" (breaks no-backend/local-first, bypasses D-17, doesn't fix the Gemini cap); possible v2 "send to Void" connector after QA-01. No decision recorded.
- Visual nit: FABs ("Add beat", "New project") have a dark ring, likely shared FAB theme in core/theme.
- SCR-04 board page has no stroke thumbnails (needs a shared thumbnail widget in core). EXP-02: no MORE/CONT'D, title page or scene numbers. EXP-04: no beat headings.
- BEAT-03: an AI failure silently falls back to all-unplaced; no message to the user.

# HANDOFF — 2026-10-15
State: session 4 done (all ready work merged on master). Analyze clean, 184 tests pass, boundaries pass. Merged this session: DB-03 (after review + fix round), AI-04, AI-05, SHOT-01/03/04, CHR-01/02, VOID-02/03, BEAT-01/02/04, PROJ-03/04, PROP-01/03, SCR-01/02, SB-01, MAP-01.
In flight: NAV-01 (main folder).
Blocked: AI-04 — live smoke needs a voice clip in test/fixtures/audio/ (`timeout 600 dart run tool/ai_smoke.dart transcribe <file>`). AI-05 — live smoke hit Gemini 429 (`timeout 600 dart run tool/ai_smoke.dart proposals <file>`); PROJ-02, PROP-02, CAP-03 wait on it. SPK-02 (phone not visible to adb), SPK-01 (waits for S25 Ultra). DB-04 needs the user's Google OAuth client.
Next step: ask the user to commit master (ledger, regenerated shell goldens, beat_ops guard, .gitignore, removal of test/core/shell/failures). Retry the AI-05 smoke (and AI-04 if a clip exists); if they pass, mark DONE and run PROJ-02/PROP-02/CAP-03. Ready now: BEAT-03, SCR-03, SCR-04 (script/ folder: one at a time with SCR-03), EXP-01/02/04 (one at a time), SET-01 (add core pieces first, see below).
Carry forward:
- SET-01 needs core pieces first (theme-mode provider in main.dart, a write-key function in lib/core/ai/key_store.dart). Add them yourself before briefing it.
- Nothing wires AiQueueRunner.runJob into the app, and there is no core AiClient provider (VOID-03 and SHOT-03 each have a local one). Worth a small core task.
- Unlinked routes needing entry points: shots, shot-fetch, templates, character-pool, character-map, history (only from the proposal review screen).
- Undo/restore reverts linked characters' shared sheets in every project (user decision 2026-10-15); restore snapshots "Before restore" first and never touches frames.
- Visual nits: BEAT-01 "Add beat" FAB has a dark ring; transcribe() byte-slice chunking fails past ~14 MB.
- Agents' `dart format` runs touch frozen files: tell them to format only their own files.

# HANDOFF — 2026-10-15
State: session 3 done (hit the 5-hour usage limit). Merged on master: RES-05, AI-01, UI-03, AI-02, AI-03, AI-06, AI-07, VOID-01, PROJ-01, plus dbProvider/seed-at-startup. Analyze clean, 81 tests pass.
In flight: session 4 batch 4 — AI-05, BEAT-02, MAP-01, PROJ-04, SHOT-04, SCR-02 IN-PROGRESS in ../lynch-wt/<ID> (branch task/<ID>). Batches 1–3 merged.
Blocked: SPK-02 (phone not visible to adb), SPK-01 (waits for S25 Ultra).
Next step: ask about DB-03 (reviewer or merge) and the subagent cap, then run ready tasks: AI-04, BEAT-04, SHOT-01, BEAT-01, CHR-01, VOID-02; after DB-03 merges: AI-05, PROJ-03, PROJ-04, PROP-01.
Carry forward: SET-01 needs core pieces first (theme-mode provider in main.dart, a write-key function in lib/core/ai/key_store.dart). Add them yourself before briefing it. Nothing wires AiQueueRunner.runJob or ProposalEngine into the UI yet. Agents' `dart format` runs touch frozen files: tell them to format only their own files.

# HANDOFF archive (newest first)

# HANDOFF — 2026-10-15
State: session 2 done (low budget, user away). RES-06, RES-07, DB-02 merged on master; analyze clean, 19 tests pass, all seeds validate.
In flight: DB-03 REVIEW (lynch-wt/DB-03); AI-02, AI-03, AI-06, AI-07, PROJ-01, VOID-01 (worktrees lynch-wt/<ID>, session 3)
Blocked: SPK-02 — S21 FE not visible to adb (check again; user said phone is connected); SPK-01 — waits for S25 Ultra.
Next step: ask the subagent cap, then run ready tasks: RES-05 (research), UI-03, DB-03, AI-01 (core; DB-03 and AI-01 both touch lib/core — check May-touch overlap). DB-04 needs the user present (OAuth client + phone).
Carry forward: path contains a space, quote it. Worktrees go in /home/abhinav/Projects/lynch-wt/<ID> on branch task/<ID>; create them yourself and do NOT pass isolation:"worktree" to the Agent (it makes a second, unused worktree). Read tasks/core/HANDOFF.md before core tasks and tasks/features/HANDOFF.md before features (SeedLoader not wired yet). Review UI screenshots for colour roles: amber = mic/primary only, teal = selected/where-you-are.

---

# HANDOFF — 2026-10-15
State: session 1 done. Waves 1–2 nearly complete; core foundation (theme, DB, app shell) merged on master; app builds, 14 tests pass.
In flight: nothing
Blocked: SPK-02 — S21 FE not visible to adb (USB debugging not active); SPK-01 — waits for S25 Ultra.
Next step: ask the subagent cap, then run ready tasks: RES-05, RES-06, RES-07 (research), UI-03, DB-02, DB-03, DB-04, AI-01 (core). DB-04 needs the user's Google OAuth client and the phone.
Carry forward: path contains a space, quote it. Worktrees go in /home/abhinav/Projects/lynch-wt/<ID> on branch task/<ID>; copying a section HANDOFF into a worktree leaves it dirty (use --force on remove after checking). Read tasks/core/HANDOFF.md before core tasks (naming map, Gemini model + 503 retries, D-21 fetch flow). Review UI screenshots for colour roles: amber = mic/primary only, teal = selected/where-you-are.

# HANDOFF — 2026-10-15
State: blueprint created, no sessions yet.
In flight: SPK-03, RES-09 (main folder); DB-01, UI-02 (worktrees ../lynch-wt/<ID>, branches task/<ID>)
Blocked: nothing
Next step: start wave 1 (all except SPK-01). Gemini key is already in `.env.json` (verified working; gitignored).
Carry forward: the project path contains a space; quote every path. Test phone for now is a Galaxy S21 FE (no S Pen): use it for every "Needs the phone" task except SPK-01 and the canvas chain (SB-02 onward), which wait for the S25 Ultra. Results that are stylus-specific must be re-checked on the S25 Ultra.

