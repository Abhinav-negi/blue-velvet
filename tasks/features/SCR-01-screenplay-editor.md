# SCR-01 — Screenplay editor
Needs: BEAT-01, RES-03     Wave: 6

## Goal
Block-based screenplay editor on paper in Courier Prime: elements, Enter/Tab switching, element chip, no toolbar while writing.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md
- design.md (§8.4)
- assets/seed/screenplay_format.json

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: Enter/Tab transitions follow the element order in plan/areas/06-script.md
3. Widget test: tapping the chip changes the element type
4. Screenshot of a scene in Evidence

## Rules
script/ folder: not in parallel with SCR-02.

## Evidence
- Files: lib/features/script/{screenplay_format,screenplay_editor,script_screen,routes}.dart, test/features/script/script_test.dart + goldens/scene.png (screenshot of a scene, 400 dp).
- Decisions: indents/margins/blank lines/uppercase/names read from assets/seed/screenplay_format.json via rootBundle (ScreenplayFormat). Inches->px scale = page width fit, capped at the font's natural cpi scale (font stays AppType.screenplay, 16). Enter (soft or hard keyboard, detected as a newline in onChanged) creates the next block: scene_heading>action>character>dialogue>parenthetical, then parenthetical>dialogue, transition>scene_heading. Tab turns the current block into the next type (wraps over the 6 types). Backspace on an empty block deletes it. Chip in left margin opens a bottom sheet of types. Every edit writes beats.blocks at once; editor reads the beat only in initState (keyed by beat id). Editing clears the AI style flag; saved blocks have scaffold/ai_suggested false.
- ScriptScreen now takes projectId (routes.dart passes it), keeps the "Script" heading, picks a beat with chips. It reads beats via db.beatsDao (cannot import features/beats). SCR-02: switch on project type in ScriptScreen (marked with a comment).
- Gotchas: on a 400 dp phone the transition column (1.5 in) wraps "CUT TO:"; uppercase types are upper-cased on typing and when the type changes. Widget test: seed asset load needs `container.read(screenplayFormatProvider.future)` inside runAsync.
- Results: flutter analyze clean; boundaries exit 0; no raw Color(0x outside core/theme; flutter test: 141 pass, 2 fail = test/core/shell/app_shell_test.dart 400/800 goldens (expected, regenerated goldens uncommitted on master). Packages: none needed (uuid already present).
- Left: scaffold/ai_suggested blocks have only the italic style (no amber rule); AI suggestions, MORE/CONT'D, pagination not built.
- Section note: ScriptScreen(projectId) is the switch point for SCR-02; screenplay code lives in screenplay_*.dart.
