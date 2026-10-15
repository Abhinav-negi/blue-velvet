# UI-01 — Design tokens + theme
Needs: INF-01     Wave: 2

## Goal
Turn design.md §4–§6 and §13 into code: spacing, sizes, radii, colours, type scale, motion, dark and light themes, and theme extensions for paper, diff and mic colours.

## Read
- docs/ARCHITECTURE.md
- design.md (§4, §5, §6, §9, §13, §14)

## May touch / must not touch
May: lib/core/theme/** · test/core/theme/**
Must not: everything else

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. test/core/theme/theme_test.dart asserts every colour token equals its design.md hex, and the dark and light ThemeData build
3. `grep -rn 'Color(0x' lib --include=*.dart | grep -v lib/core/theme` → no output
4. Text styles use the bundled fonts; `useMaterial3: true`; dynamic colour off

## Rules
Token names follow design.md (e.g. AppSpace.s2 = 16). No widgets other than a debug token-preview screen.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
