import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/ai/scaffold.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/proposal_engine.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

bool beatIsEmpty(Beat b) =>
    (b.blocks ?? const []).isEmpty && (b.sayShow ?? const []).isEmpty;

/// Accepting a suggestion = a one-op pending `addScaffold` proposal that is
/// approved at once, so the proposal engine stays the only writer (D-17/D-18,
/// History/Undo). Returns the beat as saved.
Future<Beat> acceptScaffold(
  AppDatabase db,
  Beat beat,
  ScaffoldDraft draft,
) async {
  const uuid = Uuid();
  final now = DateTime.now().millisecondsSinceEpoch;
  final id = uuid.v4();
  await db
      .into(db.proposals)
      .insert(
        ProposalsCompanion.insert(
          id: id,
          projectId: beat.projectId,
          status: ProposalStatus.pending,
          summary: 'Scaffold for ${beat.title}',
          rawTranscript: '',
          summarySpans: const [],
          changes: [
            {
              'id': uuid.v4(),
              'accepted': true,
              'op': 'addScaffold',
              'beat_id': beat.id,
              if (draft.blocks.isNotEmpty)
                'blocks': [
                  for (final b in draft.blocks)
                    {'type': b.type, 'text': b.text},
                ],
              if (draft.rows.isNotEmpty)
                'rows': [
                  for (final r in draft.rows) {'say': '', 'show': r.show},
                ],
            },
          ],
          createdAt: now,
          updatedAt: now,
        ),
      );
  await ProposalEngine(db).approve(id);
  return (db.select(db.beats)..where((b) => b.id.equals(beat.id))).getSingle();
}

/// Names of the beat's characters (forked copy name, else the library name).
Future<List<String>> beatCharacterNames(AppDatabase db, Beat beat) async {
  final out = <String>[];
  for (final id in beat.characterIds) {
    final pc = await (db.select(
      db.projectCharacters,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (pc == null) continue;
    final lib = pc.characterId == null
        ? null
        : await (db.select(
            db.characters,
          )..where((t) => t.id.equals(pc.characterId!))).getSingleOrNull();
    final n = pc.name ?? lib?.name;
    if (n != null) out.add(n);
  }
  return out;
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
        ref.read(aiClientProvider),
        beat: {
          'id': b.id,
          'title': b.title,
          'description': b.description,
          'character_names': await beatCharacterNames(ref.read(dbProvider), b),
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
