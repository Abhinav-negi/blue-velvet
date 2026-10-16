import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/key_store.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/ai/scaffold.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

/// Local AI client for the script tab. Tests override it with a fake.
final scriptAiProvider = Provider<AiClient>(
  (ref) => AiClient(readStoredKey: readSecureGeminiKey),
);

bool beatIsEmpty(Beat b) =>
    (b.blocks ?? const []).isEmpty && (b.sayShow ?? const []).isEmpty;

/// Appends an accepted [draft] to the beat (scaffold: true) and returns the
/// beat as saved. This is the only place a suggestion reaches the DB.
Future<Beat> acceptScaffold(
  AppDatabase db,
  Beat beat,
  ScaffoldDraft draft,
) async {
  const uuid = Uuid();
  final cur = await (db.select(
    db.beats,
  )..where((b) => b.id.equals(beat.id))).getSingle();
  await (db.update(db.beats)..where((b) => b.id.equals(beat.id))).write(
    BeatsCompanion(
      blocks: draft.blocks.isEmpty
          ? const Value.absent()
          : Value([
              ...?cur.blocks,
              for (final b in draft.blocks)
                {
                  'id': uuid.v4(),
                  'type': b.type,
                  'text': b.text,
                  'scaffold': true,
                  'ai_suggested': false,
                },
            ]),
      sayShow: draft.rows.isEmpty
          ? const Value.absent()
          : Value([
              ...?cur.sayShow,
              for (final r in draft.rows)
                {
                  'id': uuid.v4(),
                  'say': '',
                  'show': r.show,
                  'scaffold': true,
                  'ai_suggested': false,
                },
            ]),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );
  return (db.select(db.beats)..where((b) => b.id.equals(beat.id))).getSingle();
}

/// Strip under the editor: "Suggest structure" button plus the pending
/// suggestion. A beat seen empty is scaffolded once automatically when
/// `screenplay_scaffold` is on (beats are created in another feature, so the
/// script tab detects the new, empty beat). Nothing is saved until Accept.
class ScaffoldSuggestions extends ConsumerStatefulWidget {
  const ScaffoldSuggestions({
    super.key,
    required this.beat,
    required this.project,
    required this.auto,
    required this.onAccepted,
  });
  final Beat beat;
  final Project project;

  /// Draft on creation (first time this empty beat is seen).
  final bool auto;
  final ValueChanged<Beat> onAccepted;

  @override
  ConsumerState<ScaffoldSuggestions> createState() => _State();
}

class _State extends ConsumerState<ScaffoldSuggestions> {
  ScaffoldDraft? _draft;
  bool _busy = false;
  bool _failed = false;

  bool get _allowed =>
      aiAllowed(widget.project.aiPermissions, AiPermission.screenplayScaffold);

  @override
  void initState() {
    super.initState();
    if (widget.auto && _allowed && beatIsEmpty(widget.beat)) _ask();
  }

  Future<void> _ask() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final b = widget.beat;
    try {
      final d = await scaffoldBeat(
        ref.read(scriptAiProvider),
        beat: {
          'id': b.id,
          'title': b.title,
          'description': b.description,
          'character_names': const <String>[],
          'project_type': widget.project.type.name.replaceAllMapped(
            RegExp('[A-Z]'),
            (m) => '_${m[0]!.toLowerCase()}',
          ), // shortFilm -> short_film
        },
        facts: '${b.title}. ${b.description}',
        existing: beatIsEmpty(b) ? '' : 'The beat already has text.',
        permissions: widget.project.aiPermissions,
      );
      if (mounted) setState(() => _draft = d);
    } on Exception {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _accept() async {
    final saved = await acceptScaffold(
      ref.read(dbProvider),
      widget.beat,
      _draft!,
    );
    if (!mounted) return;
    setState(() => _draft = null);
    widget.onAccepted(saved);
  }

  @override
  Widget build(BuildContext context) {
    if (!_allowed) return const SizedBox.shrink();
    final d = _draft;
    final lines = d == null
        ? const <String>[]
        : [
            for (final b in d.blocks) b.text,
            for (final r in d.rows)
              r.show.values.where((v) => v.isNotEmpty).join(' / '),
          ];
    return Padding(
      padding: const EdgeInsets.all(AppSpace.s1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (d != null) ...[
            for (final (i, l) in lines.indexed)
              Text(l, key: ValueKey('suggestion-$i'), style: AppType.proposal),
            if (d.ungrounded)
              Text('Check this: not in what you said.', style: AppType.caption),
            Row(
              children: [
                TextButton(
                  key: const ValueKey('accept-suggestion'),
                  onPressed: _accept,
                  child: const Text('Accept'),
                ),
                TextButton(
                  key: const ValueKey('dismiss-suggestion'),
                  onPressed: () => setState(() => _draft = null),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ] else if (_failed)
            Text(
              'The AI could not do that. Try again.',
              style: AppType.caption,
            ),
          if (d == null)
            TextButton.icon(
              key: const ValueKey('suggest-structure'),
              onPressed: _busy ? null : _ask,
              icon: const Icon(Icons.auto_awesome),
              label: Text(_busy ? 'Thinking...' : 'Suggest structure'),
            ),
        ],
      ),
    );
  }
}
