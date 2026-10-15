# Lynch (Story Organizer) — Plan

**Date:** 2026-10-15 · **Owner:** Abhinav Negi
**Source docs:** `story-organizer-functional-spec.md` (what the app does), `design.md` (how it looks and feels). This plan decides *how it gets built*. When they disagree, the spec wins on behaviour and design.md wins on visuals.

## Problem
Story ideas arrive all day as messy, spoken thoughts and get lost. Turning them into summaries, beats, screenplays and storyboards by hand is slow.

## Users
One person. Runs on **any Android phone or tablet**. The **Samsung S25 Ultra with S Pen** is the main test device. Stylus features add precision on top; everything also works with a finger (D-02).

## Core loop
Speak (or type) → the AI cleans it **in the user's own words** (no added ideas) → it lands in the **Infinite Void** → a story idea is promoted to a **project** → every later input to that project becomes a **proposal** → the user reviews the diff and approves → the project updates and a **history snapshot** is saved.

## Not doing
- AI-written dialogue, AI-invented story content, unrequested critique
- Collaboration or sharing
- Hindi or Hinglish capture
- Laptop or web app
- Any paid backend or server (D-03)
- Keeping original audio

## Stack (all $0 to run)
| Layer | Choice | Decision |
|---|---|---|
| App | Flutter, Material 3 with own design tokens | D-01, D-12 |
| State and routing | Riverpod, go_router | D-08 |
| Database | Drift (SQLite) with FTS5 full-text search; local-first | D-04 |
| Files | App documents folder: stroke JSON per frame, images | D-04 |
| Backup | Zip of DB and files to Google Drive `appDataFolder`; restore on a new phone | D-05 |
| AI | Gemini API free tier, plain HTTP from the phone; every call and prompt lives in one file, `lib/ai/ai.dart` | D-06 |
| Voice | `speech_to_text` (live words, on-device) and `record` (audio), then Gemini transcription; audio deleted after | D-07 |
| Canvas | `Listener` + `CustomPainter` + `perfect_freehand` | D-09 |
| Export | `pdf` + `printing`; Fountain as plain text | D-10 |
| Look | Lucide icons; Literata, Courier Prime and Inter bundled as assets | D-12 |

## Architecture
```
UI (features/*) ──> Riverpod providers ──> Drift DB (source of truth) ──> files folder (strokes, images)
                                    │
                                    └──> ai.dart (only file that calls Gemini)
                                           transcribe · organize · scaffold · remapTemplate · fetchConvert
backup.dart ──> zip(DB + files) ──> Google Drive appDataFolder
```
- The AI never writes project data. It returns a **proposal** (a list of typed change operations such as `addBeat`, `editBeat`, `addCharacter`, `setSummary`). Only the user's Approve action applies it (D-17).
- Per-project AI permissions are checked before every AI call.
- Offline: captures are saved with status `needsAi`. A queue runs the AI calls once the phone is online again.
- Built-in libraries (templates, shots, format rules…) are **data**, not code: seed JSON files in `assets/seed/`, loaded into the DB on first launch (D-14).

## Areas
| # | Area | File |
|---|---|---|
| 1 | Capture | `areas/01-capture.md` |
| 2 | Infinite Void | `areas/02-void.md` |
| 3 | Home and projects | `areas/03-home-projects.md` |
| 4 | Proposals and history | `areas/04-proposals.md` |
| 5 | Beats and templates | `areas/05-beats-templates.md` |
| 6 | Script | `areas/06-script.md` |
| 7 | Storyboard | `areas/07-storyboard.md` |
| 8 | Characters | `areas/08-characters.md` |
| 9 | Character map | `areas/09-character-map.md` |
| 10 | Shot library | `areas/10-shot-library.md` |
| 11 | Export | `areas/11-export.md` |
| 12 | Backup and settings | `areas/12-backup-settings.md` |
| 13 | Built-in libraries (research) | `areas/13-built-in-libraries.md` |

Scope: **all features are MVP** (D-11). The whole v1 gets built; the order below only sets the sequence.

## Build order
0. **Spikes on the S25 Ultra:** S Pen pressure, side button and palm rejection; whether `speech_to_text` and `record` can share the mic; Gemini free-tier limits for audio and Search grounding. See `OPEN-QUESTIONS.md`.
1. **Foundation:** Flutter project, `tokens.dart` and theme, fonts, Drift schema, app shell (top tabs, bottom bar, mic dock), seed loader.
2. **Capture and Void**
3. **Home and projects**
4. **Proposals and history**
5. **Beats and templates**
6. **Script**
7. **Storyboard**
8. **Characters and character map**
9. **Shot library and fetch-from-web**
10. **Backup automation and export.** A manual backup button already exists from phase 2.

**Research R1–R7** (area 13) runs in parallel from phase 1. It only produces data files, so it never conflicts with app code.

## Code layout (target)
```
lib/
  main.dart, router.dart
  theme/tokens.dart, theme.dart
  data/db.dart, seed.dart, backup.dart
  ai/ai.dart
  features/capture/ void/ home/ project/ proposals/ beats/ script/
           storyboard/ characters/ character_map/ shots/ templates/ export/ settings/
assets/fonts/  assets/seed/*.json  assets/seed/images/
```
