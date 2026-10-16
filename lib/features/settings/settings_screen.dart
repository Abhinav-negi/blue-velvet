import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/key_store.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'settings_providers.dart';

const _labels = <AiPermission, String>{
  AiPermission.autoSummary: 'Auto-summary',
  AiPermission.characterExtraction: 'Character extraction',
  AiPermission.beatGeneration: 'Beat generation',
  AiPermission.autoPlacement: 'Auto-placement',
  AiPermission.screenplayScaffold: 'Screenplay scaffold',
  AiPermission.grammarCleanup: 'Grammar cleanup',
  AiPermission.shotSuggestions: 'Shot suggestions',
  AiPermission.internetFetch: 'Internet fetch',
};

/// Project Settings tab ([projectId] set) plus the global settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, this.projectId});
  final String? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final theme = Theme.of(context);
    final light = ref.watch(themeModeProvider).value == ThemeMode.light;
    final defaults = ref.watch(globalAiDefaultsProvider).value;
    final project = projectId == null
        ? null
        : ref.watch(projectAiPermissionsProvider(projectId!)).value;

    Widget heading(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpace.s3, 0, AppSpace.s1),
      child: Text(t, style: theme.textTheme.titleMedium),
    );
    Widget switches(
      Map<String, dynamic> values,
      Future<void> Function(AiPermission, bool) onSet,
      String prefix,
    ) => Column(
      children: [
        for (final p in AiPermission.values)
          SwitchListTile(
            key: ValueKey('$prefix-${p.key}'),
            title: Text(_labels[p]!),
            value: aiAllowed(values, p),
            onChanged: (v) => onSet(p, v),
          ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.all(AppSize.sideMargin),
      children: [
        Text('Settings', style: theme.textTheme.headlineSmall),
        if (project != null) ...[
          heading('AI permissions for this project'),
          switches(
            project,
            (p, v) => setProjectAiPermission(db, projectId!, p, v),
            'project',
          ),
        ],
        heading('Defaults for new projects'),
        if (defaults != null)
          switches(defaults, (p, v) => setGlobalAiDefault(db, p, v), 'default'),
        heading('Appearance'),
        SwitchListTile(
          key: const ValueKey('theme-light'),
          title: const Text('Light theme'),
          value: light,
          onChanged: (v) => setTheme(db, v),
        ),
        heading('Gemini API key'),
        const _ApiKeyTile(),
      ],
    );
  }
}

class _ApiKeyTile extends StatefulWidget {
  const _ApiKeyTile();

  @override
  State<_ApiKeyTile> createState() => _ApiKeyTileState();
}

class _ApiKeyTileState extends State<_ApiKeyTile> {
  final _ctl = TextEditingController();
  String? _stored;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    String? k;
    try {
      k = await readSecureGeminiKey();
    } catch (_) {
      // Storage unavailable (e.g. no platform plugin): show "Not set".
    }
    if (mounted) setState(() => _stored = k);
  }

  Future<void> _save(String? key) async {
    await writeSecureGeminiKey(key?.trim());
    _ctl.clear();
    await _load();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stored = _stored;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stored == null || stored.isEmpty ? 'Not set' : maskKey(stored)),
        TextField(
          controller: _ctl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Paste new key'),
          onSubmitted: _save,
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => _save(_ctl.text),
              child: const Text('Save key'),
            ),
            if (stored != null && stored.isNotEmpty)
              TextButton(
                onPressed: () => _save(null),
                child: const Text('Remove key'),
              ),
          ],
        ),
      ],
    );
  }
}
