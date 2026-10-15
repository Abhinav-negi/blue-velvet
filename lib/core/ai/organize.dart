import 'dart:convert';

import 'ai_client.dart';
import 'errors.dart';
import 'prompts/organize_prompt.dart';

const itemTypes = [
  'story_idea', 'concept', 'character', 'dialogue', 'lyric', 'scene_fragment',
  'other',
];

/// One `summary_spans` entry (DATA_MODEL 1.1): UTF-16 offsets into the raw
/// transcript, end exclusive.
class SummarySpan {
  const SummarySpan(this.sentenceIndex, this.start, this.end);
  final int sentenceIndex, start, end;
  Map<String, int> toJson() =>
      {'sentence_index': sentenceIndex, 'start': start, 'end': end};
  @override
  bool operator ==(Object other) =>
      other is SummarySpan &&
      other.sentenceIndex == sentenceIndex &&
      other.start == start &&
      other.end == end;
  @override
  int get hashCode => Object.hash(sentenceIndex, start, end);
  @override
  String toString() => 'Span($sentenceIndex, $start-$end)';
}

/// A Void item as the AI proposes it. The caller stores it; raw_transcript is
/// never part of the draft.
class ItemDraft {
  const ItemDraft({
    required this.type,
    required this.summary,
    required this.spans,
    required this.structure,
    required this.tags,
  });
  final String type;
  final String summary;
  final List<SummarySpan> spans;
  final Map<String, dynamic> structure;
  final List<String> tags;
}

/// Result of [editItem]: either a patched draft or a refusal note.
class ItemEdit {
  const ItemEdit.patch(ItemDraft this.item) : note = null;
  const ItemEdit.cannotDo(this.note) : item = null;
  final ItemDraft? item;
  final String? note;
}

final _sentenceEnd = RegExp(r'(?<=[.!?]["\x27)\]]?)\s+');

/// AI_CONTRACT 2.1.
List<String> splitSentences(String s) =>
    s.trim().split(_sentenceEnd).where((x) => x.isNotEmpty).toList();

// Normalised view of [s]: lowercase, curly->straight quotes, whitespace runs
// collapsed. `map[i]` is the offset in [s] of normalised char i.
({String text, List<int> map}) _norm(String s) {
  final b = StringBuffer();
  final map = <int>[];
  var inWs = false;
  for (var i = 0; i < s.length; i++) {
    var c = s[i];
    if (c.trim().isEmpty) {
      if (inWs) continue;
      inWs = true;
      c = ' ';
    } else {
      inWs = false;
      c = switch (c) {
        '‘' || '’' => "'",
        '“' || '”' => '"',
        _ => c.toLowerCase(),
      };
    }
    b.write(c);
    map.add(i);
  }
  return (text: b.toString(), map: map);
}

/// AI_CONTRACT 2.2: quotes -> offsets. Unlocatable quotes are dropped.
List<SummarySpan> computeSpans(String raw, List<List<String>> quotesPerSentence) {
  final spans = <SummarySpan>[];
  ({String text, List<int> map})? n;
  for (var i = 0; i < quotesPerSentence.length; i++) {
    for (final q in quotesPerSentence[i]) {
      if (q.trim().isEmpty) continue;
      final at = raw.indexOf(q);
      if (at >= 0) {
        spans.add(SummarySpan(i, at, at + q.length));
        continue;
      }
      n ??= _norm(raw);
      final nq = _norm(q.trim()).text;
      final ns = n.text.indexOf(nq);
      if (ns < 0) continue;
      spans.add(SummarySpan(i, n.map[ns], n.map[ns + nq.length - 1] + 1));
    }
  }
  return spans;
}

class _Invalid implements Exception {
  _Invalid(this.why);
  final String why;
}

/// Validates the `type`/`summary_sentences`/`structure`/`tags` object shared by
/// organize and editItem and builds the draft against [raw].
ItemDraft parseItem(Map<String, dynamic> j, String raw) {
  final type = j['type'];
  if (type is! String || !itemTypes.contains(type)) {
    throw _Invalid('rule 8: "type" is not one of the allowed values');
  }
  final sents = <String>[];
  final quotes = <List<String>>[];
  try {
    for (final s in j['summary_sentences'] as List) {
      sents.add(s['text'] as String);
      quotes.add([for (final q in s['source_quotes'] as List) q as String]);
    }
  } catch (_) {
    throw _Invalid('rule 8: summary_sentences is malformed');
  }
  final summary = sents.join(' ');
  final structure = Map<String, dynamic>.from(
      (j['structure'] as Map?) ?? const <String, dynamic>{});
  // Drop null/empty fields so the stored structure only holds what was said.
  structure.removeWhere((_, v) => v == null);

  if (type == 'dialogue') {
    final nraw = _norm(raw).text;
    for (final l in (structure['lines'] as List? ?? const [])) {
      if (!nraw.contains(_norm((l['text'] as String).trim()).text)) {
        throw _Invalid(
            'rule 2: a dialogue line is not something the user said');
      }
    }
  }
  if (type == 'lyric') {
    final nraw = _norm(raw).text;
    for (final s in (structure['sections'] as List? ?? const [])) {
      if (!nraw.contains(_norm((s['text'] as String).trim()).text)) {
        throw _Invalid('rule 1: a lyric section is not the user\'s words');
      }
    }
  }

  // Sentence count mismatch: keep summary, drop spans (S4 unavailable).
  final spans = splitSentences(summary).length == sents.length
      ? computeSpans(raw, quotes)
      : const <SummarySpan>[];
  final tags = [
    for (final t in (j['tags'] as List? ?? const []))
      if (t is String && t.trim().isNotEmpty) t.trim().toLowerCase(),
  ];
  return ItemDraft(
      type: type,
      summary: summary,
      spans: spans,
      structure: structure,
      tags: tags);
}

