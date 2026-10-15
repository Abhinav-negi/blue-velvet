# DATA_MODEL — Lynch

Single source of truth for every table, column, type and JSON-column shape. DB-01 implements it in Drift; features read it and never invent fields. Change it only through a versioned Drift migration plus an edit here (D-20).

Sources: functional spec §5, §9–§14, §16, §17; plan areas 1–13; decisions D-04, D-14, D-15, D-17, D-18.

## 0. Conventions

| Topic | Rule |
|---|---|
| IDs | `id` is a UUID v4 string (`TEXT PRIMARY KEY`), generated on the device. Foreign keys are UUID strings too. |
| Timestamps | UTC milliseconds since epoch, `INTEGER`. Columns `created_at`, `updated_at` on every table unless stated. Never local time. |
| Booleans | `INTEGER` 0/1 (Drift `boolean`). |
| JSON columns | `TEXT` holding JSON, mapped by a Drift `TypeConverter`. Never null unless "nullable"; empty means `[]` or `{}`. Keys are `snake_case`. |
| Enums | `TEXT` with the listed values. Unknown values must be rejected at the converter. |
| Seed-backed tables | `templates`, `slots`, `shots`, `shot_images` also carry `builtin`, `user_edited`, `seed_id` (see section 0.1). |
| File paths | Stored relative to the app documents folder, forward slashes (e.g. `strokes/<frame_id>.json`). Never absolute. |
| Deletes | Hard delete. Child rows are removed with `ON DELETE CASCADE` unless stated. |
| Types below | `TEXT`, `INTEGER`, `REAL`, `JSON` (= TEXT with converter). `?` = nullable. |

### 0.1 Seed-backed columns
Present on `templates`, `slots`, `shots`, `shot_images`:

| Column | Type | Meaning |
|---|---|---|
| `builtin` | INTEGER (bool) | 1 = row came from `assets/seed/*.json`. 0 = user-made or fetched from the web. |
| `user_edited` | INTEGER (bool) | 1 = user changed a built-in row. The seed merge on app update must skip rows with `user_edited = 1` (edits are kept). |
| `seed_id` | TEXT? | Stable slug from the seed file (e.g. `three-act`, `three-act/act-1`). Unique among non-null values. Null for user-made rows. Seed loader matches on `seed_id`, never on `id`. |

Seed loader: insert missing `seed_id`s; update rows where `builtin = 1 AND user_edited = 0`; never touch `user_edited = 1`; never delete.

---

## 1. void_items

Every captured input that is not (yet) part of a project (spec §5). Items stay after use.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `type` | TEXT | `story_idea`, `concept`, `character`, `dialogue`, `lyric`, `scene_fragment`, `other` |
| `summary` | TEXT | Cleaned summary in the user's words. |
| `raw_transcript` | TEXT | Exactly what was said or typed. Never altered after capture. |
| `summary_spans` | JSON | Per-sentence transcript spans, see 1.1. |
| `structure` | JSON | Type-specific structured content, see 1.2. |
| `tags` | JSON | Array of strings, auto-suggested and editable. |
| `used_in_project_ids` | JSON | Array of project ids this item was used in. "Used" = non-empty. |
| `promoted_project_id` | TEXT? | Set when a story idea became a project (FK `projects.id`, `ON DELETE SET NULL`). |
| `status` | TEXT | `ready`, `needs_ai` (captured offline, waiting for AI; see `ai_queue`), `pre_project` (story idea under review). |
| `created_at`, `updated_at` | INTEGER | |

Indexes: `(created_at DESC)`, `(type)`, `(status)`.

### 1.1 `summary_spans` JSON
List of `{sentence_index, start, end}`. `sentence_index` is the 0-based sentence of `summary` (split by the same sentence splitter the AI contract defines); `start`/`end` are character offsets into `raw_transcript` (Dart string UTF-16 indices, `start` inclusive, `end` exclusive). A sentence may have no span if the AI could not map it: omit it. Spans may overlap. Used by "Where did this come from?" (S4).

```json
[
  {"sentence_index": 0, "start": 0, "end": 74},
  {"sentence_index": 1, "start": 75, "end": 162}
]
```

### 1.2 `structure` JSON
Shape depends on `type`. Always an object; unknown keys ignored. Changing type re-derives it.

