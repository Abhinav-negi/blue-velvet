import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/fetch.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'shot_options.dart';

const _types = {
  'short_film': 'Short film',
  'long_film': 'Long film',
  'youtube': 'YouTube',
  'short': 'Short',
};

/// "Fetch from the web": ask for a template or a shot, review the draft with
/// its sources, and save to the library only on an explicit Save.
class FetchScreen extends ConsumerStatefulWidget {
  const FetchScreen({super.key, this.permissions});

  /// Overrides the global AI defaults (tests, project context).
  final Map<String, dynamic>? permissions;

  @override
  ConsumerState<FetchScreen> createState() => _FetchState();
}

class _FetchState extends ConsumerState<FetchScreen> {
  final _request = TextEditingController();
  final _url = TextEditingController();
  String _kind = 'auto';
  final _projectTypes = <String>{};
  FetchOutcome? _draft;
  String? _error;
  bool _busy = false;
  bool _saved = false;

  @override
  void dispose() {
    _request.dispose();
    _url.dispose();
    super.dispose();
  }

  Future<void> _fetch(Map<String, dynamic> perms) async {
    final q = _request.text.trim();
    if (q.isEmpty || !aiAllowed(perms, AiPermission.internetFetch)) return;
    final pasted = Uri.tryParse(_url.text.trim());
    setState(() {
      _busy = true;
      _error = null;
      _draft = null;
      _saved = false;
    });
    try {
      final r = await FetchConvert(ref.read(aiClientProvider)).run(
        q,
        kind: _kind,
        projectTypes: _projectTypes.toList(),
        pastedUrls: [if (pasted != null && pasted.hasScheme) pasted],
        permissions: perms,
      );
      if (mounted) setState(() => _draft = r);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    var d = _draft!;
    if (d is TemplateDraft && _projectTypes.isNotEmpty) {
      d = TemplateDraft(
        d.name,
        d.description,
        _projectTypes.toList(),
        d.slots,
        d.sources,
      );
    }
    await saveFetchDraft(ref.read(dbProvider), d);
    if (mounted) {
      setState(() {
        _draft = null;
        _saved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final perms =
        widget.permissions ?? ref.watch(aiDefaultsProvider).value ?? const {};
    final on = aiAllowed(perms, AiPermission.internetFetch);
    final scheme = Theme.of(context).colorScheme;
    final muted = AppType.caption.copyWith(color: scheme.onSurfaceVariant);
    final d = _draft;
    return Scaffold(
      appBar: AppBar(title: const Text('Fetch from the web')),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          if (!on)
            Text(
              'Internet fetch is off. Turn it on in AI permissions to use this.',
              style: muted,
            ),
          TextField(
            controller: _request,
            enabled: on,
            decoration: const InputDecoration(
              hintText: 'e.g. Save the Cat beat sheet, or dolly zoom',
            ),
          ),
          const SizedBox(height: AppSpace.s1),
          TextField(
            controller: _url,
            enabled: on,
            decoration: const InputDecoration(hintText: 'Page URL (optional)'),
          ),
          const SizedBox(height: AppSpace.s1),
          Wrap(
            spacing: AppSpace.s1,
            children: [
              for (final k in const ['auto', 'template', 'shot'])
                ChoiceChip(
                  label: Text(k == 'auto' ? 'Either' : k),
                  selected: _kind == k,
                  onSelected: on ? (_) => setState(() => _kind = k) : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s1),
          Text('Project type', style: muted),
          Wrap(
            spacing: AppSpace.s1,
            children: [
              for (final e in _types.entries)
                FilterChip(
                  label: Text(e.value),
                  selected: _projectTypes.contains(e.key),
                  onSelected: on
                      ? (v) => setState(
                          () => v
                              ? _projectTypes.add(e.key)
                              : _projectTypes.remove(e.key),
                        )
                      : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s1),
          FilledButton(
            onPressed: on && !_busy ? () => _fetch(perms) : null,
            child: Text(_busy ? 'Fetching...' : 'Fetch'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s1),
              child: Text(_error!, style: TextStyle(color: scheme.error)),
            ),
          if (_saved)
            const Padding(
              padding: EdgeInsets.only(top: AppSpace.s1),
              child: Text('Saved to your library.'),
            ),
          if (d is CannotConvert)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s1),
              child: Text("Couldn't convert this: ${d.reason}"),
            ),
          if (d != null && d is! CannotConvert) ...[
            const SizedBox(height: AppSpace.s2),
            _Preview(d),
            const SizedBox(height: AppSpace.s1),
            Row(
              children: [
                FilledButton(onPressed: _save, child: const Text('Save')),
                const SizedBox(width: AppSpace.s1),
                TextButton(
                  onPressed: () => setState(() => _draft = null),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview(this.d);
  final FetchOutcome d;

  @override
  Widget build(BuildContext context) {
    final muted = AppType.caption.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final (name, desc, extra, sources) = switch (d) {
      TemplateDraft t => (
        t.name,
        t.description,
        [
          for (final s in t.slots)
            '${s.name}${s.runtimeProportion == null ? '' : ' (${(s.runtimeProportion! * 100).round()}%)'}: ${s.description}',
        ],
        t.sources,
      ),
      ShotDraft s => (
        s.name,
        s.description,
        ['Category: ${s.category}', 'When to use: ${s.whenToUse}', s.effect],
        s.sources,
      ),
      CannotConvert() => ('', '', <String>[], <Map<String, String>>[]),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Draft, not saved', style: muted),
        Text(name, style: AppType.heading),
        Text(desc),
        for (final e in extra) Text(e, style: muted),
        const SizedBox(height: AppSpace.s1),
        Text('Sources', style: muted),
        for (final s in sources) Text('${s['title']}: ${s['url']}'),
      ],
    );
  }
}
