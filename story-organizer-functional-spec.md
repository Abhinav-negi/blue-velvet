# Story Organizer — Functional Specification

**Version:** 0.1 (draft for review)
**Date:** 15 Oct 2026
**Owner:** Abhinav Negi
**Scope of this document:** what the app is and what it does — features, behaviour, rules, data concepts.
**Out of scope here (separate docs):** UI / visual design, tech stack.

---

## 0. Assumptions to confirm

These came from unclear parts of the discussion. Each is written into the spec as stated below. Correct any that are wrong.

| # | Assumption | Where it applies |
|---|---|---|
| A1 | Version history is **in**: every merged proposal creates a snapshot you can view or restore. | §13 |
| A2 | The storyboard "drawing assistant" means **shape assist**: a rough stroke held at the end snaps into a clean straight line, circle, rectangle, or arrow, like the drawing tools on Mac/iPad. | §10.4 |
| A3 | Project-type workflows (§6) are sensible defaults written by Claude, not your decisions yet. | §6 |
| A4 | The personal-management module is a **future module**, not part of v1. | §17 |
| A5 | Characters imported into a project are **linked by default**: edits flow both ways, with an option to "fork" a project-local copy. | §11.3 |

---

## 1. What this app is

A **voice-first story organizer** for one person.

You think in stories all day and speak them out the way you'd tell a friend: messy, repeated, out of order. The app catches what you say, cleans it up **without adding ideas of its own**, and places it into structure: summaries, characters, beats, screenplay scaffolds, and storyboards. Every structural change goes through your review first.

The assistant is an **organizer, not a writer**. It does not write your dialogue, judge your story, or tell you your structure is wrong. It arranges, scaffolds, fetches reference material, and keeps everything connected.

**Mental model:** each story is like a **GitHub repository**.

| GitHub | This app |
|---|---|
| Repository | Project (one story / video / short) |
| README | Summary |
| Pull requests | Proposals (each new spoken input) |
| Merge | Approve a proposal into the project |
| Commit history | Version history |
| Folders / sections | Characters, Beats, Screenplay, Storyboard, Character Map |
| Settings | Per-project AI permissions |

Where the analogy breaks: proposals don't conflict the way code branches do. They are applied one at a time, in the order you approve them.

---

## 2. Core principles

These rules apply everywhere in the app.

1. **Your words rule.** The AI may rephrase, tidy, and correct grammar. It may **not** add plot points, character traits, dialogue, or ideas you didn't say. When it scaffolds (e.g. a scene heading), the scaffold is built only from facts you gave.
2. **Speak → Summarize → Review → Commit.** Nothing changes a project until you approve it. This loop is the same for a brand-new idea and for the 50th addition to an old story.
3. **Everything lands in the Infinite Void first.** Every input starts as a Void item and is promoted onward from there (§5).
4. **Organizer, not critic.** No unsolicited feedback on story quality or structure. Suggestions only when you ask.
5. **Dynamic, not hard-coded.** Story structures, shot types, and similar reference data are **data**, not code. The assistant can fetch new ones from the internet and convert them into the app's formats.
6. **You control the AI per project.** Each project has switches for what the AI may do automatically (§12).
7. **No data loss.** Everything is backed up off-device. Losing the phone must not mean losing the work.

---

## 3. Glossary

| Term | Meaning |
|---|---|
| **Input** | One capture session: spoken or typed. |
| **Void item** | Any captured input stored in the Infinite Void, with a type and a cleaned summary. |
| **Pre-project** | A story-idea Void item under review, before it becomes a project. |
| **Project** | A full story workspace of one project type. |
| **Project type** | Short film, long film, YouTube video, or short. Decides defaults and sections. |
| **Proposal** | A new input aimed at an existing project, waiting for review. |
| **Beat** | One unit of story: a cluster of events, interactions, and moments. The core building block. |
| **Template** | A structure for *arranging* beats (8-sequence, Save the Cat, three-act…). A lens, not a rulebook. |
| **Slot** | One section of a template (e.g. "Sequence 3"). Holds zero or more beats. |
| **Screenplay block** | A standard screenplay element (scene heading, action, character, dialogue, parenthetical, transition). |
| **Frame** | One storyboard drawing, belonging to a beat. |
| **Character** | A reusable character sheet, global to the app. |
| **Character map** | A hand-drawn graph of how characters connect within a project. |
| **Shot library** | Your own database of shot types with reference images. |
| **Template library** | Your saved collection of templates (built-in plus fetched). |

