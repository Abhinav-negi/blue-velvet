# INDEX — Lynch
Status lives ONLY here. No counts, totals or history notes in this file.
Prefixes: INF, CON, SPK → tasks/infra/ · RES → tasks/research/ · UI, DB, AI → tasks/core/ · CAP, VOID, PROJ, PROP, BEAT, SCR, SB, CHR, MAP, SHOT, SET, EXP → tasks/features/ · QA → tasks/qa/
Task file: tasks/<section>/<ID>-<name>.md
Statuses: TODO · IN-PROGRESS · REVIEW · DONE · BLOCKED · DROPPED   (Note: ≤ 8 words)

| ID | Task | Status | Needs | Wave | Note |
|----|------|--------|-------|------|------|
| INF-01 | Flutter project setup | IN-PROGRESS | - | 1 | main folder |
| CON-01 | Contract: data model | DONE | - | 1 | |
| CON-02 | Contract: seed schemas + validator | DONE | - | 1 | |
| SPK-01 | Spike: S Pen input in Flutter | TODO | - | 1 | Waits for S25 Ultra (S21 FE: no S Pen) |
| SPK-02 | Spike: mic sharing for live words + recording | TODO | - | 1 | |
| SPK-03 | Spike: Gemini free tier | IN-PROGRESS | - | 1 | main folder |
| CON-03 | Contract: AI operations | DONE | CON-01 | 2 | |
| RES-01 | Research: story templates | DONE | CON-02 | 2 | Sources mostly Wikipedia; upgrade later |
| RES-02 | Research: shots, camera (size, angle, movement) | DONE | CON-02 | 2 | |
| RES-08 | Research: shots, look (composition, lens, lighting) | DONE | CON-02 | 2 | Some entries weakly sourced |
| RES-03 | Research: screenplay format + Fountain | DONE | CON-02 | 2 | A4 values derived, not cited |
| RES-04 | Research: project-type defaults | IN-PROGRESS | CON-02 | 2 | main folder |
| RES-05 | Research: song structures | TODO | CON-02 | 2 | |
| RES-06 | Research: relationship labels | TODO | CON-02 | 2 | |
| RES-07 | Research: aspect ratios + composition guides | TODO | CON-02 | 2 | |
| UI-01 | Design tokens + theme | TODO | INF-01 | 2 | |
| DB-01 | Drift schema + DAOs | TODO | INF-01, CON-01 | 2 | |
| RES-09 | Research: free-license shot images | IN-PROGRESS | RES-02, RES-08 | 3 | main folder |
| UI-02 | App shell + routes | TODO | UI-01 | 3 | |
| UI-03 | Shared widgets: diff + transcript highlight | TODO | UI-01, CON-03 | 3 | |
| DB-02 | Seed loader | TODO | DB-01, CON-02 | 3 | |
| DB-03 | Proposal engine + snapshots | TODO | DB-01, CON-03 | 3 | |
| DB-04 | Drive backup/restore service | TODO | DB-01 | 3 | |
| AI-01 | AI client core | TODO | INF-01, DB-01, CON-03 | 3 | |
| SB-02 | Canvas core | TODO | SPK-01, CON-01, UI-01 | 3 | |
| AI-02 | Offline AI queue | TODO | AI-01, DB-01 | 4 | |
| AI-03 | AI: organize + edit item | TODO | AI-01 | 4 | |
| AI-04 | AI: transcribe audio | TODO | AI-01, SPK-03 | 4 | |
| AI-05 | AI: proposals + project generation | TODO | AI-01, DB-03 | 4 | |
| AI-06 | AI: scaffold, remap, suggestions | TODO | AI-01 | 4 | |
| AI-07 | AI: fetch & convert + shot options | TODO | AI-01, SPK-03, DB-02 | 4 | |
| CAP-01 | Mic dock + listening sheet | TODO | UI-02, SPK-02 | 4 | |
| VOID-01 | Void grid + item detail | TODO | UI-02, DB-01, UI-03 | 4 | |
| PROJ-01 | Home + project list | TODO | UI-02, DB-01 | 4 | |
| PROJ-04 | Sample project (S5) | TODO | DB-02, DB-03 | 4 | |
| BEAT-04 | Template library screen | TODO | DB-02, UI-02 | 4 | |
| SB-03 | Canvas input modes | TODO | SB-02 | 4 | |
| SB-04 | Aspect ratio + composition guides | TODO | SB-02, RES-07 | 4 | |
| SB-05 | Shape assist + ruler | TODO | SB-02 | 4 | |
| SHOT-01 | Shot library browse + detail | TODO | DB-02, UI-02 | 4 | |
| SET-01 | Settings + AI permissions | TODO | UI-02, DB-01 | 4 | |
| CAP-02 | Recording pipeline (crash-safe) | TODO | CAP-01, AI-04, AI-02 | 5 | |
| VOID-02 | Void filter + search | TODO | VOID-01 | 5 | |
| VOID-03 | Void edit, change type, merge, AI edit | TODO | VOID-01, AI-03 | 5 | |
| PROJ-02 | Pre-project → project creation | TODO | PROJ-01, AI-05, DB-03, DB-02 | 5 | |
| PROJ-03 | Project overview | TODO | PROJ-01, DB-03 | 5 | |
| PROP-01 | Proposal review | TODO | UI-03, DB-03, PROJ-01 | 5 | |
| BEAT-01 | Beat board | TODO | PROJ-01, DB-02 | 5 | |
| SB-06 | Layers + tool pill | TODO | SB-03, SB-04, SB-05 | 5 | |
| CHR-01 | Character sheets + pool | TODO | PROJ-01, DB-01 | 5 | |
| SHOT-03 | Shot options + suggestions | TODO | SHOT-01, AI-07 | 5 | |
| SHOT-04 | Fetch & convert flow | TODO | SHOT-01, BEAT-04, AI-07 | 5 | |
| SET-02 | Backup UI | TODO | DB-04, SET-01 | 5 | |
| CAP-03 | Text input, scope, routing | TODO | CAP-02, AI-03, AI-05 | 6 | |
| VOID-04 | Promote, send, pull, used | TODO | VOID-01, PROJ-02, PROP-01 | 6 | |
| PROP-02 | Ask for changes + provenance | TODO | PROP-01, AI-05 | 6 | |
| PROP-03 | History + undo | TODO | PROP-01 | 6 | |
| BEAT-02 | Beat reorder, split, merge | TODO | BEAT-01 | 6 | |
| SCR-01 | Screenplay editor | TODO | BEAT-01, RES-03 | 6 | |
| SCR-02 | Say/Show script editor | TODO | BEAT-01 | 6 | |
| SB-01 | Frames per beat | TODO | BEAT-01 | 6 | |
| CHR-02 | Character import, link, fork | TODO | CHR-01, BEAT-01 | 6 | |
| MAP-01 | Character map | TODO | CHR-01, RES-06 | 6 | |
| CAP-04 | Capture from anywhere (S1) | TODO | CAP-03 | 7 | |
| BEAT-03 | Template switch | TODO | BEAT-02, AI-06 | 7 | |
| SCR-03 | Scaffolds + suggestions | TODO | SCR-01, SCR-02, AI-06 | 7 | |
| SCR-04 | Script ↔ board swipe | TODO | SCR-01, SB-01 | 7 | |
| SB-07 | Canvas in frames | TODO | SB-01, SB-06 | 7 | |
| EXP-01 | Fountain export | TODO | SCR-01, RES-03 | 7 | |
| EXP-02 | Screenplay PDF | TODO | SCR-01, RES-03 | 7 | |
| EXP-04 | Script PDF + story bible | TODO | SCR-02, CHR-01 | 7 | |
| SHOT-02 | Attach shot to frame | TODO | SHOT-01, SB-07 | 8 | |
| EXP-03 | Storyboard PDF | TODO | SB-07 | 8 | |
| QA-01 | End-to-end + accessibility pass | TODO | all features + RES-* | 9 | |
