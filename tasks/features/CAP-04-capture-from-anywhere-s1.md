# CAP-04 — Capture from anywhere (S1)
Needs: CAP-03     Wave: 7

## Goal
Quick Settings tile, app-icon shortcut "Record idea" and Android share-to-Lynch for text.

## Read
- docs/ARCHITECTURE.md
- plan/areas/01-capture.md

## May touch / must not touch
May: lib/features/capture/** · test/features/capture/** · android/app/src/main/ (tile, shortcut, intent filter only)
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: the shortcut and share handlers route to capture with the right scope and prefilled text
3. On device: screenshots of the tile, the shortcut and the share sheet entry, each opening capture

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time). The tile needs a small Kotlin TileService in android/.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
