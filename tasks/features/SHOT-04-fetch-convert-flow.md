# SHOT-04 — Fetch & convert flow
Needs: SHOT-01, BEAT-04, AI-07     Wave: 5

## Goal
Ask for a template or shot from the web, see a preview with sources, save to the library only on approval.

## Read
- docs/ARCHITECTURE.md
- plan/areas/10-shot-library.md
- story-organizer-functional-spec.md (§15.4)

## May touch / must not touch
May: lib/features/shots/** · test/features/shots/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test (fake AI): the preview shows sources; Save adds it to the library; Cancel adds nothing
3. Widget test: a cannotConvert result shows an explanation, nothing saved
4. Test: with Internet fetch off, the action is disabled

## Rules
shots/ folder: not in parallel with SHOT-03.

## Evidence
- Added `lib/features/shots/fetch_screen.dart` (FetchScreen): request, optional pasted URL, kind chips (Either/template/shot), project-type chips (the user's pick overrides the model's project_types on a template at save). Fetch -> preview (name, description, slots/shot fields, sources) -> Save (core `saveFetchDraft`, user row with source URLs) or Cancel (nothing written). CannotConvert shows the reason. Fetch disabled and no request when internet_fetch off. Route `shot-fetch` (/shots/fetch) in routes.dart; icon button in the shots library app bar.
- Tests: test/features/shots/fetch_screen_test.dart (MockClient fake AI): sources + Save, Cancel, cannotConvert, fetch off. SHOT-03 suggestion tiles are unchanged (no Save there).
- Results: flutter analyze clean; flutter test 151 pass, 2 expected shell failures (app_shell_test 400/800); check_boundaries exit 0; Color(0x grep empty. No new packages.
- Section note: template library (beats) should link to `goNamed('shot-fetch')` for fetching templates; I did not edit beats. Templates fetched here save via `saveFetchDraft`.
