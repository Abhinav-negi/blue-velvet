# Story Organizer — Design Principles and Concept

**Version:** 0.1 (draft for review)
**Date:** 15 Oct 2026
**Owner:** Abhinav Negi
**Companion docs:** `story-organizer-functional-spec.md` (what the app does). This file covers how it looks, feels and behaves on screen.
**Status:** Nothing in this file is final until you approve it. Section 15 lists the decisions waiting on you.

---

## 0. How to read this document

Every rule here has a **reason** next to it. If you disagree with a reason, the rule should change. Rules marked **[Proposal]** are my design calls and have not been agreed yet. Everything else follows from things you have already said: voice-first, organizer not writer, GitHub-style review, S Pen storyboarding, Flutter mobile-first.

---

## 1. The designer's stance

### 1.1 Steal like an artist

There is nothing new here, only good things combined well. No single app is a voice-first story organizer with storyboards and a review flow. But each part of that idea has already been solved well by some app. Our job is to:

1. Find the app that solved each part best.
2. Take the **principle**, not the pixels. We steal the idea and redraw it in our own visual language.
3. Combine them so the whole thing feels like one app, not a collage.

> Copying one source is plagiarism. Taking from many sources and turning it into one voice is design.

### 1.2 The steal list

| Part of our app | Stolen from | What we take | What we leave behind |
|---|---|---|---|
| Overall calm, restraint | **Linear**, **Things 3** | Mostly neutral UI; colour only means something; fast and quiet | Linear's dense, keyboard-first power-user feel |
| Persistent voice button | **Spotify** "now playing" bar, **Google Recorder** | A capture control always one thumb away; live waveform while recording | Music-app visual noise |
| Live transcript while speaking | **Google Recorder**, **Otter** | Words appear as you speak; you trust it's listening | Speaker labels and meeting UI |
| Proposal review (merge / reject) | **GitHub** pull requests | Diff view, explicit approve, history of merges | Code font, red/green harshness, review-comment threads |
| Project as a "repository" | **GitHub** repo page | README-like summary on top, sections below, history tab | Branches, issues, stars |
| Screenplay editor | **Highland 2**, **Fountain** format, **Final Draft** | Correct industry format, automatic element switching (scene heading → action → character → dialogue) | Final Draft's toolbar clutter |
| Beats as cards | **Trello**, physical index cards on a corkboard | Drag-to-reorder cards, colour by act or sequence | Kanban columns as a rigid workflow |
| Storyboard canvas | **Procreate**, **Concepts** | Full-screen canvas, gesture-first, tools hidden until needed | Painting-app complexity (layers stay minimal) |
| Shape assist on strokes | **Apple Notes / iPad** "hold to snap" | Hold at end of stroke → clean line, circle, rectangle, arrow | — |
| Character relationship map | **Obsidian** graph view | Nodes and links you can pull around | Obsidian's dense, physics-heavy global graph |
| Infinite Void (loose ideas) | **Google Keep**, **Apple Notes** | Fast, low-friction cards that don't need a home yet | Reminders, labels, colour-picking for every note |
| Reading comfort for long text | **Kindle**, **iA Writer** | Generous line height, a narrow text column, a serif face for reading | — |
| Dark cinematic chrome | **DaVinci Resolve**, **Lightroom** | Dark neutral frame so the content (image or text) is the brightest thing | Pro-tool control density |

---

## 2. Core concept: "The editing suite"

**The app is a dark editing suite with lit pages inside it.**

- The **frame** of the app (navigation, bars, menus) is dark and warm. It is the room.
- The **work** (your screenplay pages, storyboard paper, beat cards) is lit. It is what's on the desk.
- **Amber** is the light in the room. It marks where your voice goes in and what needs your attention.

Why this works for you:

- You capture ideas all day and often at night. A dark frame is comfortable then.
- Screenplays and sketches are read and drawn for long stretches. Dark text on paper is the most readable and is what your hand expects with the S Pen.
- It makes the app feel like a film tool, not a productivity SaaS.

Where the metaphor breaks: a real editing suite is full of controls. Ours is not. The room stays nearly empty.

---

## 3. Design principles

Ranked in order. When two principles conflict, the higher one wins.