```json
{
  "story_idea": {},
  "character": {"name": "Watchman", "age": null, "role": "", "appearance": "old man, never sleeps", "background": "", "traits": "", "habits": "", "wants_needs_fears": "", "notes": ""},
  "dialogue": {"lines": [{"speaker": "Watchman", "text": "Nobody sleeps here."}], "context": ""},
  "lyric": {"sections": [{"kind": "verse", "text": "..."}, {"kind": "chorus", "text": "..."}]},
  "scene_fragment": {"description": "", "characters": ["Kid"]}
}
```
(The example shows one entry per type for reference; a row stores only the object for its own `type`, e.g. `{"lines": [...], "context": ""}`.) `lyric.sections[].kind` values come from library R5 (verse, pre_chorus, chorus, bridge, hook, intro, outro).

### 1.3 FTS virtual table `void_items_fts`
FTS5 external-content table over `void_items`, for full-text search (D-04).

```sql
CREATE VIRTUAL TABLE void_items_fts USING fts5(
  summary, raw_transcript,
  content='void_items', content_rowid='rowid',
  tokenize='unicode61 remove_diacritics 2'
);
-- keep in sync with triggers AFTER INSERT / DELETE / UPDATE on void_items
-- (insert/delete rows with the special 'delete' command for external-content tables)
```
Query: `SELECT v.* FROM void_items v JOIN void_items_fts f ON f.rowid = v.rowid WHERE void_items_fts MATCH ? ORDER BY rank`. Tags are filtered with normal SQL, not FTS.

---

## 2. characters

Global character pool (spec §11). One row per character sheet.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `name` | TEXT | |
| `age` | TEXT? | Free text ("about 8", "70s"). |
| `role` | TEXT | Role in story. |
| `appearance` | TEXT | |
| `background` | TEXT | Background story. |
| `traits` | TEXT | Personality traits. |
| `habits` | TEXT | |
| `wants_needs_fears` | TEXT | |
| `notes` | TEXT | |
| `source_void_item_id` | TEXT? | FK `void_items.id` `SET NULL`; set when promoted from the Void. |
| `created_at`, `updated_at` | INTEGER | |

"Appears in" is not stored: it is derived by querying `beats.character_ids` (via `project_characters`). See checklist.

## 3. project_characters

A character's membership in a project (spec §11.3, assumption A5). Two modes:

- `linked` (default): the row points at a global `characters` row; the sheet is read and edited there, so edits flow both ways. Sheet columns on this row are NULL.
- `forked`: a project-local copy that evolves separately. The sheet columns on this row hold the copy; `character_id` keeps the origin (nullable, informational) so the UI can say "forked from X".

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | The id used by `beats.character_ids`, `frames.character_ids`, character map nodes. |
| `project_id` | TEXT | FK `projects.id` CASCADE |
| `character_id` | TEXT? | FK `characters.id` `SET NULL`. Required when `mode = linked`; if the global row is deleted, linked rows are first converted to forked by the app (copy sheet) before delete. |
| `mode` | TEXT | `linked`, `forked` |
| `name`, `age`, `role`, `appearance`, `background`, `traits`, `habits`, `wants_needs_fears`, `notes` | TEXT? | Fork copy; same meaning as in `characters`. NULL when `linked`. NOT NULL (`name` at least) when `forked`. |
| `created_at`, `updated_at` | INTEGER | |

Unique: `(project_id, character_id)` where `mode = linked`. Reading a sheet: `mode = linked ? characters row : own columns`. Fork action: copy the global sheet into these columns, set `mode = forked`.

---

## 4. templates (seed-backed)

Structures for arranging beats (spec §9.3, library R1). Includes fetched templates.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `name` | TEXT | |
| `description` | TEXT | |
| `source_url` | TEXT? | Source link. |
| `project_types` | JSON | Array of suitable project types: `short_film`, `long_film`, `youtube`, `short`. |
| `builtin`, `user_edited`, `seed_id` | | Section 0.1. |
| `created_at`, `updated_at` | INTEGER | |

```json
["short_film", "long_film"]
```

## 5. slots (seed-backed)

Ordered sections of a template (e.g. "Sequence 3").

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `template_id` | TEXT | FK `templates.id` CASCADE |
| `position` | INTEGER | 0-based order within the template. |
| `name` | TEXT | |
| `description` | TEXT | |
| `runtime_proportion` | REAL? | Optional share of runtime, 0..1. Not required to sum to 1. |
| `builtin`, `user_edited`, `seed_id` | | Section 0.1. `seed_id` form `<template-seed>/<slot-slug>`. |
| `created_at`, `updated_at` | INTEGER | |

