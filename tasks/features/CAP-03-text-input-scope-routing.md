# CAP-03 — Text input, scope, routing
Needs: CAP-02, AI-03, AI-05     Wave: 6

## Goal
Typed input with the same pipeline, the 'Adding to' scope label (changeable), and global input that names a project → confirm → proposal.

## Read
- docs/ARCHITECTURE.md
- plan/areas/01-capture.md
- docs/AI_CONTRACT.md (detectProjectMention)

## May touch / must not touch
May: lib/features/capture/** · test/features/capture/**
Must not: pubspec.yaml · lib/core/** · lib/router.dart · other lib/features/* folders · docs/ (contracts) · android/

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Widget test: inside a project the scope reads "Adding to: <name>"; on Home "Adding to: Infinite Void"
3. Test (fake AI): a detected project mention asks for confirmation; declining keeps it in the Void

## Rules
None beyond the orchestrator brief.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
