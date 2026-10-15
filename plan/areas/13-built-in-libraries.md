## Built-in libraries (research)
Purpose: ship the app with rich reference data on day one. Each library is produced by a **research task**: an agent gathers trusted sources and writes a seed data file. The app loads seed files into the database on first launch.

Output per research task:
- `assets/seed/<name>.json`, matching the schema below
- `assets/seed/sources/<name>.md`: every source used, with links
- images (R2 only) in `assets/seed/images/`, each with license, author and source URL recorded in the JSON

Features:
- [MVP][Research] **R1 Story templates**: three-act, 8-sequence, Save the Cat, Hero's Journey, 5-point (setup, inciting moment, escalation, climax, resolution), Dan Harmon's Story Circle, Kishōtenketsu, plus YouTube video and Shorts structures. Each: name, description, source link, suitable project types, ordered slots (name, description, runtime proportion).
- [MVP][Research] **R2 Shot library**: shot sizes, angles, camera movements, composition, lens feel, lighting. Each: name, category, description, when to use, emotional/narrative effect, tags, sources, and free-license reference images (Wikimedia Commons, public domain or Creative Commons) where a good one exists; text-only otherwise.
- [MVP][Research] **R3 Screenplay format rules**: element margins and indents, capitalisation rules, transitions list, page and continuation rules, and Fountain syntax. Used by the editor and by PDF/Fountain export.
- [MVP][Research] **R4 Project-type defaults**: typical length, default template, writing section, aspect ratio and type-specific fields for short film, long film, YouTube video and Short, checked against current practice.
- [MVP][Research] **R5 Song structures**: verse, pre-chorus, chorus, bridge, hook, intro, outro, with common arrangements. Used for Lyric items in the Void.
- [MVP][Research] **R6 Relationship labels**: starter set for the character map, grouped (family, social, romantic, professional, conflict, debt/obligation).
- [MVP][Research] **R7 Aspect ratios and composition guides**: ratio list (2.39:1, 1.85:1, 16:9, 4:3, 1:1, 9:16 and others in common use) and exact geometry for rule of thirds, golden ratio/spiral, centre cross, diagonals, title-safe and action-safe areas.

Notes:
- Libraries are data, not code (spec principle 5, D-14). Seed entries use the same format as entries fetched from the web, so built-in and fetched entries behave identically.
- Built-in entries are editable by the user; edits are kept when the app updates.
- Research tasks only write files under `assets/seed/`, so they can run in parallel with app work.
- No copyrighted film stills in the seed set (D-15).
