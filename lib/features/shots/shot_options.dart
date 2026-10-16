import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/fetch.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/ai_defaults.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'shot_providers.dart';

/// Global AI defaults (`settings.ai_permission_defaults`). The library has no
/// project, so a project's own switches are passed in by the caller instead.
final aiDefaultsProvider = FutureProvider<Map<String, dynamic>>(
  (ref) => newProjectAiPermissions(ref.watch(dbProvider)),
);

/// A library entry the model picked, or a draft fetched from the web.
class ShotSuggestion {
  const ShotSuggestion.library(this.shot, this.why) : draft = null;
  const ShotSuggestion.fetched(this.draft) : shot = null, why = '';
  final Shot? shot;
  final ShotDraft? draft;
  final String why;
}

/// Library options for [question]; with internet_fetch on, also converts what
/// the model asked to look up into drafts. Nothing is saved (SHOT-04 does that).
Future<List<ShotSuggestion>> askShotOptions(
  AiClient ai,
  String question,
  List<Shot> library, {
  String frameContext = '',
  Map<String, dynamic> permissions = const {},
}) async {
  final res = await shotOptions(
    ai,
    question,
    [
      for (final s in library)
        LibraryShot(s.id, s.name, s.category.name, s.description),
    ],
    frameContext: frameContext,
    permissions: permissions,
  );
  final byId = {for (final s in library) s.id: s};
  final out = <ShotSuggestion>[
    for (final o in res.options) ShotSuggestion.library(byId[o.shotId]!, o.why),
  ];
  for (final q in res.wantsFetch.take(2)) {
    try {
      final r = await FetchConvert(ai)
          .run(q, kind: 'shot', permissions: permissions);
      if (r is ShotDraft) out.add(ShotSuggestion.fetched(r));
    } on AiException {
      // a failed fetch only loses that draft
    }
  }
  return out;
}

/// Ask box + results. Used by [ShotOptionsScreen]; a storyboard frame can embed
/// it with its own [frameContext] and project [permissions].
class ShotOptionsPanel extends ConsumerStatefulWidget {
  const ShotOptionsPanel({super.key, this.frameContext = '', this.permissions});
  final String frameContext;
  final Map<String, dynamic>? permissions;

  @override
  ConsumerState<ShotOptionsPanel> createState() => _PanelState();
}

class _PanelState extends ConsumerState<ShotOptionsPanel> {
  final _ctl = TextEditingController();
  List<ShotSuggestion>? _results;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _ask(Map<String, dynamic> perms) async {
    final q = _ctl.text.trim();
    if (q.isEmpty || !aiAllowed(perms, AiPermission.shotSuggestions)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await askShotOptions(
        ref.read(aiClientProvider),
        q,
        ref.read(shotsProvider).value ?? const [],
        frameContext: widget.frameContext,
        permissions: perms,
      );
      if (mounted) setState(() => _results = r);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(shotsProvider); // keep the library stream alive for _ask
    final perms =
        widget.permissions ?? ref.watch(aiDefaultsProvider).value ?? const {};
    final on = aiAllowed(perms, AiPermission.shotSuggestions);
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(AppSize.sideMargin),
      children: [
        if (!on)
          Text(
            'Shot suggestions are off. Turn them on in AI permissions to ask.',
            style: AppType.caption.copyWith(color: scheme.onSurfaceVariant),
          ),
        TextField(
          controller: _ctl,
          enabled: on,
          decoration: const InputDecoration(
            hintText: 'What shots work for a tense standoff?',
          ),
          onSubmitted: (_) => _ask(perms),
        ),
        const SizedBox(height: AppSpace.s1),
        FilledButton(
          onPressed: on && !_busy ? () => _ask(perms) : null,
          child: Text(_busy ? 'Asking...' : 'Ask'),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s1),
            child: Text(_error!, style: TextStyle(color: scheme.error)),
          ),
        if (_results != null && _results!.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: AppSpace.s1),
            child: Text('No suggestions.'),
          ),
        for (final s in _results ?? const <ShotSuggestion>[])
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s1),
            child: _SuggestionTile(s),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile(this.s);
  final ShotSuggestion s;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final d = s.draft;
    final name = d?.name ?? s.shot!.name;
    final body = d?.description ?? s.why;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: ListTile(
        title: Text(name, style: AppType.heading),
        subtitle: Text(
          [
            d == null ? 'From your library' : 'Fetched draft, not saved',
            body,
            if (d != null) 'Source: ${d.sources.first['url']}',
          ].join('\n'),
          style: AppType.caption.copyWith(color: scheme.onSurfaceVariant),
        ),
        isThreeLine: true,
      ),
    );
  }
}

/// Full-screen "ask for shot options".
class ShotOptionsScreen extends StatelessWidget {
  const ShotOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Shot options')),
    body: const ShotOptionsPanel(),
  );
}
