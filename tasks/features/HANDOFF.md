# Features notes
Read before starting work in this folder. Under 15 lines. Delete a note once it's resolved.

- DB access: read `dbProvider` (lib/core/data/providers.dart). main() opens the DB and runs the seed loader before runApp. In widget tests, override it: `ProviderScope(overrides: [dbProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))])`.
- Only templates/shots load into tables. Other seeds (project_types, aspect_ratios, guides, relationship_labels, screenplay_format…) are read from the asset bundle by the feature.
- SB-04: guides.json shapes are normalised 0–1 (line/rect/polyline). The golden spiral is a 121-point polyline stretched to the frame, so it distorts on non-golden ratios; flip/rotate for the other three corners is the canvas's job. Safe areas follow EBU R95 (action 93%, title 90%).
- Widget tests with Drift streams: seed and wait inside `tester.runAsync`, then unmount the tree and pump once at the end, otherwise "pending timer" or a hang (VOID-01 Evidence).
- No templates/shots DAOs in core: features query `db.templates`/`db.slots`/`db.shots`/`db.shotImages` directly. Riverpod 3: `StateProvider` needs `package:flutter_riverpod/legacy.dart`.
- Unlinked routes: `shots` (/shots), `templates` (/project/:projectId/beats/templates), `character-pool` (/project/:projectId/characters/pool). Add entry points when building nearby screens.
- BEAT-04: template code is `lib/features/beats/template_*.dart`; BEAT-01 links with `goNamed('templates', pathParameters: {'projectId': id})`. Seed project types are snake_case (`short_film`…).
- CHR-01: reuse `sheetProvider`, `projectMembersProvider`, `poolProvider`, `forkCompanion` (characters_providers.dart). Sheet screen `id` = project_characters id when projectId is set, else characters id.
- VOID-02: build on `voidFilterProvider`/`filteredVoidItemsProvider`; grid layout change → regenerate `test/features/void/goldens/grid.png` with `--update-goldens` and look at it. Search uses `VoidItemsDao.search` (FTS5).
- Lazy ListViews hide off-screen widgets in tests: use a tall test view or a Row in a scroll view.
- Shell tests expect each tab's title text twice (tab label + screen heading): every tab screen shows its own heading. Replacing a tab body changes `test/core/shell/goldens/*` → orchestrator regenerates them.
- AI: read `aiClientProvider` (lib/core/ai/ai_provider.dart), the one app-wide AiClient; tests override it with a MockClient-backed AiClient. Flash falls back to flash-lite on a daily-quota 429 (D-23).
- PROP-01: reuse `ProposalActions` + providers in proposals_providers.dart; review screen proposal_screen.dart. BEAT-01: beats_providers.dart (`saveBeat`, project beats, frame lookup). PROJ-03: type_fields keys per DATA_MODEL §8.2.
- Shell goldens were regenerated on master after PROJ-03; branches cut before that see 2 expected shell failures. Never commit `test/**/failures/` (now gitignored).
- SCR-01: screenplay editor writes `beats.blocks` on every edit; layout from assets/seed/screenplay_format.json; SCR-02 switches on project type at the marked spot in script_screen.dart. Features read beats via `db.beatsDao` (can't import features/beats).
- SB-01: `frames_providers.dart` (`deleteFrame` keeps stroke files), own `boardBeatsProvider`. CHR-02: `importCharacter`, `forkMember`, live `appearsInProvider`.
- Batch 4: MAP-01 route `character-map` (/project/:projectId/map) has no entry point yet (add a button on Characters). SHOT-04 route `shot-fetch` (/shots/fetch): template library (beats) should link to it. PROJ-04: `sampleInitProvider` loads the sample on Home; tests touching Home override it with a no-op. SCR-02: script tab switches Say/Show (youtube, short) vs screenplay. BEAT-02: `beat_ops.dart` (move/split/merge mirror the proposal engine).
- Golden tests must use `AppTheme` (bare ThemeData falls back to the Ahem box font).
- New projects: `aiPermissions: await newProjectAiPermissions(db)` (lib/core/data/ai_defaults.dart); home + sample already do. EXP-01: export route /project/:projectId/export, reuse `shareFileProvider`, add tiles to ExportScreen. Drift `.watch().first` hangs in testWidgets: use `.get()`.
- PROJ-02: route `project-from-idea` (/idea/:voidItemId), reached by Void "Promote to project". `createProjectFromIdea` in home/idea_project.dart.
- VOID-04: promote/send/pull done in lib/features/void (void_send.dart: sendToProject). PROJECT_CONTEXT is built by core `projectContext` (lib/core/data/project_context.dart, AI-09). Route `void-pick` is reachable from the beat board's "Pull from Void" icon button (tooltip).
- PROP-02: `ProposalActions.revise` (proposals_providers.dart) uses core `projectContext` (template slots included); screen shows summary sentences as tappable `sentence-N` keys for provenance.
