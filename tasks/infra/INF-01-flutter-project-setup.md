# INF-01 — Flutter project setup
Needs: -     Wave: 1

## Goal
Create the Flutter app "Lynch" at the repo root with every package the plan needs, the folder skeleton, bundled fonts, the architecture doc and git. After this, every later task adds code without touching project config.

## Read
- plan/OVERVIEW.md
- plan/DECISIONS.md
- design.md (§6, §14)

## May touch / must not touch
May: pubspec.yaml · analysis_options.yaml · android/ · lib/main.dart · lib/core/ · lib/features/ (empty folders) · assets/fonts/ · assets/seed/ (empty) · test/ · tool/check_boundaries.sh · docs/ARCHITECTURE.md · README.md · .gitignore
Must not: plan/ · tasks/ · story-organizer-functional-spec.md · design.md · ORCHESTRATOR.md · INDEX.md · HANDOFF.md

## Done when
1. `flutter analyze` → No issues found; `flutter build apk --debug` → Built
2. `grep -E 'applicationId|minSdk' android/app/build.gradle*` shows `com.abhinavnegi.lynch` and 26; app label is "Lynch"
3. `flutter pub deps --style=list` includes every package in Rules; fonts Literata (400, 500, 400 italic), Courier Prime 400, Inter (400, 500) are in assets/fonts and declared in pubspec.yaml
4. docs/ARCHITECTURE.md exists with: folder layout, the import rule (features import only lib/core), "add a feature" and "remove a feature" recipes, migration rule; `bash tool/check_boundaries.sh` → exit 0 and fails on a planted cross-feature import
5. `.gitignore` contains `.env.json`; `git log --oneline` shows an initial commit

## Rules
Create with `flutter create --project-name lynch --org com.abhinavnegi --platforms android .` (the path contains a space: quote it). Packages: flutter_riverpod, go_router, drift, drift_flutter, path_provider, path, http, flutter_secure_storage, speech_to_text, record, perfect_freehand, pdf, printing, share_plus, google_sign_in, googleapis, extension_google_sign_in_as_googleapis_auth, archive, connectivity_plus, receive_sharing_intent, quick_actions, image_picker, uuid, a maintained Lucide icon package; dev: build_runner, drift_dev, flutter_lints. Fonts from Google Fonts with their OFL license files. Skeleton: lib/core/{theme,data,ai,widgets}/, lib/features/{capture,void,home,proposals,beats,script,storyboard,characters,character_map,shots,settings,export}/. Write `.env.json.example` with `{"GEMINI_API_KEY": ""}`.

## Evidence
Decisions
- Lucide package: lucide_icons_flutter (maintained). Fonts: Literata and Inter are Google variable fonts; one file declared for weights 400 and 500 (Flutter drives the wght axis). Courier Prime is static. Font family name in pubspec: `CourierPrime`. OFL.txt files sit beside the fonts.
- android/app/build.gradle.kts: minSdk = 26, compileSdk = 37 (receive_sharing_intent 1.9.0 requires 37; SDK 37.0 is installed). Label "Lynch".
- .gitignore: flutter create left it untouched, so Flutter defaults were appended by hand next to `.env.json`.
- lib/main.dart is a minimal ProviderScope + MaterialApp placeholder; test/widget_test.dart smoke test passes. Empty folders hold `.gitkeep`.
Gotchas
- First build failed on compileSdk 36 (see above). Gradle first build ~7 min.
- `flutter analyze` at repo root also scans others' spikes/ and tool/ files (avoid_print infos in spikes/gemini): not mine. `flutter analyze lib test` is clean; the root run is clean once spikes/ lints are fixed or excluded.
- check_boundaries.sh resolves relative imports with realpath, so `../home/x.dart` is caught.
Results
- flutter test: pass. flutter build apk --debug: Built build/app/outputs/flutter-apk/app-debug.apk. check_boundaries: rc 0; planted package: and relative cross-feature imports -> rc 1 (removed). git check-ignore .env.json -> .env.json. 26 required packages present in pub deps.
Left: nothing for INF-01.