Index: `(template_id, position)`.

## 6. shots (seed-backed)

Shot library entries (spec §13, library R2).

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `name` | TEXT | |
| `category` | TEXT | `size`, `angle`, `movement`, `composition`, `lens`, `lighting` |
| `description` | TEXT | |
| `when_to_use` | TEXT | |
| `effect` | TEXT | Emotional or narrative effect. |
| `tags` | JSON | Array of strings. |
| `sources` | JSON | Array of `{title, url}`. |
| `builtin`, `user_edited`, `seed_id` | | Section 0.1. |
| `created_at`, `updated_at` | INTEGER | |

```json
[{"title": "Wikipedia: Dolly zoom", "url": "https://en.wikipedia.org/wiki/Dolly_zoom"}]
```

## 7. shot_images (seed-backed)

Reference images of a shot entry (D-15: built-ins are free-license only).

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `shot_id` | TEXT | FK `shots.id` CASCADE |
| `position` | INTEGER | Display order. |
| `path` | TEXT | Relative path. Built-ins: `assets/seed/images/...` (bundled asset). User/fetched: `shot_images/<id>.<ext>` in the documents folder. |
| `kind` | TEXT | `seed_asset`, `user_file` (tells the loader where to resolve `path`). |
| `license` | TEXT? | Required for built-ins (e.g. `CC BY-SA 4.0`, `Public Domain`). |
| `author` | TEXT? | Required for built-ins. |
| `source_url` | TEXT? | |
| `builtin`, `user_edited`, `seed_id` | | Section 0.1. |
| `created_at`, `updated_at` | INTEGER | |

---

## 8. projects

One story workspace (spec §6, §7, §14).

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `title` | TEXT | Working title. |
| `type` | TEXT | `short_film`, `long_film`, `youtube`, `short` |
| `summary` | TEXT | The README. May be empty (characters-first start). |
| `template_id` | TEXT? | FK `templates.id` `SET NULL`. NULL = no-template mode. |
| `aspect_ratio` | TEXT | Ratio id from library R7 (e.g. `16:9`, `2.39:1`, `9:16`). Frames may override. |
| `type_fields` | JSON | Type-specific fields, see 8.2. |
| `ai_permissions` | JSON | The 8 switches, see 8.1. |
| `source_void_item_id` | TEXT? | FK `void_items.id` `SET NULL`; the story idea it came from. |
| `is_sample` | INTEGER (bool) | 1 for the first-launch sample project (S5), deletable. |
| `created_at`, `updated_at` | INTEGER | |

### 8.1 `ai_permissions` JSON
Exactly these 8 keys, all booleans (spec §14). New projects copy the global defaults from `settings` key `ai_permission_defaults` (same shape). Missing key = treat as `false`.

```json
{
  "auto_summary": true,
  "character_extraction": true,
  "beat_generation": true,
  "auto_placement": true,
  "screenplay_scaffold": true,
  "grammar_cleanup": true,
  "shot_suggestions": false,
  "internet_fetch": false
}
```

### 8.2 `type_fields` JSON
Per project type (library R4 decides defaults). Keys not applicable to the type are omitted.

```json
{
  "youtube": {"title_ideas": ["I found a key"], "thumbnail_ideas": ["Kid holding a rusty key"]},
  "short": {"hook_text": "He finds a key.", "caption": "", "on_screen_text": ""}
}
```
(A row stores only the object for its own type, e.g. `{"title_ideas": [...], "thumbnail_ideas": [...]}`. A-roll/B-roll for YouTube live in beat `say_show` rows, section 9.2.)

---

## 9. beats

The core building block (spec §9, §10.1, §10.2). Holds its own script content: screenplay blocks for films, say/show rows for YouTube and Shorts.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `project_id` | TEXT | FK `projects.id` CASCADE |
| `slot_id` | TEXT? | FK `slots.id` `SET NULL`. NULL = unplaced or no-template mode. |
| `position` | INTEGER | Order within the slot (or within the project when `slot_id` is NULL). Reindexed on drag. |
| `title` | TEXT | |
| `description` | TEXT | In the user's words. |
| `character_ids` | JSON | Array of `project_characters.id`. |
| `blocks` | JSON? | Screenplay blocks. Used when `projects.type` is `short_film` or `long_film`; NULL otherwise. |
| `say_show` | JSON? | Say/Show rows. Used when type is `youtube` or `short`; NULL otherwise. |
| `created_at`, `updated_at` | INTEGER | |