1. **Your words are the brightest thing on screen.** Story content always has the highest contrast and the most space. App chrome recedes.
2. **One tap to speak, from anywhere.** The mic is the single loudest element in the app. Nothing else competes with it.
3. **Nothing changes without you seeing it.** Every AI change appears as a proposal you can read, compare and approve. No silent edits.
4. **Colour carries meaning, never decoration.** Each accent colour has exactly one job (section 5.3). If it's coloured, it's telling you something.
5. **Show the voice of whoever is speaking.** Your story text, the AI's suggestions and the app's own labels each look different (section 6). You always know who wrote what.
6. **Calm over clever.** No confetti, no bouncing badges, no streaks. Motion explains changes; it doesn't entertain.
7. **Gestures for drawing, buttons for decisions.** The canvas is gesture-driven. Anything that commits a change (approve, delete, merge) is an explicit, labelled button.
8. **Built on an 8-point grid.** Every size and gap comes from one system, so screens stay consistent as the app grows (section 4).

---

## 4. The rule of eight (spacing and layout)

### 4.1 What it is

Every dimension (padding, margin, component height, icon size, gap) is a **multiple of 8 dp**. For fine adjustments inside small components, 4 dp is allowed as a half-step.

Why 8:
- 8 divides evenly into the common screen densities (1x, 1.5x, 2x, 3x, 4x), so edges land on whole pixels and stay sharp.
- It gives a small, fixed set of choices. Fewer choices means screens don't drift apart over time.
- Material Design (which Flutter uses underneath) is built on the same grid, so Flutter's defaults fit naturally.

### 4.2 Spacing scale

| Token | Value | Use |
|---|---|---|
| `space.0_5` | 4 dp | Icon-to-label gap, tight inline gaps |
| `space.1` | 8 dp | Gap between related items |
| `space.2` | 16 dp | Default padding inside cards; screen side margin |
| `space.3` | 24 dp | Gap between groups / sections inside a screen |
| `space.4` | 32 dp | Separation between major blocks |
| `space.6` | 48 dp | Top-of-screen breathing room, empty-state spacing |
| `space.8` | 64 dp | Rare: hero spacing on project home |

### 4.3 Sizes

| Element | Size | Note |
|---|---|---|
| Minimum touch target | 48 × 48 dp | Accessibility floor; also Material's guidance |
| Standard button height | 48 dp | |
| Compact chip height | 32 dp | Filter chips, tags |
| Mic button (idle) | 64 dp | Largest control in the app, on purpose |
| Bottom bar height | 64 dp | Includes mic dock |
| Icons | 24 dp (default), 16 dp (inline), 32 dp (empty states) | |
| Corner radius | 8 dp (controls), 16 dp (cards, sheets), full (mic, chips) | |
| Screen side margin | 16 dp | 24 dp on tablets / web |
| Max text column width | ~640 dp | Long lines tire the eye; same reason books aren't wide |

### 4.4 Baseline

Text line heights are multiples of 4 dp, so text sits on the same rhythm as everything else (section 6.3).

---

## 5. Colour

### 5.1 Palette: "Darkroom + Paper" hybrid **[Proposal]**

Two families: **Darkroom** for the frame, **Paper** for the work surfaces.

**Darkroom (app frame)**

| Token | Hex | Role |
|---|---|---|
| `frame.bg` | `#16130F` | App background. Warm near-black |
| `frame.surface` | `#221E19` | Cards, sheets, bars on the dark frame |
| `frame.surfaceRaised` | `#2E2A24` | Pressed / selected surface, menus |
| `frame.text` | `#EDE6D8` | Primary text on dark (ivory) |
| `frame.textSecondary` | `#A89F90` | Labels, metadata on dark |
| `frame.divider` | `#EDE6D8` at 10% | Hairlines |

**Paper (work surfaces: screenplay, storyboard, reading)**

| Token | Hex | Role |
|---|---|---|
| `paper.bg` | `#F4EFE4` | Page / canvas |
| `paper.surface` | `#FBF8F2` | Raised card on paper |
| `paper.ink` | `#1E1C19` | Primary text and default S Pen stroke |
| `paper.inkSecondary` | `#6B6457` | Margin notes, scene numbers, metadata |
| `paper.redPencil` | `#A63A2B` | Removed text in diffs on paper; editor marks |

### 5.2 Accents

| Token | Hex | Notes |
|---|---|---|
| `accent.amber` | `#E8A33D` | Voice and primary action |
| `accent.teal` | `#7FB0AD` (text) / `#5E8C8A` (fills) | Navigation, selection |
| `accent.sage` | `#8DB38B` | Approved / merged / added |
| `accent.ember` | `#E07A62` (text) / `#C2553F` (fills) | Recording, reject, destructive |

### 5.3 One colour, one job

