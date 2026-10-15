# DB-04 — Drive backup/restore service
Needs: DB-01     Wave: 3

## Goal
Zip the database and files folder, upload to the user's Google Drive appDataFolder (keep last 3), and restore by downloading and replacing local data.

## Read
- docs/ARCHITECTURE.md
- plan/areas/12-backup-settings.md
- plan/DECISIONS.md (D-05)

## May touch / must not touch
May: lib/core/data/backup* · test/core/data/backup* · docs/SETUP_GOOGLE.md · android/app/ (Google sign-in config only)
Must not: lib/features/ · pubspec.yaml

## Done when
1. `flutter analyze` → No issues found; `flutter test` → all pass; `bash tool/check_boundaries.sh` → exit 0
2. Test: zip → unzip round trip of a temp DB + files folder is byte-identical
3. Test (fake Drive client): upload keeps only the newest 3 backups
4. docs/SETUP_GOOGLE.md gives the user step-by-step OAuth client setup (package ID + SHA-1)
5. On device: backup → clear app data → sign in → restore → a known void item and a frame drawing are back (screenshots in Evidence)

## Rules
Needs the phone: tell the orchestrator before using it (one device task at a time). The user must create the OAuth client from docs/SETUP_GOOGLE.md first; ask the orchestrator to involve them.

## Evidence
(Filled by the subagent: decisions + why · gotchas · commands run + results · what's left.)
