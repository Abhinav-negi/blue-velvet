# SCR-02 — Say/Show script editor
Needs: BEAT-01     Wave: 6

## Goal
Two-column Say/Show script for YouTube and Shorts beats.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md
- story-organizer-functional-spec.md (§6.1)

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: adding a row creates Say and Show cells that persist
3. Widget test: a film project shows the screenplay editor, a YouTube project shows Say/Show

## Rules
script/ folder: not in parallel with SCR-01.

## Evidence
- Decisions: `say_show_editor.dart` = one card per row, Say field left, 4 Show fields (A-roll, B-roll, On-screen text, Graphics) right; every keystroke/add/delete writes the whole `beats.say_show` list. Edit clears the row's AI flag; rows with scaffold/ai_suggested show in proposal (italic) style. `script_screen.dart` reads the project via `projectsDao.byId` and picks Say/Show for youtube/short, screenplay otherwise (renders nothing until the type loads).
- Follow-up (a): the black boxes were the "Script" heading (not beat chips; one beat shows no chip row). Test used bare `ThemeData`, so titleLarge fell back to Ahem. Fix: script tests use `AppTheme.light`. Golden regenerated and checked.
- Follow-up (b): CUT TO: wrapped because transition text area is only 1.5 in (~70 px at 400 dp) vs 7 chars of 16 px Courier. Right-aligned elements now drop their left indent (alignment keeps the look). Golden checked: one line.
- Tests: say_show_test.dart (add row persists Say+Show; youtube shows Say/Show; film shows screenplay); SCR-01 tests kept.
- Commands: flutter analyze: No issues; flutter test: 152 pass, 2 fail (shell goldens, expected); check_boundaries exit 0; Color(0x grep empty.
- Dependencies needed: none.
- Section note: Say/Show lives in features/script/say_show_editor.dart; script tests should use AppTheme.light (bare ThemeData renders Ahem boxes). Right-aligned screenplay elements ignore left indent.
- Left: nothing. No Say/Show golden or scaffold/suggestion UI.
