# SCR-03 — Scaffolds + suggestions
Needs: SCR-01, SCR-02, AI-06     Wave: 7

## Goal
Draft a skeleton when a beat is created (if permitted), and structure suggestions on request, shown as suggestions.

## Read
- docs/ARCHITECTURE.md
- plan/areas/06-script.md

## May touch / must not touch
May: lib/features/script/** · test/features/script/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test (fake AI): a new beat gets a scaffold only when the permission is on
3. Widget test: suggestions render with the SuggestedText style and are not saved until accepted

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
