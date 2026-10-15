# ORCHESTRATOR — Lynch
> Project briefing for the main agent. How to orchestrate lives in the orchestrator skill. Subagents never read this file.
> New session: read this file, then HANDOFF.md, then INDEX.md. Read a section's HANDOFF.md only when entering that section.

## 1. Project
Lynch is a personal, voice-first story organizer for one person (Abhinav) on Android. Spoken ideas are cleaned by AI **in his own words** (never adding ideas or dialogue), land in the Infinite Void, become projects, and every later input is a proposal he reviews and approves, like a GitHub pull request. Projects hold beats/templates, screenplay or Say/Show script, S Pen storyboards, characters, a character map, a shot library, history and exports.
Quality bar: a senior developer's codebase that is easy to update, add to and remove from (D-20); $0 running cost; no data loss; S Pen precision on the S25 Ultra; works on any Android device.
Specs: `story-organizer-functional-spec.md` (behaviour) · `design.md` (visuals) · `plan/` (decisions, areas).

## 2. System map
```
Flutter app (Android, package com.abhinavnegi.lynch, minSdk 26) — repo root
lib/
  main.dart, router.dart        router only concatenates lib/features/*/routes.dart
  core/theme/                   tokens + themes (design.md §4–6)
  core/data/                    Drift SQLite (source of truth), seed loader, proposal engine, snapshots, Drive backup
  core/ai/                      ONLY code that touches the network for AI (Gemini REST, free tier)
  core/widgets/                 shared widgets (shell, DiffView, TranscriptHighlight)
  features/<name>/              one folder per area; imports lib/core only
assets/seed/*.json              built-in libraries (research output) + sample_project.json
assets/seed/images/             free-license shot images
app documents dir (runtime)     stroke JSON per frame, user images; DB file
Google Drive appDataFolder      zip backups (last 3)
spikes/                         throwaway phase-0 apps; never imported by lib/
```
No server, no ports. AI and Drive are the only network calls.

## 3. Hard rules
- **Feature isolation (D-20):** `lib/features/<x>/` imports only `lib/core/**` and itself. Cross-feature navigation uses route names. `bash tool/check_boundaries.sh` must pass.
- **Contracts are the source of truth:** `docs/DATA_MODEL.md`, `docs/AI_CONTRACT.md`, `docs/SEED_SCHEMA.md`. Changing one is a user decision (§6), then a new task.
- **Schema:** all tables exist from DB-01. Any later change = bump Drift `schemaVersion` + migration + migration test. Never drop user data.
- **AI never writes project data (D-17):** AI returns change-ops; only `lib/core/data/proposal_engine` applies them on approve. The AI never writes dialogue or adds ideas.
- **Design tokens only:** no raw hex colours or magic sizes outside `lib/core/theme/`.
- **Reference data is seed JSON, never Dart constants (D-14).**
- **Secrets:** the Gemini key lives in `.env.json` (gitignored; template `.env.json.example`) for dev and in secure storage at runtime. Never print or commit it.
- **Only the orchestrator edits `pubspec.yaml`.** A subagent needing a package reports it in Evidence.
- **Frozen for subagents:** `plan/`, `story-organizer-functional-spec.md`, `design.md`, `ORCHESTRATOR.md`, `INDEX.md`, `HANDOFF.md`.
- Shot images: PD, CC0, CC-BY, CC-BY-SA only; no film stills (D-15).

## 4. Commands
| What | Command |
|---|---|
| Setup | `flutter pub get` |
| Codegen (Drift) | `dart run build_runner build --delete-conflicting-outputs` |
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| Boundary guard | `bash tool/check_boundaries.sh` (created by INF-01) |
| Token guard | `grep -rn 'Color(0x' lib --include=*.dart \| grep -v lib/core/theme` → no output |
| Seed check | `for f in assets/seed/*.json; do dart tool/validate_seed.dart "$f"; done` (created by CON-02) |
| Run on phone | `flutter run --dart-define-from-file=.env.json` |
| Build | `flutter build apk --debug` |
| AI smoke | `dart run tool/ai_smoke.dart <op> <file>` (created by AI-03) |