Beat-to-frames link is the `frames.beat_id` FK. Beat-to-blocks link is the blocks living inside the beat. "Has script text" = blocks/rows non-empty; "has frames" = any `frames` row.

Index: `(project_id, slot_id, position)`.

### 9.1 `blocks` JSON (screenplay)
Ordered array. `type` values: `scene_heading`, `action`, `character`, `dialogue`, `parenthetical`, `transition`. Rules for casing and margins come from library R3, not from this column.

| Key | Type | Notes |
|---|---|---|
| `id` | string | UUID. Stable; frames link to it (`frames.block_id`). |
| `type` | string | Element type. |
| `text` | string | |
| `scaffold` | bool | `true` = skeleton drafted by the AI from the user's facts, not yet touched by the user. |
| `ai_suggested` | bool | `true` = shown because the user asked for suggestions; not yet accepted. |

Both flags false = user-written text. The UI styles `scaffold`/`ai_suggested` blocks as unapproved AI text (Literata italic, amber rule). Both flags are cleared the moment the user edits the block or accepts it. Rule D-18: the AI never writes `dialogue`; AI may only append blocks, never edit a user-written block.

```json
[
  {"id": "5b0e1c7e-3f1c-4d63-9c35-0f2f6c2f9a11", "type": "scene_heading", "text": "EXT. PLAYGROUND - DAY", "scaffold": true, "ai_suggested": false},
  {"id": "9d2a7a40-8f55-4b1e-a0d7-6e0b3c4d7b22", "type": "action", "text": "A KID, 8, kneels in the sandbox. A WATCHMAN stands nearby.", "scaffold": true, "ai_suggested": false},
  {"id": "c3f4e8b1-12aa-4e9d-8a3b-77d1f0e5a933", "type": "character", "text": "WATCHMAN", "scaffold": false, "ai_suggested": false},
  {"id": "e17b6a52-0c4d-48f2-b6aa-1a9e2d8c5f44", "type": "dialogue", "text": "Nobody sleeps here, kid.", "scaffold": false, "ai_suggested": false}
]
```

### 9.2 `say_show` JSON (YouTube / Short)
Ordered array of rows, one per spoken/visual unit (spec §6.1). Same `scaffold`/`ai_suggested` flags and clearing rule as blocks; they apply to the row as a whole.

| Key | Type | Notes |
|---|---|---|
| `id` | string | UUID. |
| `say` | string | Spoken lines, written by the user (AI scaffolds placeholders only). |
| `show` | object | `{a_roll, b_roll, on_screen_text, graphics}`, all strings, any may be empty. |
| `scaffold`, `ai_suggested` | bool | As above. |

```json
[
  {
    "id": "1a6c0d3e-7b2f-4c80-b4e1-5d9a8f3c2b55",
    "say": "I found a rusty key in a sandbox.",
    "show": {"a_roll": "Me to camera, playground behind", "b_roll": "Close-up of the key", "on_screen_text": "Day 1", "graphics": ""},
    "scaffold": false,
    "ai_suggested": false
  }
]
```

---

## 10. frames

One storyboard frame belonging to a beat (spec §10.3, §10.4).

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `beat_id` | TEXT | FK `beats.id` CASCADE |
| `position` | INTEGER | 0-based order within the beat. |
| `strokes_path` | TEXT? | Relative path of the stroke JSON file (section 10.2). NULL until first stroke. |
| `thumbnail_path` | TEXT? | Relative path of a cached PNG for lists and PDF export. Regenerable; not the source of truth. |
| `aspect_ratio` | TEXT? | Override; NULL = use the project's. |
| `shot_size` | TEXT? | Free text or library name (e.g. "Close-up"). |
| `angle` | TEXT? | |
| `movement` | TEXT? | Camera movement. |
| `lens_feel` | TEXT? | |
| `duration_ms` | INTEGER? | Shot duration. |
| `notes` | TEXT | |
| `block_id` | TEXT? | Optional link to a screenplay block id or say/show row id inside the beat's JSON. No FK; dangling ids are ignored by the UI. |
| `character_ids` | JSON | Array of `project_characters.id` in the frame. |
| `reference_images` | JSON | Array of reference image refs, see 10.1. |
| `shot_id` | TEXT? | FK `shots.id` `SET NULL`; optional shot-library entry. |
| `created_at`, `updated_at` | INTEGER | |

