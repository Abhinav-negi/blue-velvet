# INDEX — Lynch
Status lives ONLY here. No counts, totals or history notes in this file.
Prefixes: INF, CON, SPK → tasks/infra/ · RES → tasks/research/ · UI, DB, AI → tasks/core/ · CAP, VOID, PROJ, PROP, BEAT, SCR, SB, CHR, MAP, SHOT, SET, EXP → tasks/features/ · QA → tasks/qa/
Task file: tasks/<section>/<ID>-<name>.md
Statuses: TODO · IN-PROGRESS · REVIEW · DONE · BLOCKED · DROPPED   (Note: ≤ 8 words)

| ID | Task | Status | Needs | Wave | Note |
|----|------|--------|-------|------|------|
| INF-01 | Flutter project setup | DONE | - | 1 | |
| CON-01 | Contract: data model | DONE | - | 1 | |
| CON-02 | Contract: seed schemas + validator | DONE | - | 1 | |
| SPK-01 | Spike: S Pen input in Flutter | TODO | - | 1 | Waits for S25 Ultra (S21 FE: no S Pen) |
| SPK-02 | Spike: mic sharing for live words + recording | BLOCKED | - | 1 | Phone not visible to adb yet |
| SPK-03 | Spike: Gemini free tier | DONE | - | 1 | Free RPM/RPD only visible in AI Studio |
| CON-03 | Contract: AI operations | DONE | CON-01 | 2 | |
| RES-01 | Research: story templates | DONE | CON-02 | 2 | Sources mostly Wikipedia; upgrade later |
| RES-02 | Research: shots, camera (size, angle, movement) | DONE | CON-02 | 2 | |
| RES-08 | Research: shots, look (composition, lens, lighting) | DONE | CON-02 | 2 | Some entries weakly sourced |
| RES-03 | Research: screenplay format + Fountain | DONE | CON-02 | 2 | A4 values derived, not cited |
| RES-04 | Research: project-type defaults | DONE | CON-02 | 2 | |
| RES-05 | Research: song structures | DONE | CON-02 | 2 | Wikipedia sources only |
| RES-06 | Research: relationship labels | DONE | CON-02 | 2 | Wikipedia sources only |
| RES-07 | Research: aspect ratios + composition guides | DONE | CON-02 | 2 | |
| UI-01 | Design tokens + theme | DONE | INF-01 | 2 | |
| DB-01 | Drift schema + DAOs | DONE | INF-01, CON-01 | 2 | |
| RES-09 | Research: free-license shot images | DONE | RES-02, RES-08 | 3 | Images for 37 of 80 entries |
| UI-02 | App shell + routes | DONE | UI-01 | 3 | |
| UI-03 | Shared widgets: diff + transcript highlight | DONE | UI-01, CON-03 | 3 | Two alpha literals; token them later |
| DB-02 | Seed loader | DONE | DB-01, CON-02 | 3 | Not yet called at startup |
| DB-03 | Proposal engine + snapshots | DONE | DB-01, CON-03 | 3 | Undo reverts shared character sheets |
| DB-04 | Drive backup/restore service | TODO | DB-01 | 3 | |
| AI-01 | AI client core | DONE | INF-01, DB-01, CON-03 | 3 | |
| SB-02 | Canvas core | TODO | SPK-01, CON-01, UI-01 | 3 | |
| AI-02 | Offline AI queue | DONE | AI-01, DB-01 | 4 | runJob wiring not built yet |
| AI-03 | AI: organize + edit item | DONE | AI-01 | 4 | |
| AI-04 | AI: transcribe audio | BLOCKED | AI-01, SPK-03 | 4 | Merged; live smoke needs voice sample |
| AI-05 | AI: proposals + project generation | BLOCKED | AI-01, DB-03 | 4 | Merged; live smoke hit Gemini 429 |
| AI-06 | AI: scaffold, remap, suggestions | DONE | AI-01 | 4 | Grounding flag may false-positive |
| AI-07 | AI: fetch & convert + shot options | DONE | AI-01, SPK-03, DB-02 | 4 | UI must ask project type |
| CAP-01 | Mic dock + listening sheet | TODO | UI-02, SPK-02 | 4 | |
| VOID-01 | Void grid + item detail | DONE | UI-02, DB-01, UI-03 | 4 | Masonry height estimated from text length |
| PROJ-01 | Home + project list | DONE | UI-02, DB-01 | 4 | Live badge update untested |
| PROJ-04 | Sample project (S5) | DONE | DB-02, DB-03 | 4 | No proposals/history in sample |
| BEAT-04 | Template library screen | DONE | DB-02, UI-02 | 4 | Nothing links to templates route yet |
| SB-03 | Canvas input modes | TODO | SB-02 | 4 | |
| SB-04 | Aspect ratio + composition guides | TODO | SB-02, RES-07 | 4 | |
| SB-05 | Shape assist + ruler | TODO | SB-02 | 4 | |
| SHOT-01 | Shot library browse + detail | DONE | DB-02, UI-02 | 4 | Nothing links to /shots yet |
| SET-01 | Settings + AI permissions | DONE | UI-02, DB-01 | 4 | Defaults moved to core/data/ai_defaults.dart |
| CAP-02 | Recording pipeline (crash-safe) | TODO | CAP-01, AI-04, AI-02 | 5 | |
| VOID-02 | Void filter + search | DONE | VOID-01 | 5 |  |
| VOID-03 | Void edit, change type, merge, AI edit | DONE | VOID-01, AI-03 | 5 | No tag editor; local AiClient provider |
| PROJ-02 | Pre-project → project creation | TODO | PROJ-01, AI-05, DB-03, DB-02 | 5 | |
| PROJ-03 | Project overview | DONE | PROJ-01, DB-03 | 5 | Fields display-only |
| PROP-01 | Proposal review | DONE | UI-03, DB-03, PROJ-01 | 5 | Edit text = summary only |
| BEAT-01 | Beat board | DONE | PROJ-01, DB-02 | 5 | FAB has dark ring; check later |
| SB-06 | Layers + tool pill | TODO | SB-03, SB-04, SB-05 | 5 | |
| CHR-01 | Character sheets + pool | DONE | PROJ-01, DB-01 | 5 | Pool route nested under project |
| SHOT-03 | Shot options + suggestions | DONE | SHOT-01, AI-07 | 5 |  |
| SHOT-04 | Fetch & convert flow | DONE | SHOT-01, BEAT-04, AI-07 | 5 | Beats should link shot-fetch route |
| SET-02 | Backup UI | TODO | DB-04, SET-01 | 5 | |
| CAP-03 | Text input, scope, routing | TODO | CAP-02, AI-03, AI-05 | 6 | |
| VOID-04 | Promote, send, pull, used | TODO | VOID-01, PROJ-02, PROP-01 | 6 | |
| PROP-02 | Ask for changes + provenance | TODO | PROP-01, AI-05 | 6 | |
| PROP-03 | History + undo | DONE | PROP-01 | 6 | History reachable only from review screen |
| BEAT-02 | Beat reorder, split, merge | DONE | BEAT-01 | 6 | Empty-slot drop appends at end |
| SCR-01 | Screenplay editor | DONE | BEAT-01, RES-03 | 6 | No MORE/CONTD or pagination yet |
| SCR-02 | Say/Show script editor | DONE | BEAT-01 | 6 | |
| SB-01 | Frames per beat | DONE | BEAT-01 | 6 | Blank thumbnails until canvas |
| CHR-02 | Character import, link, fork | DONE | CHR-01, BEAT-01 | 6 | No unlink/delete UI yet |
| MAP-01 | Character map | DONE | CHR-01, RES-06 | 6 | Nothing links to character-map yet |
| CAP-04 | Capture from anywhere (S1) | TODO | CAP-03 | 7 | |
| BEAT-03 | Template switch | DONE | BEAT-02, AI-06 | 7 | AI failure falls back silently to unplaced |
| SCR-03 | Scaffolds + suggestions | DONE | SCR-01, SCR-02, AI-06 | 7 | Accept = one-op proposal, auto-approved |
| SCR-04 | Script ↔ board swipe | DONE | SCR-01, SB-01 | 7 | Board page: no stroke thumbnails yet |
| SB-07 | Canvas in frames | TODO | SB-01, SB-06 | 7 | |
| EXP-01 | Fountain export | DONE | SCR-01, RES-03 | 7 | Export route has no entry point yet |
| EXP-02 | Screenplay PDF | DONE | SCR-01, RES-03 | 7 | No MORE/CONTD, title page, scene numbers |
| EXP-04 | Script PDF + story bible | DONE | SCR-02, CHR-01 | 7 | All tiles shown; no beat headings |
| SHOT-02 | Attach shot to frame | TODO | SHOT-01, SB-07 | 8 | |
| EXP-03 | Storyboard PDF | TODO | SB-07 | 8 | |
| QA-01 | End-to-end + accessibility pass | TODO | all features + RES-* | 9 | |
