# Core notes
Read before starting work in this folder. Under 15 lines. Delete a note once it's resolved.

- Seed files (docs/SEED_SCHEMA.md) and DB/AI (docs/DATA_MODEL.md, docs/AI_CONTRACT.md) use different names: `short-film` vs `short_film`, `proportion` vs `runtime_proportion`, `source_urls` vs `source_url`/`sources`. DB-02 owns the single mapping function; AI-07 drafts already use DATA_MODEL names.
- AI_CONTRACT: change-ops are one flat object with nullable fields (Gemini has no oneOf); the client validator enforces per-op required fields.
- SPK-03 (docs/spikes/SPK-03-gemini.md): use model `gemini-3.5-flash` (one constant); 3.x Flash often returns 503 → retry 503/429 with backoff (≈5 s steps, 4 tries). Calls take 1–3 min (thinking tokens). Spans: say "character offsets into the returned transcript" explicitly in prompts.
- D-21: no Search grounding on free tier. fetchConvert = app-side search (Wikipedia/Commons, optional Brave key, pasted URLs) + one Gemini conversion call. AI_CONTRACT §4.11 updated.
- AI-03: SHARED_RULES constant is in lib/core/ai/prompts/organize_prompt.dart (`sharedRules`); reuse it. `splitSentences`/`computeSpans` in organize.dart do the AI_CONTRACT section 2 span work for buildProposal/reviseProposal too.
- DB-03: `ProposalEngine(db).approve(id)` / `.undoLastApprove(projectId)` and `.snapshots` (SnapshotService create/restore). Approve returns soft-fail notes to show the user; it does not check permission gates (validate before approve). Restore snapshots "Before restore" first, never deletes/changes frame rows, and writes linked characters' sheets back to the global row (user decision 2026-10-15).
- AI-04: `transcribe()` returns text via a one-field JSON schema; chunking is raw byte slices, so recordings over ~14 MB need a container-aware split (ponytail comment in transcribe.dart).
- AI-05: `lib/core/ai/proposals.dart` (buildProposal, reviseProposal, generateProject, detectProjectMention). Callers must pass the AI_CONTRACT §5 context shape (beats[].slot_id, characters[].project_character_id + name, template.slots[].slot_id/seed_id, project.type). Ops failing wordsCheck come back `accepted: false`.
