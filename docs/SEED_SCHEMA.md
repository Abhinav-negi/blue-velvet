# Seed library schema (CON-02)

Contract for every built-in library file in `assets/seed/` (D-14). Research agents write these files; the app loads them on first launch. Validate before handing in:

```
dart tool/validate_seed.dart assets/seed/<file>.json
```

Exit 0 = valid. Otherwise it prints each problem with the path to the bad field (e.g. `items[3].images[0].license`). The schema is chosen from the **file name**. `sample_project.json` has a different format (defined by PROJ-04) and is not checked here.

## Rules for all files

- Envelope: `{"version": 1, "items": [ ... ]}`. `version` is a positive integer (bump when you change the data); `items` is a non-empty list.
- Every item has `id`: a stable kebab-case slug (`a-z`, `0-9`, single hyphens), unique within the file. Never rename an id after release; other files and user data refer to it.
- `sources` / `source_urls` are lists of `http(s)` URLs.
- No copyrighted film stills (D-15). UTF-8, plain JSON (no comments, no trailing commas).
- "string" always means non-empty.

## Files

| File | Item |
|---|---|
| `templates.json` | story template |
| `shots_camera.json` | shot: `shot_size`, `angle`, `movement` |
| `shots_look.json` | shot: `composition`, `lens`, `lighting` |
| `screenplay_format.json` | screenplay formatting rule |
| `project_types.json` | project type defaults |
| `song_structures.json` | song section or arrangement |
| `relationship_labels.json` | character-map label |
| `aspect_ratios.json` | aspect ratio |
| `guides.json` | composition / safe-area guide |

### Reserved template IDs

These ids exist in `templates.json`; `project_types.json` may reference them in `default_template`:

`three-act`, `eight-sequence`, `save-the-cat`, `heros-journey`, `five-point`, `story-circle`, `kishotenketsu`

YouTube templates start with `youtube-` (at least `youtube-hook-segments-cta`), Shorts templates with `shorts-` (at least `shorts-hook-build-payoff`). The validator accepts those two prefixes plus the seven ids above as `default_template`.

Project type ids: `short-film`, `long-film`, `youtube-video`, `short`.

### templates.json

| Field | Type | Notes |
|---|---|---|
| `name`, `description` | string | |
| `source_urls` | URL list, non-empty | |
| `project_types` | list, non-empty | each one of the four project type ids |
| `slots` | list, non-empty, ordered | `{id, name, description, proportion?}`; slot `id` slug unique in the template; `proportion` 0-1 share of runtime, optional; sum <= 1 |

```json
{"id":"three-act","name":"Three-act","description":"Setup, confrontation, resolution.",
 "source_urls":["https://en.wikipedia.org/wiki/Three-act_structure"],
 "project_types":["short-film","long-film"],
 "slots":[{"id":"act-1","name":"Act 1","description":"Setup","proportion":0.25},
          {"id":"act-2","name":"Act 2","description":"Confrontation","proportion":0.5},
          {"id":"act-3","name":"Act 3","description":"Resolution","proportion":0.25}]}
```

### shots_camera.json / shots_look.json

Same schema. Split: camera file holds `shot_size`, `angle`, `movement`; look file holds `composition`, `lens`, `lighting` (the validator accepts any category in either file).

| Field | Type | Notes |
|---|---|---|
| `name`, `description`, `when_to_use`, `effect` | string | `effect` = emotional / narrative effect |
| `category` | enum | `shot_size`, `angle`, `movement`, `composition`, `lens`, `lighting` |
| `tags` | string list | may be empty |
| `sources` | URL list, non-empty | |
| `images` | list, may be empty | text-only entries are fine |

Image: `{file, license, author, source_url}`
- `file`: path relative to `assets/seed/images/`, e.g. `over-the-shoulder-1.jpg` (the validator checks it exists when an `images/` folder sits next to the JSON).
- `license`: one of `PD`, `CC0`, `CC-BY`, `CC-BY-SA`. Nothing else may ship.
- `author`: string (use `Unknown (public domain)` if truly unknown and PD).
- `source_url`: the Wikimedia Commons (or other) page the image came from.

```json
{"id":"over-the-shoulder","name":"Over-the-shoulder","category":"shot_size",
 "description":"Camera behind one person, framing the other.","when_to_use":"Dialogue.",
 "effect":"Connection and point of view.","tags":["dialogue"],
 "sources":["https://en.wikipedia.org/wiki/Over_the_shoulder_shot"],
 "images":[{"file":"over-the-shoulder-1.jpg","license":"CC-BY-SA","author":"Jane Doe",
            "source_url":"https://commons.wikimedia.org/wiki/File:Example.jpg"}]}
```

### screenplay_format.json

Each item is one group of rules.

