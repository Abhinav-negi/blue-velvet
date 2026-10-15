# AI-03 — AI: organize + edit item
Needs: AI-01     Wave: 4

## Goal
Turn a transcript into a Void item draft (type, summary, structure, tags, spans), and edit an item by instruction, both following the 'your words' rules.

## Read
- docs/ARCHITECTURE.md
- docs/AI_CONTRACT.md (organize, editItem)
- assets/seed/song_structures.json (if present)

## May touch / must not touch
May: lib/core/ai/organize.dart · lib/core/ai/prompts/organize* · lib/core/ai/words_check.dart · test/core/ai/organize* · test/fixtures/ai/** · tool/ai_smoke.dart
Must not: lib/features/ · other lib/core/ai files · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: recorded response fixtures for each of the 7 item types parse into drafts
3. Test: `wordsCheck(summary, transcript)` flags a capitalised name in the summary that is absent from the transcript, and passes a clean one
4. `dart run tool/ai_smoke.dart organize test/fixtures/transcripts/playground.txt` (live key) prints a draft; output and wordsCheck result in Evidence

## Rules
None beyond the orchestrator brief.

## Evidence
Decisions
- `organize(ai, raw, {grammarCleanup})` and `editItem(ai, ...)` in lib/core/ai/organize.dart; both return `ItemDraft` (type, summary, spans, structure, tags) / `ItemEdit` (patch or cannot_do note). editItem covers the void_item target only; the schema omits `changes` (project scope belongs to the proposal tasks).
- Validation failure (bad type, dialogue/lyric text not found in the transcript, malformed sentences) retries once with a "broke rule N" note, then throws AiMalformedResponse (AI_CONTRACT 9.3). Sentence-count mismatch keeps the summary and drops spans (2.1).
- Offsets are computed client side from `source_quotes` (exact, then normalised match; unlocatable quotes dropped).
- `wordsCheck(output, input)` (words_check.dart) returns the ungrounded specifics: numbers/number words (digit<->word tolerant to 20), capitalised words not at sentence start, quoted strings; plural/possessive tolerant. Empty list = clean.
- SHARED_RULES lives in lib/core/ai/prompts/organize_prompt.dart (no shared file was in my allowed set); other AI tasks may need to import or copy it.
- Schema types are uppercase (OBJECT/STRING) like the existing client test.
Gotchas
- AI_CONTRACT's splitSentences splits after `."` + space, so a summary sentence holding two quoted lines counts as 2. Fixtures keep one quote per sentence.
- Live model chose scene_fragment for the playground transcript and emitted `characters: []` (it left the names out, per rule 7).
Commands / results
- flutter analyze: No issues found. flutter test: all pass (50). bash tool/check_boundaries.sh: exit 0. grep -rln "package:http" lib: only lib/core/ai/ai_client.dart.
- Live (1 call): `dart run tool/ai_smoke.dart organize test/fixtures/transcripts/playground.txt` printed type scene_fragment, summary "An eight years old kid finds a rusty key in the sandbox at the playground. The watchman, the old guy who never sleeps, sees him. The key opens something in the early morning.", 4 spans (substrings: "kid, like eight years old, and he finds a rusty key in the sandbox at the playground.", "the watchman, the old guy who never sleeps, he sees him.", "the key opens something", "it's early morning."), tags kid/key/sandbox/playground/watchman. wordsCheck: clean.
Done-when: 1 PASS, 2 PASS (7 fixtures in test/fixtures/ai/organize), 3 PASS, 4 PASS.
Left: nothing. Note: summary says "early morning" but the speaker self-corrected from night, which is faithful; "An eight years old kid" is slightly ungrammatical (grammar cleanup was off).