| Colour | Means | Used for | Never used for |
|---|---|---|---|
| **Amber** | "Your voice / your attention" | Mic button, the single primary button on a screen, pending-proposal badge | Headings, decoration, links |
| **Teal** | "Where you are" | Selected tab, current section, focus ring, links | Status |
| **Sage** | "Accepted" | Approved state, added text in a diff, merged history entries | Buttons |
| **Ember** | "Live or destructive" | Recording indicator, reject, delete | Errors you can't act on (those use plain text + icon) |

Why this matters: if amber also decorated headings, the mic button would stop standing out. Your eye would have to search instead of finding it instantly.

### 5.4 Contrast (measured, WCAG 2.x)

| Pair | Ratio | Passes |
|---|---|---|
| `frame.text` on `frame.bg` | 14.9 : 1 | AAA |
| `frame.text` on `frame.surface` | 13.3 : 1 | AAA |
| `frame.textSecondary` on `frame.bg` | 7.1 : 1 | AAA |
| `accent.amber` on `frame.bg` | 8.6 : 1 | AAA |
| `frame.bg` (dark text) on amber button | 8.6 : 1 | AAA |
| `accent.teal` text `#7FB0AD` on `frame.bg` | 7.7 : 1 | AAA |
| `accent.teal` fill `#5E8C8A` on `frame.bg` | 4.9 : 1 | AA (fills / icons only) |
| `accent.sage` on `frame.bg` | 7.9 : 1 | AAA |
| `accent.ember` text `#E07A62` on `frame.bg` | 6.3 : 1 | AA |
| `accent.ember` fill `#C2553F` on `frame.bg` | 4.1 : 1 | Non-text only (≥3 : 1) |
| `paper.ink` on `paper.bg` | 14.8 : 1 | AAA |
| `paper.inkSecondary` on `paper.bg` | 5.1 : 1 | AA |
| `paper.redPencil` on `paper.bg` | 5.6 : 1 | AA |

Rule: the darker teal and ember fills are **never used for text**. That is why each has a separate text shade.

### 5.5 Colour rules

- **Near-black, not pure black.** Pure `#000000` on the S25 Ultra's OLED can smear when scrolling. `#16130F` avoids most of it. (Known OLED behaviour; how visible it is varies by panel.)
- **Material You dynamic colour is off.** Otherwise your wallpaper would recolour the app and it would lose its identity.
- **Never colour alone.** Every status also has an icon or a word: approved = sage + check icon; recording = ember + pulsing dot + timer.
- **Beat and act colours** use low-saturation tints of the existing palette, never new hues. A dozen bright colours would break principle 4.

---

## 6. Typography

### 6.1 Three voices, three typefaces

| Voice | Typeface | Where | Why |
|---|---|---|---|
| **The story** (your words) | **Literata** (serif) | Summaries, beats, character notes, Infinite Void cards | Designed for long on-screen reading (it was made for Google Play Books). Feels like a page, not an app |
| **The screenplay** | **Courier Prime** (monospace) | Screenplay editor and PDF export | Industry-standard screenplay look; 1 page ≈ 1 minute timing only works in a Courier-style font |
| **The app** | **Inter** (sans) | Buttons, labels, nav, metadata, AI notes | Neutral, very legible at small sizes; stays out of the way |

All three are free under the SIL Open Font License and available from Google Fonts, so they ship with the app and work in PDF export.

**AI-suggested text** (inside a proposal, before you approve it) is shown in **Literata italic** with a thin amber left rule. After you approve, it becomes normal Literata. You always see what you haven't accepted yet.

### 6.2 Weights

Two weights per family: **Regular (400)** and **Medium (500)**, plus Literata Italic. Heavier weights make the dark UI feel loud.

### 6.3 Type scale (line heights on the 4 dp rhythm)

| Token | Family | Size / line height | Use |
|---|---|---|---|
| `type.display` | Literata Medium | 32 / 40 | Project title on project home |
| `type.title` | Inter Medium | 22 / 28 | Screen titles |
| `type.heading` | Inter Medium | 18 / 24 | Section headings (Beats, Characters) |
| `type.story` | Literata Regular | 18 / 28 | Story body text |
| `type.body` | Inter Regular | 16 / 24 | UI body text, lists |
| `type.screenplay` | Courier Prime Regular | 16 / 24 on phone (12 pt in PDF) | Screenplay |
| `type.label` | Inter Medium | 14 / 20 | Buttons, tabs, chips |
| `type.caption` | Inter Regular | 12 / 16 | Timestamps, counts, metadata |

Minimum size anywhere: 12. Text respects the system font-size setting; layouts must not break up to 1.3× scaling.

### 6.4 Text rules

- Sentence case everywhere ("Approve proposal", not "Approve Proposal").
- Buttons start with a verb, 1–3 words.
- The app never says "I". It speaks as the product: "3 changes ready to review", not "I made 3 changes".

