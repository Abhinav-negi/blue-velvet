## Proposals and history
Purpose: the pull-request flow. Nothing changes a project until the user approves, and every merge can be undone.

Features:
- [MVP] Proposal stack per project, oldest first; amber count badge on the inbox icon.
- [MVP] Proposal view: clean summary, raw transcript ("Show what I said"), and a header of what it touches ("Beats · 2 added, 1 changed").
- [MVP] Diff preview: added text with a sage left rule and faint sage background; removed text struck through in ember (red pencil on paper); changed text shows removed above added. AI-suggested text in Literata italic with an amber left rule.
- [MVP] Accept or reject each change individually; "Approve all" (amber primary) and "Reject" buttons.
- [MVP] Edit the proposal text by hand.
- [MVP] Ask for changes ("drop the part about the dog", "make this a new beat instead").
- [MVP] Reject: discard, or send to the Void (user's choice).
- [MVP] Defer: leave it in the stack.
- [MVP] Approve: apply the change operations, save a snapshot, medium haptic, cards settle into place.
- [MVP] Undo after approve (S3): an "Undo" bar for a few seconds after merging, which restores the previous snapshot.
- [MVP] "Where did this come from?" (S4): tap a sentence and the matching transcript words are highlighted.
- [MVP] History: list of snapshots; view the project as it was; restore (restoring also creates a snapshot).

Notes:
- A proposal is stored as typed change operations (`addBeat`, `editBeat`, `splitBeat`, `addCharacter`, `setSummary`, `addScaffold`…). Only Approve runs them (D-17).
- Snapshots store the project as JSON without drawings. Proposals never touch drawings, so snapshots stay small.
- Proposals may only append to screenplay text the user has written, never rewrite it (D-18).
- S4 needs the AI to return transcript spans per sentence; format is open (OPEN-QUESTIONS).
- Spec §8, §16.1.
