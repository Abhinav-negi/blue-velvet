## Capture
Purpose: get spoken or typed thoughts into the app with as few taps as possible, without ever losing them.

Features:
- [MVP] Mic dock: a 64 dp amber button, bottom centre, on every screen. Tap to start; long-press for hold-to-talk.
- [MVP] Listening sheet: pulsing ember dot, timer, live waveform, live words as you speak (on-device recognizer).
- [MVP] Accurate transcript: the recorded audio goes to Gemini for the final transcript when online; audio is deleted afterwards.
- [MVP] Text input with the same behaviour as voice.
- [MVP] Scope label: "Adding to: Infinite Void" on Home, "Adding to: <Project>" inside a project; tap to change.
- [MVP] Global input that names a project ("continue the playground story…"): the app identifies the project and asks for confirmation before filing it as a proposal. If not confirmed, it stays in the Void.
- [MVP] Processing state: "Organizing…" with a slow amber progress line; dismissible; the result arrives in the Void or the proposals inbox.
- [MVP] Offline capture: the transcript and audio are saved with status `needsAi`, and processed automatically when back online.
- [MVP] Capture from anywhere (S1): Quick Settings tile, a long-press app-icon shortcut "Record idea", and the Android Share menu ("Share to Story Organizer") for text.
- [MVP] Crash-safe recording (S2): audio is written in chunks while recording, so a phone call, app kill or low battery never loses what was said.
- [MVP] Haptics: a light tick when recording starts and stops.

Notes:
- Cleaning rules (spec §4.3): remove repetition and filler, fix grammar (if permitted), order points logically, keep names and specifics, never invent.
- Raw transcript is always stored next to the cleaned summary (spec §4.1).
- Mic sharing between `speech_to_text` and `record` is unverified; see OPEN-QUESTIONS. Fallback: live waveform only while recording, transcript after.
- Must handle Indian-accented English. Locale `en-IN`.
- Decisions: D-06, D-07, D-16.
