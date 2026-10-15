# Decisions

## D-01 — Build with Flutter (2026-10-15)
Chose: Flutter.
Over: native Kotlin (Android only, no future iOS/web path); React Native.
Why: The owner's chosen tool. One codebase keeps iOS and web possible later, and Flutter's Material base matches the 8-point grid in design.md.
Revisit if: the S Pen canvas can't reach the needed precision in Flutter.

## D-02 — Any Android device; S25 Ultra is the primary test device (2026-10-15)
Chose: support any Android phone or tablet. Stylus features turn on when a stylus is present; finger mode always works.
Over: S25 Ultra only; Android + iOS.
Why: The app should work on whatever device the owner has. S Pen is Android-only, and iOS testing needs a Mac and a paid account.
Revisit if: iOS becomes a goal.

## D-03 — $0 running cost, no backend, learning-first (2026-10-15)
Chose: no server, no paid cloud services.
Over: Firebase (Functions and Storage now need the paid Blaze plan); Supabase (no built-in offline sync).
Why: The owner wants to build it without spending money and to learn fundamentals by building them.
Revisit if: a laptop/web companion is built (needs sync between devices).

## D-04 — Local-first database: Drift (SQLite) (2026-10-15)
Chose: SQLite on the device as the single source of truth, through Drift; FTS5 for search; files folder for strokes and images.
Over: Firestore (needs a backend account); Hive/Isar (weaker querying).
Why: Offline works by design, it's free, search is built in, and it teaches real SQL and data modelling.
Revisit if: multi-device sync is needed.

## D-05 — Backup to Google Drive appDataFolder (2026-10-15)
Chose: zip of the DB and files, uploaded to the user's Drive `appDataFolder`; restore on a new phone.
Over: no backup (violates "no data loss"); a paid cloud store.
Why: Free, private and uses the user's own Google account. Meets spec principle 7.
Revisit if: backups grow past Drive quota or need per-item sync.

## D-06 — AI: Gemini API free tier, called directly from the phone (2026-10-15)
Chose: Gemini API free tier over plain HTTP. All AI calls and prompts in one file, `lib/ai/ai.dart`.
Over: Claude API (pay per use, no audio input); using a Claude Pro / Claude Code subscription (not API access, and not allowed by its terms).
Why: $0, handles audio transcription too, and one file keeps a later provider switch small. An API key on the device is acceptable for a single-user personal app; it must never be committed to git.
Revisit if: free-tier limits are too low, the quality of "your words only" cleaning is poor, or the free-tier data-use terms are unacceptable.

## D-07 — Hybrid voice (2026-10-15)
Chose: `speech_to_text` for live on-device words while speaking, plus `record` for audio sent to Gemini for the final transcript. Audio is deleted after transcription.
Over: on-device only (weaker on Indian-accented English and long rambles); cloud only (no live feedback).
Why: Live words build trust that the app is listening; the cloud pass gives accuracy. Spec §4.1 forbids keeping audio.
Revisit if: Android won't let both packages use the mic at once (fallback in OPEN-QUESTIONS).

## D-08 — Riverpod and go_router (2026-10-15)
Chose: Riverpod for state, go_router for navigation.
Over: Bloc (more boilerplate), Provider (older), Navigator 2.0 by hand.
Why: Common defaults with good docs, testable, and they handle nested project tabs well.
Revisit if: a clear pain point appears.

## D-09 — Custom drawing canvas (2026-10-15)
Chose: `Listener` + `CustomPainter` with `perfect_freehand` for pressure strokes; strokes stored as data.
Over: ready-made drawing packages (less control over stylus input and storage format).
Why: Precision is a hard requirement, and strokes must stay editable (spec §17). Raw pointer events expose pressure, stylus kind and buttons.
Revisit if: performance on long strokes is poor.

## D-10 — Export with pdf/printing; Fountain as plain text (2026-10-15)
Chose: `pdf` + `printing` packages with bundled fonts; Fountain written as text.
Over: server-side rendering (no backend, D-03).
Why: Works offline and is free.
Revisit if: PDF screenplay formatting can't match industry layout.

## D-11 — Full v1 scope, built in dependency order (2026-10-15)
Chose: every feature in the functional spec is MVP; all 13 areas are built.
Over: a small MVP first with the rest marked Later.
Why: The owner wants the complete app. The build order (OVERVIEW) only sequences the work so shared foundations come first.
Revisit if: progress stalls; then cut back to the core loop.

