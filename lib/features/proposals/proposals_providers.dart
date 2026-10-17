import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/organize.dart' show splitSentences;
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/project_context.dart';
import 'package:lynch/core/data/proposal_engine.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/widgets/diff_view.dart';

/// Pending proposals across all projects, oldest first.
final pendingProposalsProvider = StreamProvider<List<Proposal>>(
  (ref) =>
      (ref.watch(dbProvider).select(ref.watch(dbProvider).proposals)
            ..where((t) => t.status.equalsValue(ProposalStatus.pending))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch(),
);

final proposalProvider = StreamProvider.family<Proposal?, String>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(
    db.proposals,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();
});

/// A project's snapshots, newest first.
final snapshotsProvider = StreamProvider.family<List<Snapshot>, String>((
  ref,
  projectId,
) {
  final db = ref.watch(dbProvider);
  return (db.select(db.snapshots)
        ..where((t) => t.projectId.equals(projectId))
        ..orderBy([
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ]))
      .watch();
});

final snapshotProvider = FutureProvider.family<Snapshot, String>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.snapshots)..where((t) => t.id.equals(id))).getSingle();
});

final projectTitleProvider = FutureProvider.family<String, String>((
  ref,
  id,
) async {
  final db = ref.watch(dbProvider);
  final p = await (db.select(
    db.projects,
  )..where((t) => t.id.equals(id))).getSingleOrNull();
  return p?.title ?? '';
});

const _groups = {
  'addBeat': ('Beats', 'added'),
  'editBeat': ('Beats', 'changed'),
  'splitBeat': ('Beats', 'split'),
  'mergeBeats': ('Beats', 'merged'),
  'moveBeat': ('Beats', 'moved'),
  'placeBeatInSlot': ('Beats', 'placed'),
  'addCharacter': ('Characters', 'added'),
  'editCharacter': ('Characters', 'changed'),
  'setSummary': ('Summary', 'changed'),
  'addScaffold': ('Script', 'drafted'),
};

/// "Beats · 2 added, 1 changed" (design.md 8.2), one segment per area.
String touchHeader(List<dynamic> changes) {
  final counts = <String, Map<String, int>>{};
  for (final c in changes.cast<Map>()) {
    final g = _groups[c['op']] ?? ('Other', 'changed');
    final m = counts.putIfAbsent(g.$1, () => {});
    m[g.$2] = (m[g.$2] ?? 0) + 1;
  }
  return [
    for (final e in counts.entries)
      '${e.key} · ${e.value.entries.map((x) => '${x.value} ${x.key}').join(', ')}',
  ].join('  |  ');
}

/// One diff entry per change, looking up current text for edits.
/// ponytail: editCharacter shows the new fields only (no before text);
/// look the sheet up when the diff needs to be exact.
final changeLinesProvider = FutureProvider.family<List<List<DiffLine>>, String>(
  (ref, id) async {
    final db = ref.watch(dbProvider);
    final p = await (db.select(
      db.proposals,
    )..where((t) => t.id.equals(id))).getSingle();
    final out = <List<DiffLine>>[];
    for (final c in p.changes.cast<Map>()) {
      out.add(await _lines(db, p.projectId, c));
    }
    return out;
  },
);

String _beatText(Object? title, Object? desc) =>
    [title, desc].where((x) => x != null && '$x'.isNotEmpty).join(': ');

Future<List<DiffLine>> _lines(AppDatabase db, String projectId, Map c) async {
  switch (c['op']) {
    case 'addBeat':
      return [DiffLine.added(_beatText(c['title'], c['description']))];
    case 'editBeat':
      final id = c['beat_id'] as String?;
      final b = id == null
          ? null
          : await (db.select(
              db.beats,
            )..where((t) => t.id.equals(id))).getSingleOrNull();
      final after = _beatText(
        c['title'] ?? b?.title,
        c['description'] ?? b?.description,
      );
      return b == null
          ? [DiffLine.added(after)]
          : [
              DiffLine.changed(
                before: _beatText(b.title, b.description),
                after: after,
              ),
            ];
    case 'splitBeat':
      return [
        for (final p in (c['parts'] as List).cast<Map>())
          DiffLine.added(_beatText(p['title'], p['description'])),
      ];
    case 'mergeBeats':
      return [DiffLine.added(_beatText(c['title'], c['description']))];
    case 'moveBeat' || 'placeBeatInSlot':
      return [const DiffLine.added('Move a beat')];
    case 'addCharacter':
      return [DiffLine.added('Character: ${c['name']}')];
    case 'editCharacter':
      return [
        for (final e in ((c['fields'] ?? {}) as Map).entries)
          DiffLine.added('${e.key}: ${e.value}'),
      ];
    case 'setSummary':
      final p = await (db.select(
        db.projects,
      )..where((t) => t.id.equals(projectId))).getSingleOrNull();
      return p == null || p.summary.isEmpty
          ? [DiffLine.added('${c['text']}')]
          : [DiffLine.changed(before: p.summary, after: '${c['text']}')];
    case 'addScaffold':
      final items = (c['blocks'] ?? c['rows']) as List;
      return [
        for (final i in items.cast<Map>())
          DiffLine.added('${i['text'] ?? (i['show'] as Map).values.join(' ')}'),
      ];
    default:
      return [DiffLine.added('${c['op']}')];
  }
}

