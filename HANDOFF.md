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
