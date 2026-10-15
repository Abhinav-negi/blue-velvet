## Character map
Purpose: a hand-drawn graph of how a project's characters connect.

Features:
- [MVP] Per-project canvas: characters as nodes (circles with initials), relationships as labelled lines.
- [MVP] Relationship labels: free text, with quick picks from library R6.
- [MVP] Drag nodes freely; positions are saved; no auto-physics.
- [MVP] Group and colour-code nodes (muted tints of the palette only).
- [MVP] Tap a node to open that character's sheet.
- [MVP] Zoom and pan.

Notes:
- Drawn entirely by the user. No AI generation.
- Stored as one JSON record per project (nodes, edges, positions, groups).
- Spec §12; design.md §8.6.
