# Lynch

Flutter (Android) app that turns spoken story ideas into organised projects. See `plan/` for the plan and `docs/ARCHITECTURE.md` for the code layout.

## Run
Copy `.env.json.example` to `.env.json`, add your Gemini key, then:
```
flutter pub get
flutter run --dart-define-from-file=.env.json
```
Check module boundaries: `bash tool/check_boundaries.sh`.