Index: `(beat_id, position)`.

### 10.1 `reference_images` JSON
Each item is `{kind, ...}`. `kind: "file"` is an image dropped in from the gallery (copied into `frame_refs/<frame_id>/<uuid>.<ext>`); `kind: "shot_image"` points at a shot library image.

```json
[
  {"kind": "file", "path": "frame_refs/0f8e.../a1b2.jpg"},
  {"kind": "shot_image", "shot_image_id": "6c1d4b7a-2e0f-4a39-8d55-3b7c9e1f0a66"}
]
```

### 10.2 Stroke file format
Drawings are stored losslessly as stroke data in one JSON file per frame at `strokes/<frame_id>.json` under the app documents folder (spec §17, D-09). Never only as images. Included in the Drive backup zip. Snapshots do not include these files.

Top-level keys:

| Key | Type | Notes |
|---|---|---|
| `version` | int | Format version, currently `1`. |
| `canvas` | object | `{width, height}` logical units; points are stored in this space (origin top-left). Ratio equals the frame's effective aspect ratio. |
| `strokes` | array | Drawing order. Erased strokes are removed (undo history is not stored). |

Stroke object:

| Key | Type | Notes |
|---|---|---|
| `id` | string | UUID. |
| `tool` | string | `pen`, `eraser`. (Shape-assist output is saved as a normal `pen` stroke with the snapped points, plus `shape`.) |
| `layer` | string | `sketch`, `clean` (D-18). |
| `color` | string | `#RRGGBB` or `#AARRGGBB`. |
| `width` | number | Base stroke width in canvas units. |
| `shape` | string? | Optional: `line`, `circle`, `ellipse`, `rectangle`, `arrow` when shape assist snapped it. |
| `points` | array | `{x, y, pressure, t}`. `pressure` 0..1 (1.0 for finger input). `t` = milliseconds since the stroke's first point (first point `t: 0`). |

```json
{
  "version": 1,
  "canvas": {"width": 1920, "height": 1080},
  "strokes": [
    {
      "id": "b8f1c2d4-5e6a-4b7c-9d0e-1f2a3b4c5d66",
      "tool": "pen",
      "layer": "sketch",
      "color": "#1A1A1A",
      "width": 4.0,
      "shape": null,
      "points": [
        {"x": 412.5, "y": 300.0, "pressure": 0.31, "t": 0},
        {"x": 418.2, "y": 304.7, "pressure": 0.52, "t": 8},
        {"x": 431.0, "y": 311.9, "pressure": 0.64, "t": 16}
      ]
    },
    {
      "id": "d2e3f4a5-6b7c-4d8e-9f01-a2b3c4d5e677",
      "tool": "eraser",
      "layer": "sketch",
      "color": "#FFFFFF",
      "width": 18.0,
      "shape": null,
      "points": [
        {"x": 420.0, "y": 305.0, "pressure": 1.0, "t": 0},
        {"x": 430.0, "y": 310.0, "pressure": 1.0, "t": 12}
      ]
    }
  ]
}
```
Eraser strokes are kept in the list and applied in order when rendering (so an eraser on one layer never touches the other layer). Writes are atomic (write to `.tmp`, then rename).

---

## 11. character_maps

One row per project (spec §12). Drawn entirely by the user; no AI.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `project_id` | TEXT | FK `projects.id` CASCADE, UNIQUE (one map per project). |
| `nodes` | JSON | Array of nodes. |
| `edges` | JSON | Array of relationships. |
| `groups` | JSON | Array of colour groups. |
| `viewport` | JSON | `{x, y, zoom}`, last pan/zoom. |
| `created_at`, `updated_at` | INTEGER | |

Shapes:
- node: `{id, project_character_id, x, y, group_id}` (`group_id` nullable). `x`,`y` are canvas units; no auto-physics.
- edge: `{id, from_node_id, to_node_id, label}`; `label` is free text (quick picks from library R6).
- group: `{id, name, color}`; `color` is a muted palette token name (e.g. `sage`, `ember`, `amber`, `slate`), not a raw hex.

