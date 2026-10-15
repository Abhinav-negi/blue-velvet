# Open questions

- What are the Gemini free-tier limits for audio transcription and for Google Search grounding? — blocks: capture (area 1), fetch and convert (area 10) — leaning: verify in phase 0 spike; if Search grounding isn't free, fetch uses a free search API or a manual URL paste.
- On the free tier, Google may use inputs to improve its products. Is that acceptable for story ideas? — blocks: nothing technical — leaning: accept for now; revisit D-06 if not.
- Can `speech_to_text` and `record` use the microphone at the same time on Android? — blocks: live words in capture (area 1) — leaning: if not, show a live waveform while recording and the transcript after.
- Can Flutter detect the S Pen side button reliably on the S25 Ultra? — blocks: side-button eraser (area 7) — leaning: verify in phase 0; fallback is an eraser toggle in the tool pill.
- Minimum Android version? — blocks: project setup (phase 1) — leaning: Android 8 (API 26).
- What output format does the AI use to map each summary sentence to transcript spans (for S4)? — blocks: "where did this come from" (areas 2 and 4) — leaning: character offsets into the raw transcript, returned with each sentence in the JSON.