---

## 7. Layout and navigation

### 7.1 App structure

```
Home (all projects + Infinite Void)
└── Project ("repository")
    ├── Overview   — summary (README), pending proposals, recent history
    ├── Characters — list + relationship map
    ├── Beats      — cards on a board
    ├── Script     — screenplay editor
    ├── Board      — storyboard frames
    └── Settings   — per-project AI permissions
```

### 7.2 Navigation pattern

- **Phone:** project sections are a **top tab row** (scrollable). The **bottom bar** holds only: back / home on the left, the **mic dock in the centre**, and the proposals inbox on the right.
  - Why not bottom tabs for sections: the bottom centre belongs to the mic (principle 2), and six sections are too many for a bottom tab bar.
- **Tablet / web:** sections move to a left rail; mic stays bottom centre.
- **Swipe between Script and Board per beat** (from the functional spec): horizontal swipe on a beat moves between its screenplay and its storyboard frames. A small two-dot indicator shows which side you're on.

### 7.3 Screen anatomy (phone)

```
┌──────────────────────────────┐
│ ← Project title        ⋯     │  64 dp top bar (frame.surface)
│ Overview Characters Beats …  │  48 dp tab row
├──────────────────────────────┤
│                              │
│   Content area               │  frame.bg, or paper.bg
│   16 dp side margins         │  for Script / Board
│                              │
├──────────────────────────────┤
│  ⌂        ( ● mic )      ⇄ 3 │  64 dp bottom bar
└──────────────────────────────┘
```

---

## 8. Key components

### 8.1 Mic dock (the most important control)

| State | Look | Behaviour |
|---|---|---|
| Idle | 64 dp amber circle, dark mic icon | Tap to start; long-press to hold-to-talk |
| Listening | Expands into a bottom sheet: ember pulsing dot, timer, live waveform, live transcript in Literata | Tap stop, or swipe sheet down to stop |
| Processing | Sheet shows "Organizing…" with a slow amber progress line | Can be dismissed; the proposal arrives in the inbox |
| Proposal ready | Amber count badge on the inbox icon | Tap opens review |

Scope label: when a project is open, the sheet says **"Adding to: <Project name>"**. On Home it says **"Adding to: Infinite Void"**, with a tap to change. This matches the functional spec's global-but-scoped assistant.

Stolen from: Spotify's mini-player (always present, expands on tap) and Google Recorder (live words build trust that it's listening).

### 8.2 Proposal review (the "pull request")

- Header: what the proposal touches ("Beats · 2 added, 1 changed").
- Body: a **diff**, styled softly:
  - Added text: sage left rule + faint sage background.
  - Removed text: ember strike-through (red pencil on paper surfaces).
  - Changed text: shows both, removed above added.
- Each change can be accepted or rejected individually; one **Approve all** primary button (amber), one **Reject** secondary button.
- Your original spoken transcript is one tap away ("Show what I said"), so you can check the AI didn't add anything you didn't say.

Stolen from: GitHub's PR diff. Softened: no harsh red/green, no line numbers, no code font.

### 8.3 Beat cards

- Index-card shape, `paper.surface` background on the dark frame, 16 dp radius.
- Top edge: a thin colour band for the act or sequence (muted tint).
- Content: beat title (Inter Medium), one-line description (Literata), small icons showing whether script text and storyboard frames exist for it.
- Long-press to drag and reorder.

### 8.4 Screenplay editor

- Full `paper.bg` page, Courier Prime, correct screenplay margins scaled to the phone.
- Element type switches with **Enter / Tab**, as in Highland and Final Draft (scene heading → action → character → dialogue → parenthetical).
- A small element-type chip on the left margin shows the current element; tap to change it.
- No toolbar visible while writing. A bottom sheet with formatting options appears only on request.

### 8.5 Storyboard canvas

- Full-screen `paper.bg`; frame borders in `paper.inkSecondary`.
- Tools live in a **collapsible floating pill** (pen, eraser, shape assist on/off, grid overlay, undo). Hidden by default while drawing.
- S Pen: pressure-sensitive by default; side button = eraser (Samsung convention). Finger draws when S Pen isn't present, or pans when it is (palm rejection).
- Grid overlays (3×3, golden ratio, centre cross) in `paper.inkSecondary` at 30%, toggled from the pill.
- Frame caption (shot type, beat link, note) below each frame in Inter caption size.

Stolen from: Procreate (canvas first, tools hidden), Apple Notes (hold-to-snap shapes).

### 8.6 Character map