| Field | Type | Notes |
|---|---|---|
| `category` | enum | `element`, `capitalisation`, `transition`, `page`, `fountain` |
| `name`, `description` | string | |
| `rules` | object, optional | values are string, number or boolean; use units in key names (`left_indent_in`) |
| `values` | string list, optional | e.g. the transitions list |
| `examples` | string list, optional | |
| `sources` | URL list, non-empty | |

```json
{"id":"dialogue-element","category":"element","name":"Dialogue","description":"Spoken lines.",
 "rules":{"left_indent_in":2.5,"right_indent_in":2.5,"uppercase":false},
 "examples":["I know."],"sources":["https://example.org/format"]}
```

### project_types.json

| Field | Type | Notes |
|---|---|---|
| `name` | string | |
| `length_min_seconds` | number >= 1 | |
| `length_max_seconds` | number, optional | omit for open-ended; >= min |
| `default_template` | slug | reserved id or `youtube-*` / `shorts-*` |
| `template_options` | slug[] | 2–4 template ids offered when creating a project of this type; the first must equal `default_template` |
| `writing_section` | enum | `screenplay`, `script` |
| `default_aspect_ratio` | slug | an id in `aspect_ratios.json` |
| `has_storyboard` | bool | |
| `characters` | enum | `yes`, `optional` |
| `extra_fields` | list | `{id, name, description}` type-specific fields; may be empty |
| `sources` | URL list, non-empty | |

```json
{"id":"short","name":"Short","length_min_seconds":15,"length_max_seconds":90,
 "default_template":"shorts-hook-build-payoff","writing_section":"script",
 "default_aspect_ratio":"9-16","has_storyboard":true,"characters":"optional",
 "extra_fields":[{"id":"hook-text","name":"Hook text","description":"First ~2 s"}],
 "sources":["https://example.org"]}
```

### song_structures.json

| Field | Type | Notes |
|---|---|---|
| `kind` | enum | `section` (verse, chorus, ...) or `arrangement` (common ordering) |
| `name`, `description` | string | |
| `sequence` | slug list, non-empty | required for `arrangement`: section ids in order |
| `sources` | URL list, optional | |

```json
{"id":"verse-chorus","kind":"arrangement","name":"Verse-chorus","description":"Common pop form.",
 "sequence":["intro","verse","chorus","verse","chorus","bridge","chorus","outro"]}
```

### relationship_labels.json

| Field | Type | Notes |
|---|---|---|
| `name` | string | |
| `group` | enum | `family`, `social`, `romantic`, `professional`, `conflict`, `debt_obligation` |
| `inverse` | slug, optional | another label id in this file ("Parent of" <-> "Child of") |
| `symmetric` | bool, optional | same label both directions (default false) |

```json
{"id":"parent-of","name":"Parent of","group":"family","inverse":"child-of"}
```

### aspect_ratios.json

| Field | Type | Notes |
|---|---|---|
| `name` | string | display, e.g. `2.39:1` |
| `width`, `height` | integer >= 1 | smallest whole-number pair |
| `ratio` | number | width/height, within 0.01 |
| `common_uses` | string | |

```json
{"id":"16-9","name":"16:9","width":16,"height":9,"ratio":1.778,"common_uses":"YouTube, TV"}
```

### guides.json

All geometry is **normalised 0-1**: (0,0) top-left of the frame, (1,1) bottom-right; frame-independent so it scales to any aspect ratio.

| Field | Type | Notes |
|---|---|---|
| `name`, `description` | string | |
| `kind` | enum | `composition`, `safe_area` |
| `shapes` | list, non-empty | see below |
| `tags`, `sources` | optional lists | |

Shapes (all numbers 0-1): `{"type":"line","x1","y1","x2","y2"}`, `{"type":"rect","x","y","w","h"}` (top-left + size), `{"type":"circle","cx","cy","r"}` (r relative to frame width), `{"type":"polyline","points":[[x,y],...]}` (use for spirals: sample the curve densely).

```json
{"id":"title-safe","name":"Title safe","description":"Inner 90% of the frame.","kind":"safe_area",
 "shapes":[{"type":"rect","x":0.05,"y":0.05,"w":0.9,"h":0.9}]}
```

## assets/seed/sources/<name>.md

One file per seed file, named after it (`templates.md`, `shots_camera.md`, ...). Every source used, with links:

```
# Sources: templates.json
Researched: YYYY-MM-DD by <agent/task id>

## <source title>
- URL: https://...
- Publisher/author: ...
- Used for: <item ids or "all">
- Trust: primary | reference | community
- Notes: <optional; conflicts between sources, how you resolved them>
```

Every URL in an item's `sources` / `source_urls` must also appear here. Image attributions live in the JSON, not here.