Toolchain verified 2026-10-15: Flutter 3.47.7 stable, Dart 3.13, Android SDK 36/37, debug APK builds. The project path contains a space ("blue velvet"): always quote paths.

## 5. Budget for this project
- **At the start of every session, ask the user: "Max subagents this session: 2, 4 or 6?"** The answer is a ceiling, not a target. Spawn only as many as there are conflict-free ready tasks.
- Only the orchestrator runs `flutter pub add` / edits `pubspec.yaml`.
- **One physical device:** tasks whose Rules say "Needs the phone" run one at a time, and the user must be told before each one (they may need to hold the phone or the S Pen).
- No scratch ports needed (mobile app, no servers).

## 6. Ask the user before
- Changing a contract in `docs/` or any D-xx decision in `plan/DECISIONS.md`
- Adding a package not in INF-01's list, or any paid service
- A migration that changes or drops existing data
- Changing visual identity (tokens, fonts, palette)
- Deleting user data or seed content
- Anything needing their accounts: Gemini key (before SPK-03), Google OAuth client (before DB-04, see `docs/SETUP_GOOGLE.md`), the phone with USB debugging (SPK-01, SPK-02 and every "Needs the phone" task)

## 7. Current phase
Plan: `plan/OVERVIEW.md` (v1, all areas MVP).

| Wave | Tasks | Parallel? | Notes |
|---|---|---|---|
| 1 | INF-01, CON-01, CON-02, SPK-01, SPK-02, SPK-03 | Yes | SPK-01 and SPK-02 both need the phone: one after the other. SPK-03 needs the Gemini key |
| 2 | CON-03, RES-01..08, UI-01, DB-01 | Yes | RES tasks write separate seed files |
| 3 | RES-09, UI-02, UI-03, DB-02, DB-03, DB-04, AI-01, SB-02 | Yes | UI-02 and UI-03 both write lib/core/widgets (different files). DB-04 and SB-02 need the phone |
| 4 | AI-02..07, CAP-01, VOID-01, PROJ-01, PROJ-04, BEAT-04, SB-03, SB-04, SB-05, SHOT-01, SET-01 | Yes, with limits | AI-* use separate files in lib/core/ai. SB-03/04/05 share the canvas widget: one at a time. CAP-01, SB-03 need the phone |
| 5 | CAP-02, VOID-02, VOID-03, PROJ-02, PROJ-03, PROP-01, BEAT-01, SB-06, CHR-01, SHOT-03, SHOT-04, SET-02 | Yes, with limits | Same folder = one at a time: VOID-02/03, PROJ-02/03, SHOT-03/04 |
| 6 | CAP-03, VOID-04, PROP-02, PROP-03, BEAT-02, SCR-01, SCR-02, SB-01, CHR-02, MAP-01 | Yes, with limits | One at a time: PROP-02/03, SCR-01/02 |
| 7 | CAP-04, BEAT-03, SCR-03, SCR-04, SB-07, EXP-01, EXP-02, EXP-04 | Yes, with limits | EXP-* one at a time; SCR-03/04 one at a time. CAP-04, SB-07 need the phone |
| 8 | SHOT-02, EXP-03 | Yes | |
| 9 | QA-01 | No | Needs the phone; failures become new tasks |

Decisions already made (don't re-ask): everything in `plan/DECISIONS.md` (D-01 … D-20). Highlights: Flutter, Android-any-device; $0, no backend; Drift local-first + Drive backup; Gemini free tier from the phone; hybrid voice; Riverpod + go_router; all features MVP; design D1–D7 and spec A1–A5 accepted; name "Lynch", package `com.abhinavnegi.lynch`.
Open questions are answered by the spikes: `plan/OPEN-QUESTIONS.md`. After each spike, record the answer there (orchestrator only) and, if it changes a decision, ask the user.
