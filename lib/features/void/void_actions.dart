import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/organize.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/widgets/diff_view.dart';

VoidType _typeOf(String s) => VoidType.values[itemTypes.indexOf(s)];

/// The AI's proposed new version of an item (a patch, never applied by itself).
/// [type] is forced when the user picked it via "change type".
Future<ItemEdit> proposeItemEdit(
  AiClient ai,
  VoidItem it,
  String instruction, {
  String? forceType,
}) async {
  final e = await editItem(
    ai,
    type: itemTypes[it.type.index],
    summary: it.summary,
    rawTranscript: it.rawTranscript,
    structure: it.structure,
    tags: it.tags,
    instruction: instruction,
  );
  final d = e.item;
  if (d == null || forceType == null) return e;
  return ItemEdit.patch(
    ItemDraft(
      type: forceType,
      summary: d.summary,
      spans: d.spans,
      structure: d.structure,
      tags: d.tags,
    ),
  );
}

/// Instruction sent to the AI when the user changes the type.
String changeTypeInstruction(String typeLabel) =>
    'Change this item\'s type to $typeLabel and re-apply that type\'s '
    'structure. Keep the user\'s words; do not add anything.';

/// Diff rows between [it] and [d] for the approve sheet.
List<DiffLine> itemDiff(VoidItem it, ItemDraft d) {
  DiffLine? row(String label, String a, String b) => a == b
      ? null
      : DiffLine.changed(before: '$label: $a', after: '$label: $b');
  return [
    row('Type', itemTypes[it.type.index], d.type),
    row('Summary', it.summary, d.summary),
    row('Tags', it.tags.join(', '), d.tags.join(', ')),
    row('Structure', jsonEncode(it.structure), jsonEncode(d.structure)),
  ].whereType<DiffLine>().toList();
}

/// Writes an approved AI draft. raw_transcript never changes.
Future<void> applyDraft(AppDatabase db, VoidItem it, ItemDraft d) =>
    db.voidItemsDao.upsert(
      _row(
        it,
        type: _typeOf(d.type),
        summary: d.summary,
        spans: [for (final s in d.spans) s.toJson()],
        structure: d.structure,
        tags: d.tags,
      ),
    );

/// Hand edit: a new summary invalidates the S4 spans, so they are cleared.
Future<void> saveManual(
  AppDatabase db,
  VoidItem it, {
  required String summary,
  required List<String> tags,
}) => db.voidItemsDao.upsert(
  _row(
    it,
    summary: summary,
    spans: summary == it.summary ? it.summarySpans : const [],
    tags: tags,
  ),
);

/// Merges [others] into [keep]: summaries and transcripts joined in order
/// (nothing dropped), spans shifted to the joined text, tags and used-in
/// unioned, list structure fields concatenated. The others are deleted.
Future<void> mergeItems(
  AppDatabase db,
  VoidItem keep,
  List<VoidItem> others,
) async {
  var summary = keep.summary;
  var raw = keep.rawTranscript;
  final spans = [...keep.summarySpans];
  final structure = Map<String, dynamic>.from(keep.structure);
  final tags = [...keep.tags];
  final used = [...keep.usedInProjectIds];
  for (final o in others) {
    final sentenceShift = splitSentences(summary).length;
    final rawShift = raw.length + 2;
    for (final s in o.summarySpans) {
      final m = s as Map;
      spans.add({
        'sentence_index': (m['sentence_index'] as int) + sentenceShift,
        'start': (m['start'] as int) + rawShift,
        'end': (m['end'] as int) + rawShift,
      });
    }
    summary = '$summary ${o.summary}';
    raw = '$raw\n\n${o.rawTranscript}';
    o.structure.forEach((k, v) {
      final cur = structure[k];
      if (v is List && cur is List) {
        structure[k] = [...cur, ...v];
      } else if (cur == null || cur == '' || (cur is List && cur.isEmpty)) {
        structure[k] = v;
      }
    });
    tags.addAll(o.tags.where((t) => !tags.contains(t)));
    used.addAll(o.usedInProjectIds.where((p) => !used.contains(p)));
  }
  await db.transaction(() async {
    await db.voidItemsDao.upsert(
      _row(
        keep,
        summary: summary,
        raw: raw,
        spans: spans,
        structure: structure,
        tags: tags,
        used: used,
      ),
    );
    for (final o in others) {
      await db.voidItemsDao.remove(o.id);
    }
  });
}

VoidItemsCompanion _row(
  VoidItem it, {
  VoidType? type,
  String? summary,
  String? raw,
  List<dynamic>? spans,
  Map<String, dynamic>? structure,
  List<String>? tags,
  List<String>? used,
}) => VoidItemsCompanion(
  id: Value(it.id),
  type: Value(type ?? it.type),
  summary: Value(summary ?? it.summary),
  rawTranscript: Value(raw ?? it.rawTranscript),
  summarySpans: Value(spans ?? it.summarySpans),
  structure: Value(structure ?? it.structure),
  tags: Value(tags ?? it.tags),
  usedInProjectIds: Value(used ?? it.usedInProjectIds),
  promotedProjectId: Value(it.promotedProjectId),
  status: Value(it.status),
  createdAt: Value(it.createdAt),
  updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
);
