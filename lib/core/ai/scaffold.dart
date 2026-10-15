import 'dart:convert';

import 'ai_client.dart';
import 'errors.dart';
import 'permissions.dart';
import 'prompts/scaffold_prompts.dart';

class ScaffoldBlock {
  const ScaffoldBlock(this.type, this.text);
  final String type; // scene_heading | action
  final String text;
}

class ScaffoldRow {
  const ScaffoldRow(this.show);

  /// a_roll, b_roll, on_screen_text, graphics. `say` is always "" so is not kept.
  final Map<String, String> show;
}

/// A validated scaffold draft. The caller wraps it in an `addScaffold`
/// proposal op (D-17); nothing here writes project data.
class ScaffoldDraft {
  const ScaffoldDraft(this.blocks, this.rows, {required this.ungrounded});
  final List<ScaffoldBlock> blocks;
  final List<ScaffoldRow> rows;

  /// Output contains a specific (number / proper noun) absent from the input.
  /// The proposal view marks it and defaults `accepted` to false (9.2).
  final bool ungrounded;
}

const _blockTypes = {'scene_heading', 'action'};
const _showKeys = ['a_roll', 'b_roll', 'on_screen_text', 'graphics'];

/// Throws [FormatException] naming the broken rule. Public for tests.
ScaffoldDraft parseScaffold(
  Map<String, dynamic> json, {
  required bool isFilm,
  required String inputText,
}) {
  final rawBlocks = json['blocks'];
  final rawRows = json['rows'];
  if (rawBlocks is! List || rawRows is! List) {
    throw const FormatException('blocks and rows must both be arrays');
  }
  final blocks = <ScaffoldBlock>[];
  for (final b in rawBlocks) {
    final type = b is Map ? b['type'] : null;
    final text = b is Map ? b['text'] : null;
    // Rule 5 (no dialogue): only scene_heading / action ever pass.
    if (!_blockTypes.contains(type) || text is! String) {
      throw FormatException('block type "$type" is not allowed (no dialogue)');
    }
    blocks.add(ScaffoldBlock(type as String, text));
  }
  final rows = <ScaffoldRow>[];
  for (final r in rawRows) {
    final show = r is Map ? r['show'] : null;
    if (r is! Map || r['say'] != '' || show is! Map) {
      throw const FormatException('row "say" must be empty');
    }
    rows.add(
      ScaffoldRow({
        for (final k in _showKeys)
          k: show[k] is String ? show[k] as String : '',
      }),
    );
  }
  if (isFilm
      ? (rows.isNotEmpty || blocks.isEmpty)
      : (blocks.isNotEmpty || rows.isEmpty)) {
    throw FormatException(
      isFilm
          ? 'film needs blocks and no rows'
          : 'video needs rows and no blocks',
    );
  }
  final out = [
    for (final b in blocks) b.text,
    for (final r in rows) ...r.show.values,
  ].join(' ');
  return ScaffoldDraft(blocks, rows, ungrounded: hasUngrounded(out, inputText));
}

String _norm(String s) => s.toLowerCase();

/// Cheap 9.2 check: numbers and capitalised non-sentence-start words in
/// [output] must appear in [input]. Scene-heading conventions are exempt.
// ponytail: no diacritic/stem folding beyond a trailing "s"; upgrade if false flags show up.
bool hasUngrounded(String output, String input) {
  final hay = _norm(input);
  const exempt = {'int', 'ext', 'day', 'night', 'i'};
  bool seen(String w) {
    final l = _norm(w);
    return hay.contains(l) ||
        (l.endsWith('s') && hay.contains(l.substring(0, l.length - 1)));
  }

  for (final m in RegExp(r'\d+').allMatches(output)) {
    if (!seen(m.group(0)!)) return true;
  }
  for (final sentence in output.split(RegExp(r'(?<=[.!?])\s+'))) {
    final words = RegExp(r"[A-Za-z][A-Za-z']*").allMatches(sentence).toList();
    final allCaps = sentence == sentence.toUpperCase();
    for (var i = 0; i < words.length; i++) {
      final w = words[i].group(0)!;
      if (exempt.contains(_norm(w))) continue;
      // Capitalised mid-sentence, or any word of an ALL-CAPS sentence after
      // the first (headings like "EXT. PLAYGROUND - DAY").
      final cap = w[0] == w[0].toUpperCase();
      if (cap && (i > 0 || allCaps) && !seen(w)) return true;
    }
  }
  return false;
}

/// Draft a skeleton for one beat (AI_CONTRACT 4.8). Gate: screenplay_scaffold.
///
/// [beat] is `{id, title, description, character_names, project_type}`,
/// [facts] the user's words, [existing] a short note of current block types.
/// Validation failure retries once with a note, then throws
/// [AiMalformedResponse].
Future<ScaffoldDraft> scaffoldBeat(
  AiClient ai, {
  required Map<String, dynamic> beat,
  required String facts,
  String existing = '',
  Map<String, dynamic> permissions = const {},
}) async {
  final type = beat['project_type'];
  final isFilm = type == 'short_film' || type == 'long_film';
  final base =
      '$sharedRules\n\n$scaffoldInstruction\n\n'
      'GRAMMAR_CLEANUP: ${permissions['grammar_cleanup'] == true}\n'
      'BEAT: ${jsonEncode(beat)}\nFACTS: $facts\nEXISTING: $existing';
  final inputText = '$facts ${jsonEncode(beat)} $existing';
  var prompt = base;
  for (var attempt = 0; ; attempt++) {
    final json = await ai.generateJson(
      prompt: prompt,
      schema: scaffoldSchema,
      gate: AiPermission.screenplayScaffold,
      permissions: permissions,
    );
    try {
      return parseScaffold(json, isFilm: isFilm, inputText: inputText);
    } on FormatException catch (e) {
      if (attempt == 1) {
        throw AiMalformedResponse('Scaffold rejected: ${e.message}');
      }
      prompt =
          '$base\n\nYour last output broke the rules: ${e.message}. '
          'Fix it.';
    }
  }
}