---

## 4. Capture

### 4.1 Input methods
- **Voice:** speak freely, any length. Must handle Indian-accented English well. Hindi is out of scope for v1.
- **Text:** a typing field with the same behaviour as voice.
- **Original audio is not kept.** The **raw transcript** is kept alongside the cleaned summary, so you can always see exactly what you said.

### 4.2 Where input goes
- **Global (app home):** input goes to the **Infinite Void**.
- **Inside an open project:** input becomes a **proposal** for that project (§8).
- **Global input that names a project** ("continue the playground story…"): the assistant identifies the project and asks you to confirm before filing it as a proposal there. If you don't confirm, it stays in the Void.

### 4.3 Cleaning rules
When turning a transcript into a summary, the assistant:
- removes repetition, filler, and false starts
- fixes grammar
- orders points logically when you jumped around
- keeps your meaning, your names, and your specifics
- never invents events, motives, traits, or lines

---

## 5. The Infinite Void

The Void is the inbox and idea store for everything that isn't (yet) a project.

### 5.1 Item types
The assistant auto-detects the type. You can change it.

| Type | Example | Auto-structure applied |
|---|---|---|
| **Story idea** | "A kid finds a key in the playground…" | Summary stage (pre-project) |
| **Concept** | An abstract idea, theme, or "what if" | Short summary + tags |
| **Character** | "An old watchman who never sleeps…" | Character sheet fields (§11) |
| **Dialogue** | One strong line or exchange | Line(s) + optional speaker / context |
| **Lyric / song** | Verses, a hook | Song structure (verse / chorus / bridge as identified) |
| **Scene fragment** | One vivid moment without a story yet | Short description + characters mentioned |
| **Other** | Anything else | Plain summary |

### 5.2 Each Void item holds
- type
- cleaned summary in your words
- raw transcript
- tags (auto-suggested, editable)
- created / updated time
- links: which projects it was used in, if any

### 5.3 Actions
- **Filter** by type, tag, date, used/unused; full-text **search**
- **Edit** directly, or ask the assistant to edit ("remove the second part")
- **Change type**, which re-applies that type's structure
- **Merge** two or more items into one
- **Promote** a story idea to a pre-project (§7)
- **Send to project:** attach the item to an existing project as a proposal
- **Pull into project:** from inside a project, browse the Void and pull an item in (e.g. a dialogue into a beat, a character into Characters)
- Items stay in the Void after use (marked "used"), so they can be reused.

---

## 6. Project types

Each type has its own default template, sections, and canvas settings. All defaults can be changed per project.

> These are proposed defaults (Assumption A3). Change anything here.

| | **Short film** | **Long film** | **YouTube video** | **Short** |
|---|---|---|---|---|
| Typical length | 2–30 min | 60+ min | 5–30 min | ≤ 60–90 s |
| Default template | Simple 5-point (setup, inciting moment, escalation, climax, resolution) | 8-sequence | Hook → intro → segments → CTA → outro | Hook → build → payoff (→ loop) |
| Writing section | Screenplay | Screenplay | **Script** (spoken lines + visuals) | **Script** (lines + on-screen text) |
| Default aspect ratio | 16:9 | 2.39:1 | 16:9 | 9:16 |
| Storyboard | Yes | Yes | Yes | Yes |
| Characters | Yes | Yes | Optional (often just you) | Optional |
| Type-specific fields | — | — | A-roll / B-roll per segment; title ideas; thumbnail ideas | Hook text for the first ~2 s; caption; on-screen text |

