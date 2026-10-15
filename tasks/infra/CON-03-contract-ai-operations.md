# CON-03 — Contract: AI operations
Needs: CON-01     Wave: 2

## Goal
Write docs/AI_CONTRACT.md: every AI operation's input, output JSON and gating permission, the proposal change-ops, and the transcript-span format. All AI-* tasks and the proposal engine build against it.

## Read
- docs/DATA_MODEL.md
- story-organizer-functional-spec.md (§2, §4.3, §8, §10.1, §14, §15)
- plan/areas/04-proposals.md

## May touch / must not touch
May: docs/AI_CONTRACT.md
Must not: everything else

## Done when
1. One section per operation: transcribe, organize, editItem, detectProjectMention, generateProject, buildProposal, reviseProposal, scaffold, remapTemplate, suggestStructure, fetchConvert, shotOptions
2. Change-ops table with a JSON example each: addBeat, editBeat, splitBeat, mergeBeats, moveBeat, placeBeatInSlot, addCharacter, editCharacter, setSummary, addScaffold; field names match DATA_MODEL.md
3. Transcript-span format (character offsets into raw_transcript) defined with a worked example
4. Table mapping all 8 AI permissions (spec §14) to the operations/ops they gate
5. A shared "rules every prompt includes" block: no new ideas, no dialogue, keep names and specifics

## Rules
Doc only. If DATA_MODEL.md lacks a field you need, report it in Evidence; don't edit DATA_MODEL.md.

## Evidence
Wrote docs/AI_CONTRACT.md (12 ops, 10 change-ops with JSON examples, span format + worked example, permission table, shared rules block, validator rules).
Decisions:
- AI never returns char offsets; it returns exact `source_quotes` per summary sentence and the app computes UTF-16 offsets (LLMs count badly). Multiple spans per sentence_index allowed (DM 1.1 reads as permitting it).
- Gemini schema has no oneOf, so change-op is one flat object with nullable fields; per-op required fields enforced by the client validator (sec 9). `op` enum is trimmed per call by permissions; scaffold block enum is only scene_heading/action, say must be "" (machine-checkable no-dialogue).
- fetchConvert is two calls (grounded search, then JSON conversion) because Gemini usually cannot mix google_search with responseSchema. SPK-03 should confirm. Sources must come from grounding metadata.
- fetchConvert output uses DM column names (short_film, runtime_proportion, source_url), which differ from SEED_SCHEMA (short-film, proportion, source_urls); app maps.
- scaffold for a hand-made beat goes through a one-op pending proposal (D-17 strict). Orchestrator may relax to direct flagged append.
- Permission strictness: user-instructed beat/character edits are still gated by the switch (off = user does it by hand).
- suggestStructure and detectProjectMention: no switch (explicit request / routing only).
Invented names (all inside proposals.changes JSON or call envelopes, no table change): ref, beat_ref, slot_id/position on ops, character_names(_add/_remove), parts, beat_ids, blocks/rows on addScaffold, project_character_id on editCharacter. Listed in AI_CONTRACT sec 11.
DM gaps (non-blocking): none required. Note DM 1.1 says AI contract defines the sentence splitter: done in sec 2.1 (regex; no abbreviation handling).
Commands: grep loops for 12 ops, 10 change-ops, 8 permissions -> no MISSING output. Did not read SPK-03 (absent at start).
Left: nothing for this task; AI-* tasks should confirm Gemini schema dialect and the two-step fetch against SPK-03.
