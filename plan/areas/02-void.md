## Infinite Void
Purpose: the inbox and idea store for every input that isn't (yet) part of a project.

Features:
- [MVP] Auto-detect item type: story idea, concept, character, dialogue, lyric/song, scene fragment, other. User can change it.
- [MVP] Apply that type's structure: summary, character-sheet fields, dialogue lines with speaker, song sections (from library R5), and so on.
- [MVP] Each item stores: type, cleaned summary, raw transcript, tags (auto-suggested, editable), created/updated time, projects it was used in.
- [MVP] Masonry grid of cards, newest first; type icon plus text in Literata.
- [MVP] Filter by type, tag, date and used/unused; full-text search (SQLite FTS5).
- [MVP] Edit by hand.
- [MVP] Edit by asking the AI ("remove the second part"); the result is shown as a diff to approve.
- [MVP] Change type, which re-applies that type's structure.
- [MVP] Merge two or more items into one.
- [MVP] Promote a story idea to a pre-project (see area 3).
- [MVP] Send to project as a proposal; pull into a project from inside it (e.g. a dialogue into a beat).
- [MVP] Items stay after use, marked "used", so they can be reused.
- [MVP] "Where did this come from?" (S4): tap a sentence in the summary and the matching words in the raw transcript are highlighted.

Notes:
- Spec §5. Void links point only to projects, not to other Void items (D-18).
- AI edits never apply silently (D-17).
