# Core notes
Read before starting work in this folder. Under 15 lines. Delete a note once it's resolved.

- Seed files (docs/SEED_SCHEMA.md) and DB/AI (docs/DATA_MODEL.md, docs/AI_CONTRACT.md) use different names: `short-film` vs `short_film`, `proportion` vs `runtime_proportion`, `source_urls` vs `source_url`/`sources`. DB-02 owns the single mapping function; AI-07 drafts already use DATA_MODEL names.
- AI_CONTRACT: change-ops are one flat object with nullable fields (Gemini has no oneOf); the client validator enforces per-op required fields. fetchConvert = 2 calls (grounded search, then JSON conversion). Confirm against docs/spikes/SPK-03-gemini.md.
