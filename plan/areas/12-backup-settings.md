## Backup and settings
Purpose: no data loss, and user control over what the AI does.

Features:
- [MVP] Sign in with Google (only for Drive backup).
- [MVP] Backup: zip of the database and files folder uploaded to the Drive `appDataFolder`; manual button first, then automatic after changes when online.
- [MVP] Restore on a new or wiped phone: everything comes back, including drawings.
- [MVP] Per-project AI permissions: auto-summary, character extraction, beat generation, auto-placement, screenplay scaffold on new beat, grammar cleanup, shot suggestions, internet fetch.
- [MVP] Global AI defaults that new projects inherit.
- [MVP] Gemini API key entry (stored on the device, never in source control).
- [MVP] Theme: dark frame (default) or light frame; paper surfaces stay the same in both.
- [MVP] Respect the system "Remove animations" setting and font scaling up to 1.3×.

Notes:
- `appDataFolder` is a hidden, app-only area of the user's own Drive: free and private.
- With an AI permission off, that work is left for the user to do by hand.
- Spec §14, §17; design.md §13. Decisions: D-03, D-05, D-06.
