# Core notes
Read before starting work in this folder. Under 15 lines. Delete a note once it's resolved.

- Seed files (docs/SEED_SCHEMA.md) and DB/AI (docs/DATA_MODEL.md, docs/AI_CONTRACT.md) use different names: `short-film` vs `short_film`, `proportion` vs `runtime_proportion`, `source_urls` vs `source_url`/`sources`. DB-02 owns the single mapping function; AI-07 drafts already use DATA_MODEL names.
- AI_CONTRACT: change-ops are one flat object with nullable fields (Gemini has no oneOf); the client validator enforces per-op required fields. fetchConvert = 2 calls (grounded search, then JSON conversion). Confirm against docs/spikes/SPK-03-gemini.md.
- UI-01: AppTheme (lib/core/theme/app_theme.dart) is NOT yet applied in lib/main.dart; UI-02 applies it. Light-theme accent contrast not yet measured.
- SPK-03 (docs/spikes/SPK-03-gemini.md): use model `gemini-3.5-flash` (one constant); 3.x Flash often returns 503 → retry 503/429 with backoff (≈5 s steps, 4 tries). Calls take 1–3 min (thinking tokens). Spans: say "character offsets into the returned transcript" explicitly in prompts.
- D-21: no Search grounding on free tier. fetchConvert = app-side search (Wikipedia/Commons, optional Brave key, pasted URLs) + one Gemini conversion call. AI_CONTRACT §4.11 updated.
- DB-02 done: `SeedLoader(db).load()` (lib/core/data/seed_loader.dart) is not yet called anywhere; call it once after DB open at startup. Name mapping lives only in seed_mapping.dart.
