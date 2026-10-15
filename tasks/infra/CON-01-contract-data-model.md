# CON-01 — Contract: data model
Needs: -     Wave: 1

## Goal
Write docs/DATA_MODEL.md: every table, column, type and JSON-column shape the app stores. DB-01 implements it and every feature reads it, so features never invent fields.

## Read
- plan/OVERVIEW.md
- plan/areas/*.md
- story-organizer-functional-spec.md (§5, §9–§14, §16, §17)

## May touch / must not touch
May: docs/DATA_MODEL.md
Must not: everything else

## Done when
1. Has a section for each table: void_items, characters, project_characters, templates, slots, shots, shot_images, projects, beats, frames, character_maps, proposals, snapshots, settings, ai_queue (`grep -c` finds each)
2. Every JSON column (beat blocks, say/show rows, ai_permissions, character map, proposal changes) has an example JSON block
3. Stroke file format (points x, y, pressure, t; tool; colour; width; layer) and snapshot format (drawings excluded) are specified with examples
4. A closing checklist maps every field in spec §5.2, §10.3 and §11.1 to a column

## Rules
Doc only, no code. IDs are UUID strings; timestamps UTC ms. Seed-backed tables carry `builtin` and `user_edited` flags.

## Evidence
- Wrote docs/DATA_MODEL.md (15 tables + FTS table, 15 json blocks).
- Decisions: beats hold two nullable JSON columns (`blocks` films, `say_show` youtube/short); per-block `scaffold`/`ai_suggested` booleans; project_characters is the id used by beats/frames/map nodes, linked rows have NULL sheet columns, forked rows hold the copy; "appears in" is derived, not stored; void_items.used_in_project_ids is JSON (no join table); proposals.changes envelope only (ops defined by CON-03), each op has `accepted`; snapshots exclude stroke files, include frame metadata.
- Gotchas: some JSON examples show several per-type/per-column shapes in one block (noted in text); `gemini_api_key` should live in secure storage, excluded from backup; stroke files of deleted frames are kept until backup compaction so restore works (DB-01/backup tasks must honour).
- Commands: the table-name grep loop printed nothing; `grep -c '^```json'` = 15.
- Left: nothing.