- Nodes: circles with the character's initials, on the dark frame.
- Links: thin lines labelled with the relationship ("sister", "rival").
- Drag nodes freely; positions are saved. No auto-physics that rearranges your layout when you look away.

Stolen from: Obsidian's local graph. Left behind: the global "hairball" graph.

### 8.7 Infinite Void

- A masonry grid of small cards on the dark frame, newest first.
- Each card shows its type with a small icon (dialogue, lyric, concept, character) and its text in Literata.
- Long-press → "Move to project…".

---

## 9. Motion

Motion explains what changed. It never decorates.

| Token | Duration | Curve | Use |
|---|---|---|---|
| `motion.fast` | 120 ms | ease-out | Button press, chip toggle |
| `motion.base` | 240 ms | ease-in-out (emphasized) | Sheets, tab changes, card reorder |
| `motion.slow` | 400 ms | ease-in-out | Mic dock expanding into the listening sheet |

Rules:
- An approved proposal **settles** into place (cards slide to their new order); it doesn't flash.
- The recording dot pulses at about 1 per second. It is the only looping animation in the app.
- Respect the system **"Remove animations"** setting: all motion becomes instant fades.

---

## 10. Iconography

- **Lucide** or **Material Symbols Rounded** (outline, 24 dp, 1.5–2 dp stroke) **[Proposal: Lucide]**. Lucide's thin, even strokes match Inter and feel less "Android stock".
- Outline icons everywhere; filled only for the active state of a tab.
- Icons never stand alone for destructive actions: "Delete" always has a word.

---

## 11. Haptics and sound

- Light haptic tick when recording starts and stops (so you know without looking — useful when you're walking or it's in your pocket).
- Medium haptic on approve.
- No sounds by default.

---

## 12. Accessibility

- All text meets WCAG AA at least; primary text meets AAA (section 5.4).
- Touch targets ≥ 48 dp.
- Colour is never the only signal.
- Every icon-only button has a screen-reader label.
- Layouts tested at 1.3× system font size.
- Voice-first is itself an accessibility feature: every core flow (capture, review, approve) works without precise touch.

---

## 13. Light theme

The frame defaults to Darkroom. A **light frame** option exists in settings for bright daylight:

| Token | Light value |
|---|---|
| `frame.bg` | `#EFE9DD` |
| `frame.surface` | `#F8F4EC` |
| `frame.text` | `#1E1C19` |
| `frame.textSecondary` | `#6B6457` |

Paper surfaces stay the same in both themes. Accents keep their roles; their text shades are darkened on light backgrounds to keep at least AA (to be measured when the light theme is built).

---

## 14. Flutter implementation notes

- **Base:** Material 3 (`useMaterial3: true`) for components and layout logic; our own `ColorScheme` and `TextTheme` on top.
- **Tokens:** define colours, spacing, radii and motion in a single `tokens.dart` file (e.g. `AppSpace.s2 = 16`). No raw numbers or hex values anywhere else in widget code. This is the 8-point grid enforced in code.
- **Theme extensions:** use `ThemeExtension` for things Material doesn't model: the paper family, diff colours and the mic dock.
- **Fonts:** bundle Literata, Courier Prime and Inter as assets (don't fetch at runtime). The app must work offline at capture time.
- **Dynamic colour:** off.
- **Canvas:** S Pen pressure via Flutter's `PointerEvent.pressure`; Samsung side-button detection to be verified on the S25 Ultra early, since it affects the eraser design.

---

## 15. Open decisions (need your approval)

| # | Decision | My proposal | Options |
|---|---|---|---|
| D1 | Palette | Darkroom frame + Paper work surfaces | Darkroom only / Script paper only / Night notebook |
| D2 | Story typeface | Literata | Fraunces (more character) / Source Serif |
| D3 | Section navigation on phone | Top tab row, mic owns bottom centre | Bottom tab bar + floating mic |
| D4 | Icon set | Lucide | Material Symbols Rounded |
| D5 | AI-suggested text style | Literata italic + amber rule | Different colour / a label "Suggested" |
| D6 | Storyboard canvas colour | Paper (light) in both themes | Follows frame theme (dark canvas, light strokes) |
| D7 | Default frame theme | Dark | Light / follow system |

Answer in shorthand, e.g. `D1 ok, D2 Fraunces, D3 ok …`.

---

## 16. Next steps after approval

1. Turn sections 4–6 into `tokens.dart`.
2. Mock up four key screens: Home, Project overview, Proposal review, Storyboard canvas.
3. Test the mic dock and the S Pen canvas on the S25 Ultra before building the rest.