```json
{
  "nodes": [
    {"id": "n1", "project_character_id": "7a1b2c3d-0000-4000-8000-000000000001", "x": 120.0, "y": 80.0, "group_id": "g1"},
    {"id": "n2", "project_character_id": "7a1b2c3d-0000-4000-8000-000000000002", "x": 360.0, "y": 140.0, "group_id": null}
  ],
  "edges": [
    {"id": "e1", "from_node_id": "n1", "to_node_id": "n2", "label": "afraid of"}
  ],
  "groups": [
    {"id": "g1", "name": "Playground", "color": "sage"}
  ],
  "viewport": {"x": 0.0, "y": 0.0, "zoom": 1.0}
}
```
(Stored as four columns: `nodes`, `edges`, `groups`, `viewport`; the single block above shows them together.) Deleting a project character removes its nodes and their edges (app-level, in the same transaction).

---

## 12. proposals

A new input aimed at a project, waiting for review (spec §8, §4.2). Nothing changes the project until Approve runs the ops (D-17).

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `project_id` | TEXT | FK `projects.id` CASCADE |
| `status` | TEXT | `pending`, `approved`, `rejected`. Deferred proposals stay `pending`. |
| `summary` | TEXT | Clean summary. |
| `raw_transcript` | TEXT | |
| `summary_spans` | JSON | Same shape as `void_items.summary_spans` (1.1). |
| `changes` | JSON | Ordered change-ops, see 12.1. |
| `source_void_item_id` | TEXT? | FK `void_items.id` `SET NULL`; set when sent from the Void. |
| `rejected_to_void_item_id` | TEXT? | FK `void_items.id` `SET NULL`; set when rejection sent it to the Void. |
| `snapshot_id` | TEXT? | The snapshot created on approve (FK `snapshots.id` `SET NULL`). |
| `created_at`, `updated_at` | INTEGER | Stack order is `created_at ASC`. |
| `resolved_at` | INTEGER? | When approved or rejected. |

Index: `(project_id, status, created_at)`.

### 12.1 `changes` JSON
Ordered array of `{op, ...}` objects, applied in array order on Approve. Each op also carries `accepted` (bool, default `true`): the user can accept or reject each change individually; only `accepted: true` ops run. The exact op list and each op's fields are defined in `docs/AI_CONTRACT.md` (CON-03); this doc fixes only the envelope: `op` (string, e.g. `addBeat`, `editBeat`, `splitBeat`, `addCharacter`, `setSummary`, `addScaffold`), optional `id` (op UUID), `accepted`, plus op-specific fields. Ops never touch drawings, and never edit user-written screenplay text (append only, D-18).

```json
[
  {"op": "addBeat", "id": "a0c1...", "accepted": true, "title": "The watchman notices", "description": "The watchman sees the kid with the key.", "slot_seed_id": "five-point/inciting-moment", "character_names": ["Watchman"]},
  {"op": "addCharacter", "id": "b1d2...", "accepted": true, "name": "Watchman", "fields": {"appearance": "old man who never sleeps"}},
  {"op": "setSummary", "id": "c2e3...", "accepted": false, "text": "A kid finds a rusted key in a playground sandbox."}
]
```

---

## 13. snapshots

Version history (spec §16.1). One per approved proposal, per restore, and per project creation.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `project_id` | TEXT | FK `projects.id` CASCADE |
| `reason` | TEXT | `created`, `proposal_approved`, `restored`, `manual` |
| `label` | TEXT | Human text for the history list (e.g. "Approved: The watchman notices"). |
| `proposal_id` | TEXT? | The proposal that caused it. No FK (avoids a cycle with `proposals.snapshot_id`). |
| `restored_from_snapshot_id` | TEXT? | Set when `reason = restored`. |
| `data` | JSON | The whole project as JSON, see 13.1. |
| `created_at` | INTEGER | `updated_at` is not used. |

Index: `(project_id, created_at DESC)`.

### 13.1 Snapshot format
`data` holds the project and its owned rows as they were, **without drawings**: no stroke files, no `thumbnail_path` contents, no image bytes. `frames` rows are included as metadata (shot details, notes, links) with `strokes_path` kept as a reference; the stroke files themselves are never copied, so snapshots stay small. Proposals never touch drawings, and a restore leaves stroke files as they are (frames deleted since a snapshot are restored as metadata rows; their strokes file exists only if it was not deleted: when a frame is deleted its stroke file is kept until the next backup compaction, otherwise the frame restores blank). Not included: `proposals`, `snapshots`, `ai_queue`, `void_items`, global `characters`.