## D-12 — Design decisions D1–D7 accepted as proposed (2026-10-15)
Chose: Darkroom frame + Paper surfaces; Literata, Courier Prime, Inter; top tab row with the mic owning bottom centre; Lucide icons; AI-suggested text in Literata italic with an amber rule; paper canvas in both themes; dark theme by default.
Over: the alternatives listed in design.md §15.
Why: The owner accepted the designer's proposals.
Revisit if: on-device testing shows a problem.

## D-13 — Spec assumptions A1–A5 accepted (2026-10-15)
Chose: version history is in; shape assist = hold-to-snap; project-type defaults to be research-checked (R4); personal-management module is future; imported characters are linked by default with a fork option.
Over: n/a.
Why: The owner confirmed them.
Revisit if: n/a.

## D-14 — Built-in libraries are seed data produced by research tasks (2026-10-15)
Chose: research tasks R1–R7 write `assets/seed/*.json` with sources; the app loads them on first launch.
Over: hard-coding reference data in Dart; shipping empty libraries.
Why: Spec principle 5 ("dynamic, not hard-coded"); the owner wants everything available on day one; research runs in parallel with app code.
Revisit if: seed data needs updating after install (add a seed version and merge step).

## D-15 — Shot reference images: free-license only, text fallback (2026-10-15)
Chose: Wikimedia Commons public-domain / Creative Commons images, with license, author and source recorded; text-only entries where no good image exists.
Over: text only (bare on day one); copyrighted film stills (can't ship in an app, especially open source).
Why: Rich on day one and legal, including for a future open-source release.
Revisit if: the app size grows too large; then download images on first run instead of bundling.

## D-16 — UX additions S1–S5 accepted (2026-10-15)
Chose: S1 capture from anywhere (Quick Settings tile, app shortcut, share menu); S2 crash-safe recording; S3 undo after approve; S4 "where did this come from" transcript highlighting; S5 sample project on first launch.
Over: leaving them out.
Why: They make capture faster and safer, and S4 makes "your words rule" checkable in one tap.
Revisit if: S4's AI output format proves unreliable.

## D-17 — AI never writes project data directly (2026-10-15)
Chose: AI output is always a proposal (typed change operations). Only the user's Approve applies it.
Over: AI editing data with a UI confirmation.
Why: Enforces "nothing changes without you" in the data flow, so a UI bug can't bypass review.
Revisit if: n/a.

## D-18 — Defaults for the spec's open questions (2026-10-15)
Chose: storyboard has sketch + clean layers only; no animatic playback; Void items link only to projects; proposals may only append to screenplay text the user wrote.
Over: full layers; animatic; Void-to-Void links; proposals editing written text.
Why: The simplest options that keep the user's words untouched.
Revisit if: the owner wants any of these after using v1.

## D-19 — App name "Lynch", package ID com.abhinavnegi.lynch (2026-10-15)
Chose: display name "Lynch"; Android package ID `com.abhinavnegi.lynch`.
Over: "Story Organizer"; `com.abhinav.lynch`; `dev.abhinavnegi.lynch`.
Why: Owner's choice. The package ID is permanent once published, and the owner's full name keeps it unique.
Revisit if: never after first publish.

## D-20 — Built for easy change: feature isolation (2026-10-15)
Chose: each feature lives in `lib/features/<name>/` and imports only `lib/core/**`, never another feature. Routes come from each feature's own `routes.dart`. All tables are declared up front and changed only through versioned Drift migrations with a test. Reference data lives only in seed JSON. Contracts in `docs/` are the source of truth.
Over: free-form structure.
Why: The owner wants to add, remove and update features easily. Removing a feature = delete its folder + one line in `lib/router.dart`.
Revisit if: two features genuinely need to share code; then that code moves to `lib/core/`.

## D-21 — Web fetch: the app searches free sources itself; Gemini only converts (2026-10-15)
Chose: the app gathers source text itself from the Wikipedia and Wikimedia Commons APIs (free, no key), an optional free Brave Search API key for general web search, and any link the user pastes or shares. One Gemini call then converts that text into a template or shot entry.
Over: enabling Gemini billing for Google Search grounding (breaks D-03); dropping web fetch.
Why: SPK-03 found that Search grounding is not available on the free tier. The owner wants the app to search for itself.
Revisit if: billing is enabled later; then grounding can replace step 1.

## D-22 — Gemini free-tier data use accepted for now (2026-10-15)
Chose: stay on the free tier, accepting that Google may use inputs to improve its products and human reviewers may read them.
Over: enabling billing now.
Why: Owner's choice; $0 matters more for now. Switching is an AI Studio setting with no code change.
Revisit if: the owner starts capturing ideas they want kept private.
