# SHOT-03 — Shot options + suggestions
Needs: SHOT-01, AI-07     Wave: 5

## Goal
Ask 'what shots work for…' and get library entries plus fetched drafts; per-frame suggestions when permitted.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake AI): results show library entries and fetched drafts, clearly marked
3. Test: with Shot suggestions off, no request is made

## Rules
shots/ folder: not in parallel with SHOT-04.

## Evidence
- Added `lib/features/shots/shot_options.dart`: `shotAiProvider` (AiClient, tests override with MockClient), `aiDefaultsProvider` (settings `ai_permission_defaults`), `askShotOptions` (core `shotOptions` + up to 2 `FetchConvert` shot drafts for `wants_fetch`, only when internet_fetch on), `ShotOptionsPanel` (embeddable; takes `frameContext` + project `permissions` for per-frame suggestions), `ShotOptionsScreen`. Entry: sparkle icon in ShotsScreen app bar (Navigator push, router untouched).
- Results are shown only; library = "From your library", drafts = "Fetched draft, not saved" with source URL. Saving is SHOT-04.
- Suggestions off: input and Ask disabled, no request. Library has no project, so it uses global defaults; a frame screen passes its project's `ai_permissions`.
- Gotcha: `shotsProvider` must be watched (not just read) or the library is empty at ask time.
- Tests: test/features/shots/shot_options_test.dart (MockClient; library+draft marked; off = zero requests; core gate denies before I/O).
- Results: flutter analyze clean; flutter test 127 pass; check_boundaries exit 0; Color(0x grep empty. No packages needed.
- Not done: no wiring of a frame screen to the panel (other feature folder); no AI-queue runJob (not wired in core).
- Section note: shots/ now has shot_options.dart; SHOT-04 can reuse `shotAiProvider` and `askShotOptions` drafts (ShotDraft) and call `saveFetchDraft`.