| Key | Content |
|---|---|
| `format` | `1` |
| `project` | The `projects` row (all columns, JSON columns as parsed objects). |
| `template` | `{template_id, seed_id}` of the template used, or null. Slots are referenced by `slot_id`/`seed_id` in beats; template content is not copied. |
| `project_characters` | All rows of this project; for `linked` rows also the sheet fields as they were (`resolved` object) so the view is faithful. |
| `beats` | All rows, with `blocks` and `say_show` as parsed JSON. |
| `frames` | All rows as metadata (no stroke data). |
| `character_map` | The `character_maps` row or null. |

Restore: in one transaction replace the project's rows with the snapshot's, then insert a new snapshot with `reason = restored`. IDs in the snapshot are reused.

```json
{
  "format": 1,
  "project": {"id": "3f0c...", "title": "The Key", "type": "short_film", "summary": "A kid finds a rusted key...", "template_id": "11aa...", "aspect_ratio": "2.39:1", "type_fields": {}, "ai_permissions": {"auto_summary": true, "character_extraction": true, "beat_generation": true, "auto_placement": true, "screenplay_scaffold": true, "grammar_cleanup": true, "shot_suggestions": false, "internet_fetch": false}, "is_sample": false, "created_at": 1760500000000, "updated_at": 1760590000000},
  "template": {"template_id": "11aa...", "seed_id": "five-point"},
  "project_characters": [
    {"id": "7a1b...", "mode": "linked", "character_id": "9c9c...", "resolved": {"name": "Kid", "age": "8", "role": "", "appearance": "", "background": "", "traits": "", "habits": "", "wants_needs_fears": "", "notes": ""}}
  ],
  "beats": [
    {"id": "e5f6...", "slot_id": "22bb...", "position": 0, "title": "The sandbox", "description": "", "character_ids": ["7a1b..."], "blocks": [{"id": "5b0e...", "type": "scene_heading", "text": "EXT. PLAYGROUND - DAY", "scaffold": true, "ai_suggested": false}], "say_show": null}
  ],
  "frames": [
    {"id": "0f8e...", "beat_id": "e5f6...", "position": 0, "strokes_path": "strokes/0f8e....json", "aspect_ratio": null, "shot_size": "Close-up", "angle": "Low", "movement": null, "lens_feel": null, "duration_ms": 3000, "notes": "", "block_id": null, "character_ids": [], "reference_images": [], "shot_id": null}
  ],
  "character_map": {"nodes": [], "edges": [], "groups": [], "viewport": {"x": 0, "y": 0, "zoom": 1}}
}
```

---

## 14. settings

Key/value store for app and global settings (spec §14, plan area 12).

| Column | Type | Notes |
|---|---|---|
| `key` | TEXT PK | |
| `value` | TEXT | String or JSON text (per key below). |
| `updated_at` | INTEGER | |

Known keys:

| Key | Value | Notes |
|---|---|---|
| `ai_permission_defaults` | JSON | Same shape as `projects.ai_permissions` (8.1). |
| `theme` | `dark` or `light` | Default `dark`. |
| `gemini_api_key` | string | Prefer `flutter_secure_storage`; if kept here it must be excluded from backups. Never committed. |
| `seed_version` | JSON | `{"templates": 1, "shots": 1, ...}` last loaded seed versions. |
| `sample_project_created` | `true`/`false` | S5 first-launch flag. |
| `backup_last_at` | integer string | UTC ms of last successful Drive backup. |
| `backup_account` | string | Signed-in Google account email. |
| `stylus_mode` | `stylus` or `finger` | Last drawing mode. |