### 6.1 Script format (YouTube / Short)
A two-column structure per beat/segment:
- **Say:** what is spoken (written by you; the AI only scaffolds placeholders)
- **Show:** what is on screen (A-roll, B-roll, on-screen text, graphics notes)

---

## 7. From idea to project

1. **Capture:** you speak a story idea. It lands in the Void as a *Story idea* item.
2. **Pre-project review:** you see the clean summary. You can edit it, ask for changes, or add more input to it.
3. **Approve (thumbs up).** The assistant asks:
   - which **project type**
   - which **template**, showing 2–4 suitable options with the type's default first
4. **Project created.** Depending on the project's AI permissions (§12), the assistant generates:
   - the Summary
   - Characters it found in your words
   - Beats, arranged into the chosen template
   - Screenplay/script scaffolds per beat
5. Storyboards are always empty. You draw them.

**Characters-first start:** you can also create an empty project with just a working title, write or import characters first, and add story later.

---

## 8. Proposals

Every input given inside a project (or sent there from the Void) becomes a **proposal**.

### 8.1 The proposal stack
- A list of pending proposals per project, oldest first
- A global badge shows how many proposals are waiting across all projects

### 8.2 Each proposal shows
- the clean summary of what you said
- the raw transcript
- a **preview of what will change**: new or edited beats, new characters, summary changes, new scaffolds

### 8.3 Actions
- **Edit** the proposal text yourself
- **Ask for changes** ("drop the part about the dog", "make this a new beat instead")
- **Approve**: merges into the project and creates a history snapshot
- **Reject**: discards (or sends to the Void, your choice)
- **Defer**: leave it in the stack

---

## 9. Beats and templates

### 9.1 Beats
- A beat is a free object: title, description (your words), characters involved, and links to its screenplay blocks and storyboard frames.
- Beats are **edited, dragged, reordered, split, and merged** freely, like blocks in a Notion page.
- Beats can be added by you directly or arrive through proposals.

### 9.2 Templates arrange beats; they don't judge them
- A template is a set of ordered **slots**.
- Beats are **placed** into slots. One slot can hold many beats (e.g. five beats in Sequence 1).
- **Empty slots stay empty.** No warnings, no "your act two is weak" messages.
- **Switching templates** (toggle in the Beats section): the assistant proposes where each beat goes in the new template. You confirm or drag beats to adjust. Beats are never deleted by a template switch.
- A project can also run with **no template**: just an ordered list of beats.

