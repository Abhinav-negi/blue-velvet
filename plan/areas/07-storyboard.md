## Storyboard
Purpose: hand-drawn frames per beat, with precise S Pen drawing and shot details.

Features:
- [MVP] Frames per beat: any number, ordered; reorder, duplicate, delete.
- [MVP] Frame data: drawing, shot details (size, angle, movement, lens feel, duration), notes, optional link to a screenplay block, characters in frame, reference images, optional shot-library entry.
- [MVP] Frame caption under each frame (shot type, beat link, note).
- [MVP] Full-screen drawing on a paper canvas that respects the project aspect ratio; each frame can override it; works in portrait and landscape.
- [MVP] Aspect ratio choices from library R7.
- [MVP] Composition guides, each toggleable: rule of thirds, golden ratio/spiral, centre cross, diagonals, title-safe and action-safe (geometry from library R7).
- [MVP] Pen tools: stroke size, colours, eraser, undo/redo, zoom and pan.
- [MVP] Stylus: pressure sensitivity, palm rejection, S Pen side button held = eraser.
- [MVP] Finger mode: everything works without a stylus; a toggle switches stylus mode and finger mode. In stylus mode, finger pans.
- [MVP] Shape assist: hold at the end of a stroke and it snaps to a straight line, circle, ellipse, rectangle or arrow; toggle in the tool pill.
- [MVP] Ruler for perfect lines.
- [MVP] Two layers: sketch and clean.
- [MVP] Collapsible floating tool pill (pen, eraser, shape assist, guides, undo), hidden by default while drawing.

Notes:
- Drawings are stored losslessly as stroke data (points, pressure, tool, layer) in a JSON file per frame, never only as images (spec §17).
- The AI never draws storyboards.
- Side-button detection is unverified (OPEN-QUESTIONS). Stylus features switch on only when a stylus is detected (D-02).
- Spec §10.3, §10.4; design.md §8.5. Decisions: D-09, D-18.