Map<String, dynamic> _s({bool nullable = false}) =>
    {'type': 'STRING', if (nullable) 'nullable': true};

Map<String, dynamic> _arr(Map<String, dynamic> items, {bool nullable = false}) =>
    {'type': 'ARRAY', if (nullable) 'nullable': true, 'items': items};

Map<String, dynamic> _obj(Map<String, dynamic> props, List<String> req) =>
    {'type': 'OBJECT', 'properties': props, 'required': req};

final _itemProps = <String, dynamic>{
  'type': {'type': 'STRING', 'enum': itemTypes},
  'summary_sentences': _arr(_obj({
    'text': _s(),
    'source_quotes': _arr(_s()),
  }, ['text', 'source_quotes'])),
  'structure': {
    'type': 'OBJECT',
    'properties': {
      for (final k in [
        'name', 'age', 'role', 'appearance', 'background', 'traits', 'habits',
        'wants_needs_fears', 'notes', 'context', 'description',
      ])
        k: _s(nullable: true),
      'lines': _arr(
          _obj({'speaker': _s(), 'text': _s()}, ['speaker', 'text']),
          nullable: true),
      'sections': _arr(
          _obj({
            'kind': {
              'type': 'STRING',
              'enum': [
                'verse', 'pre_chorus', 'chorus', 'bridge', 'hook', 'intro',
                'outro',
              ],
            },
            'text': _s(),
          }, ['kind', 'text']),
          nullable: true),
      'characters': _arr(_s(), nullable: true),
    },
  },
  'tags': _arr(_s()),
};

final organizeSchema = {
  ..._obj(_itemProps, ['type', 'summary_sentences', 'structure', 'tags']),
  'propertyOrdering': ['type', 'summary_sentences', 'structure', 'tags'],
};

// editItem for a void item only: `changes` is a project-scope output and is
// deliberately left out of the schema.
final editItemSchema = {
  ..._obj({
    'outcome': {
      'type': 'STRING',
      'enum': ['item_patch', 'cannot_do'],
    },
    'item': {..._obj(_itemProps, ['type', 'summary_sentences', 'structure', 'tags']), 'nullable': true},
    'note': _s(nullable: true),
  }, ['outcome']),
  'propertyOrdering': ['outcome', 'item', 'note'],
};

/// Runs [call] and parses; on a validation failure retries once with a note
/// naming the broken rule (AI_CONTRACT 9.3), then throws AiMalformedResponse.
Future<T> _withRetry<T>(
  Future<Map<String, dynamic>> Function(String note) call,
  T Function(Map<String, dynamic>) parse,
) async {
  var note = '';
  for (var attempt = 0;; attempt++) {
    final j = await call(note);
    try {
      return parse(j);
    } on _Invalid catch (e) {
      if (attempt == 1) throw AiMalformedResponse(e.why);
      note = '\n\nYour last output broke ${e.why}. Fix it.';
    }
  }
}

/// Transcript -> Void item draft (AI_CONTRACT 4.2). Ungated.
Future<ItemDraft> organize(
  AiClient ai,
  String rawTranscript, {
  bool grammarCleanup = false,
}) =>
    _withRetry(
      (note) => ai.generateJson(
        prompt: organizePrompt(rawTranscript, grammarCleanup: grammarCleanup) +
            note,
        schema: organizeSchema,
      ),
      (j) => parseItem(j, rawTranscript),
    );

/// Edit a Void item by [instruction] (AI_CONTRACT 4.3, void_item target).
/// Returns a patched draft, or a cannot_do note when new content was asked for.
Future<ItemEdit> editItem(
  AiClient ai, {
  required String type,
  required String summary,
  required String rawTranscript,
  required Map<String, dynamic> structure,
  required List<String> tags,
  required String instruction,
  bool grammarCleanup = false,
}) {
  final item = {
    'type': type,
    'summary': summary,
    'raw_transcript': rawTranscript,
    'structure': structure,
    'tags': tags,
  };
  return _withRetry(
    (note) => ai.generateJson(
      prompt: editItemPrompt(item, instruction,
              grammarCleanup: grammarCleanup) +
          note,
      schema: editItemSchema,
    ),
    (j) {
      if (j['outcome'] == 'cannot_do' || j['item'] == null) {
        return ItemEdit.cannotDo(
            (j['note'] as String?) ?? 'This edit would need new content.');
      }
      return ItemEdit.patch(
          parseItem(Map<String, dynamic>.from(j['item'] as Map), rawTranscript));
    },
  );
}

/// Pretty JSON of a draft, for the smoke tool.
String draftToJson(ItemDraft d) => const JsonEncoder.withIndent('  ').convert({
      'type': d.type,
      'summary': d.summary,
      'spans': [for (final s in d.spans) s.toJson()],
      'structure': d.structure,
      'tags': d.tags,
    });