### 9.3 Template library
- Ships with common built-ins (e.g. three-act, 8-sequence, Save the Cat, Hero's Journey, 5-point, YouTube and Shorts structures).
- **Fetch new templates:** "get me the Kishōtenketsu structure". The assistant searches the internet, converts the result into the template format, shows you a preview, and saves it to the library on approval.
- Template format (conceptual): name, description, source link, which project types it suits, and ordered slots, each with name, description, and optional rough proportion of runtime.
- You can create or edit templates by hand.

---

## 10. Beat detail: Screenplay ↔ Storyboard

Tap a beat to open it. **Screenplay/Script** is the main view; **swipe right** to see that beat's **Storyboard**. Swipe back to return.

### 10.1 Screenplay (films)
- Standard elements: scene heading, action, character, dialogue, parenthetical, transition.
- **Scaffolding (AI, if enabled):** when a beat is created, the assistant drafts a skeleton from your words only. Example: you said the scene happens in a playground with two kids, so the scaffold contains the scene heading (playground, time if you gave one) and an action line noting who is present. You continue writing from there.
- **The AI does not write dialogue.**
- On request only, the assistant can suggest structure-level ideas ("other ways to open this beat?"), clearly marked as suggestions.

### 10.2 Script (YouTube / Shorts)
- Say / Show columns per beat (§6.1), with the same scaffolding rules.

### 10.3 Storyboard: frames
- A beat holds **any number of frames**, in order. Frames can be reordered, duplicated, and deleted.
- Each frame has:
  - the drawing
  - **shot details:** shot size, angle, camera movement, lens feel, duration
  - notes
  - optional link to a screenplay block
  - characters in the frame
  - reference images (dropped in from the gallery or the shot library)
  - an optional shot-library entry ("this is a Dutch angle")

### 10.4 Storyboard: drawing canvas
- **Full-screen drawing mode** that respects the project's **aspect ratio**. Each frame can override it.
- Works in **portrait or landscape**; the canvas fits the chosen ratio.
- **Composition guides** as overlays, each toggleable: rule of thirds (3×3), golden ratio / spiral, center cross, diagonals, title-safe and action-safe areas.
- **Pen tools:** adjustable stroke size, colors, eraser, undo/redo, zoom and pan.
- **Stylus support:** pressure sensitivity, palm rejection, S Pen button shortcuts (e.g. hold for eraser). Precision is a hard requirement.
- **Finger fallback:** everything works without a stylus. A toggle switches between stylus mode and finger mode.
- **Shape assist** (Assumption A2): draw and hold, and the stroke snaps to a clean straight line, circle, ellipse, rectangle, or arrow. Also a ruler for perfect lines.
- Layers: at minimum a sketch layer and a clean layer. (Proposed; confirm.)

---

## 11. Characters

### 11.1 Character sheet
- name, age, role in story
- appearance
- background story
- personality traits
- habits
- wants / needs / fears
- notes
- **appears in:** list of beats, filled in automatically

### 11.2 Sources
- written by you directly
- extracted from your input by the AI (if enabled), always arriving as part of a proposal
- promoted from a *Character* item in the Void

### 11.3 Reuse across stories
- All characters live in a **global character pool**.
- Any project can **import** a character from the pool or from another project's character list.
- Imported characters are **linked** by default (Assumption A5). **Fork** makes a project-local copy that evolves separately.

---

## 12. Character map

- A per-project **canvas** showing characters as nodes and relationships as labeled connections (friend, rival, parent, owes money to…).
- **Drawn entirely by you.** No AI generation.
- Free layout: drag nodes, group, color-code.
- Tapping a node opens that character's sheet.

---

## 13. Shot library

A global, growing database of shot types with visual references, usable from any storyboard frame.

### 13.1 Each entry holds
- name (e.g. "Over-the-shoulder")
- category: shot size, angle, movement, composition, lens, lighting
- description and when to use it
- emotional or narrative effect
- **reference images**: from the web, added by you, or your own drawings
- source links
- tags

### 13.2 Building the library
- Starts with a core set of definitions.
- **Fetch:** "find examples of a dolly zoom". The assistant searches the web, builds an entry (or adds images to an existing one), shows a preview, and saves it on approval.
- Add your own images or sketches to any entry.

### 13.3 Using it
- From a storyboard frame, search or browse the library and attach an entry. Its reference images appear beside your drawing.
- Ask the assistant for options ("what shots work for a tense standoff?"), returned as entries from the library plus fetched ones.

> Note for a future public release: images fetched from the web stay in **your** library. A published open-source version would ship the definitions and the fetch feature, not a bundled image set.

---

## 14. Per-project AI permissions

Each project has a **Settings** section with switches. New projects take defaults from global settings.

| Permission | What it does when ON |
|---|---|
| Auto-summary | Rewrites the project summary when proposals merge |
| Character extraction | Finds characters in your input and proposes sheets |
| Beat generation | Turns input into beats inside proposals |
| Auto-placement | Places new beats into template slots |
| Screenplay scaffold on new beat | Drafts the skeleton when a beat is created |
| Grammar cleanup | Corrects grammar when cleaning input |
| Shot suggestions | Suggests shot-library entries for frames |
| Internet fetch | Lets the assistant search the web for this project |

With a switch OFF, that work is left for you to do by hand.

---

## 15. The assistant

### 15.1 Scope
- **Global:** at app level it works across the Void and all projects (find, file, promote, fetch into libraries).
- **Project:** inside an open project it only touches that project.

### 15.2 What it can do
- capture and clean input
- detect Void item types and apply structure
- create pre-projects and proposals
- generate beats, characters, and scaffolds (as permitted)
- place beats into templates and re-map on template switch
- edit items on instruction ("remove this portion", "split this beat")
- find projects and items by description ("the playground story")
- **fetch and convert** from the internet: templates and shot-library entries, always previewed before saving
- answer questions about your own projects ("which beats is Riya in?")

### 15.3 What it never does
- writes dialogue
- adds story content you didn't say
- critiques the story or structure without being asked
- changes a project without your approval
- draws storyboards

### 15.4 Fetch and convert
The generic flow for anything pulled from the internet:
1. You ask for it.
2. The assistant searches and reads sources.
3. It **converts** the result into a known app format (template or shot entry in v1).
4. It shows a preview with sources.
5. You approve, and it is saved to the matching library and usable everywhere.

If something can't be expressed in a known format, the assistant says so rather than inventing a new format.

---

## 16. Version history and export

### 16.1 Version history (Assumption A1)
- Every merged proposal creates a snapshot.
- You can view the project as it was at any snapshot, and restore it (restoring itself creates a new snapshot, so nothing is lost).

### 16.2 Export
- **Screenplay → PDF** in standard industry screenplay formatting
- **Screenplay → Fountain** (plain-text screenplay format other screenwriting tools can open)
- **Storyboard → PDF:** frames in a grid with shot details and notes, grouped by beat
- **Script (YouTube/Shorts) → PDF:** Say/Show two-column layout
- **Project summary + characters → PDF** (a "story bible")

---

## 17. Data requirements (functional)

- **Single user.** No collaboration in v1.
- **Cloud-backed:** all data is synced to cloud storage; a new phone restores everything.
- **Offline capture:** you can capture and edit without internet; it syncs when back online. AI processing waits until online.
- **Drawings** are stored losslessly (stroke data, not just images), so they stay editable.
- **Cost-aware AI:** AI runs only at specific moments (cleaning input, building proposals, scaffolding, fetching), never continuously in the background.

---

## 18. Out of scope for v1

| Item | Status |
|---|---|
| Hindi / Hinglish capture | Later |
| Laptop / web companion | Later |
| Phone + S Pen as a live drawing pad for the laptop | Later |
| Collaboration / sharing projects | Later |
| AI image generation for storyboards | Not planned |
| AI-written dialogue | Not planned |
| Personal management / task module | Future module (Assumption A4) |
| Keeping original audio | Not planned |

---

## 19. End-to-end example

1. Walking home, you speak: *"Okay so there's this kid, like eight years old, he finds a rusted key in the playground sandbox, and, uh, the watchman sees him, the watchman's this old guy who never sleeps…"*
2. It lands in the Void as a **Story idea**, summarized cleanly in your words. "Old watchman who never sleeps" is also noted as a possible character.
3. That evening you review it, fix one detail, and give it a thumbs up.
4. The assistant asks: *Short film or long film?* You pick short film. It offers the 5-point template (default), 8-sequence, or three-act. You keep 5-point.
5. The project is created: summary, two character sheets (the kid, the watchman, with only the traits you said), three beats placed in "Setup" and "Inciting moment", and scaffolds like a playground scene heading with the kid in the sandbox.
6. Two days later, inside the project, you speak a continuation. It becomes **Proposal #2**. The preview shows two new beats and a new character. You ask it to drop one beat, then approve.
7. You open Beat 2, write the screenplay, swipe right, pick 2.39:1 with the rule-of-thirds grid, and sketch three frames with the S Pen. On frame 2 you attach "Low angle" from the shot library.
8. You draw the character map by hand: kid → watchman, "afraid of".
9. You export the storyboard PDF to plan the shoot.

---

## 20. Open questions for later

1. Layers in the storyboard canvas: is sketch + clean enough, or do you want full layers?
2. Should frames support simple animatic playback (frames in sequence with durations)?
3. Should the Void support linking items to each other (a dialogue to a character), or only to projects?
4. How should proposals that touch already-written screenplay text be handled: append only, or allowed to edit what you wrote?
5. The final list of built-in templates and starter shot-library entries.