/// All writes the review screen makes. Project content only changes through
/// [ProposalEngine.approve] (D-17); the rest edit the proposal row itself.
class ProposalActions {
  ProposalActions(this.db) : engine = ProposalEngine(db);
  final AppDatabase db;
  final ProposalEngine engine;

  Future<void> _write(String id, ProposalsCompanion c) =>
      (db.update(db.proposals)..where((t) => t.id.equals(id))).write(c);

  /// Stores the per-change choices, then approves. Returns the engine's notes.
  Future<List<String>> approve(String id, List<bool> accepted) async {
    final p = await (db.select(
      db.proposals,
    )..where((t) => t.id.equals(id))).getSingle();
    await _write(
      id,
      ProposalsCompanion(
        changes: Value([
          for (var i = 0; i < p.changes.length; i++)
            {
              ...(p.changes[i] as Map).cast<String, dynamic>(),
              'accepted': accepted[i],
            },
        ]),
      ),
    );
    return engine.approve(id);
  }

  /// "Ask for changes": the AI returns a full replacement for a pending
  /// proposal's summary, spans and ops. Only the proposal row changes (D-17).
  /// Returns the AI's drop notes.
  Future<List<String>> revise(
    String id,
    String instruction,
    AiClient ai,
  ) async {
    final p = await (db.select(
      db.proposals,
    )..where((t) => t.id.equals(id))).getSingle();
    if (p.status != ProposalStatus.pending) {
      throw ProposalException('Only a pending proposal can be revised.');
    }
    final proj = await (db.select(
      db.projects,
    )..where((t) => t.id.equals(p.projectId))).getSingle();
    final draft = await reviseProposal(
      ai,
      proposal: {
        'raw_transcript': p.rawTranscript,
        'summary_sentences': splitSentences(p.summary),
        'changes': p.changes,
      },
      instruction: instruction,
      context: await projectContext(db, proj),
      permissions: proj.aiPermissions,
    );
    await _write(
      id,
      ProposalsCompanion(
        summary: Value(draft.summary),
        summarySpans: Value([for (final s in draft.spans) s.toJson()]),
        changes: Value(draft.changes),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    return draft.notes;
  }

  Future<void> editSummary(String id, String text) =>
      _write(id, ProposalsCompanion(summary: Value(text)));

  /// Marks rejected; [toVoid] also files the words as a Void item.
  Future<void> reject(String id, {required bool toVoid}) async {
    final p = await (db.select(
      db.proposals,
    )..where((t) => t.id.equals(id))).getSingle();
    final t = DateTime.now().millisecondsSinceEpoch;
    String? voidId;
    if (toVoid) {
      voidId = engine.newId();
      await db
          .into(db.voidItems)
          .insert(
            VoidItemsCompanion.insert(
              id: voidId,
              type: VoidType.other,
              summary: p.summary,
              rawTranscript: p.rawTranscript,
              summarySpans: p.summarySpans,
              structure: const {},
              tags: const [],
              usedInProjectIds: const [],
              status: VoidStatus.ready,
              createdAt: t,
              updatedAt: t,
            ),
          );
    }
    await _write(
      id,
      ProposalsCompanion(
        status: const Value(ProposalStatus.rejected),
        rejectedToVoidItemId: Value(voidId),
        resolvedAt: Value(t),
        updatedAt: Value(t),
      ),
    );
  }

  /// Undo the project's latest approve (engine throws ProposalException when unsafe).
  Future<void> undo(String projectId) => engine.undoLastApprove(projectId);

  /// Restores a snapshot; the engine adds "Before restore" + "Restored" entries.
  Future<void> restore(String snapshotId) =>
      engine.snapshots.restore(snapshotId);
}

final proposalActionsProvider = Provider(
  (ref) => ProposalActions(ref.watch(dbProvider)),
);