```json
{"ai_permission_defaults": {"auto_summary": true, "character_extraction": true, "beat_generation": true, "auto_placement": true, "screenplay_scaffold": true, "grammar_cleanup": true, "shot_suggestions": false, "internet_fetch": false}}
```
(The block shows the one JSON-valued setting's key and value together; `value` stores only the inner object.)

---

## 15. ai_queue

Offline captures and AI jobs waiting for a connection (spec §17, plan area 1). Processed in `created_at` order when online.

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `kind` | TEXT | `clean_capture`, `build_proposal`, `edit_item`, `fetch_convert`, `create_project` |
| `status` | TEXT | `needs_ai` (waiting), `processing`, `done`, `failed` (gave up) |
| `attempts` | INTEGER | Starts 0. |
| `next_retry_at` | INTEGER? | UTC ms; NULL = ready now. Exponential backoff. |
| `error` | TEXT? | Last error message. |
| `payload` | JSON | Input needed to run the job, see 15.1. |
| `target_void_item_id` | TEXT? | FK `void_items.id` CASCADE; the placeholder item the result fills in. |
| `target_project_id` | TEXT? | FK `projects.id` CASCADE; set for jobs aimed at a project. |
| `created_at`, `updated_at` | INTEGER | |

Index: `(status, next_retry_at)`.

### 15.1 `payload` JSON
Fields depend on `kind`; always includes `scope`. Audio is deleted after transcription (D-07); when the job needs transcription offline, `audio_path` points at the temp recording until done, then the file is deleted and the key removed.

```json
{
  "scope": {"type": "void"},
  "text": "Okay so there's this kid, like eight years old...",
  "audio_path": "capture_tmp/2f4a....m4a",
  "locale": "en-IN",
  "grammar_cleanup": true
}
```
`scope` is `{"type": "void"}` or `{"type": "project", "project_id": "..."}`.

---

## 16. Closing checklist: spec fields to columns

### 16.1 Spec §5.2 Void item
| Spec field | Column |
|---|---|
| type | `void_items.type` |
| cleaned summary in your words | `void_items.summary` |
| raw transcript | `void_items.raw_transcript` |
| tags (auto-suggested, editable) | `void_items.tags` |
| created / updated time | `void_items.created_at`, `void_items.updated_at` |
| links: projects it was used in | `void_items.used_in_project_ids` (plus `promoted_project_id`) |
| (S4) where did this come from | `void_items.summary_spans` |
| full-text search | `void_items_fts` over `summary`, `raw_transcript` |

### 16.2 Spec §10.3 Storyboard frame
| Spec field | Column |
|---|---|
| beat holds any number of frames, in order | `frames.beat_id`, `frames.position` |
| the drawing | `frames.strokes_path` (stroke file, 10.2); `frames.thumbnail_path` cache |
| aspect ratio override (§10.4) | `frames.aspect_ratio` |
| shot size | `frames.shot_size` |
| angle | `frames.angle` |
| camera movement | `frames.movement` |
| lens feel | `frames.lens_feel` |
| duration | `frames.duration_ms` |
| notes | `frames.notes` |
| optional link to a screenplay block | `frames.block_id` |
| characters in the frame | `frames.character_ids` |
| reference images | `frames.reference_images` |
| optional shot-library entry | `frames.shot_id` |

### 16.3 Spec §11.1 Character sheet
| Spec field | Column |
|---|---|
| name | `characters.name` / `project_characters.name` (forked) |
| age | `characters.age` / `project_characters.age` |
| role in story | `characters.role` / `project_characters.role` |
| appearance | `characters.appearance` / `project_characters.appearance` |
| background story | `characters.background` / `project_characters.background` |
| personality traits | `characters.traits` / `project_characters.traits` |
| habits | `characters.habits` / `project_characters.habits` |
| wants / needs / fears | `characters.wants_needs_fears` / `project_characters.wants_needs_fears` |
| notes | `characters.notes` / `project_characters.notes` |
| appears in (beats, automatic) | Derived, not stored: beats whose `beats.character_ids` contains the `project_characters.id` (for a linked character, across all `project_characters` rows with that `character_id`). |
| linked vs forked (§11.3) | `project_characters.mode`, `project_characters.character_id` |

### 16.4 Other spec items this doc covers
| Spec item | Column |
|---|---|
| §9.1 beat title, description, characters, links to blocks and frames | `beats.title`, `description`, `character_ids`, `blocks`/`say_show`, `frames.beat_id` |
| §9.2 slots, no-template mode | `beats.slot_id`, `slots.*`, `projects.template_id` NULL |
| §9.3 template format | `templates.*`, `slots.*` |
| §14 eight permissions | `projects.ai_permissions`, `settings.ai_permission_defaults` |
| §6 project type fields | `projects.type`, `aspect_ratio`, `type_fields` |
| §8 proposals | `proposals.*` |
| §16.1 snapshots | `snapshots.*` |
| §17 offline capture | `ai_queue.*`, `void_items.status` |
| §12 character map | `character_maps.*` |
| §13.1 shot entry | `shots.*`, `shot_images.*` |
