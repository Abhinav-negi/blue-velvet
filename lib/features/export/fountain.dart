/// Screenplay blocks (DATA_MODEL 9.1) to Fountain text.
String toFountain(String title, List<List<dynamic>> beatBlocks) {
  final out = StringBuffer();
  if (title.trim().isNotEmpty) out.write('Title: ${title.trim()}\n');
  var first = true;
  for (final blocks in beatBlocks) {
    for (final b in blocks.cast<Map>()) {
      final text = (b['text'] as String? ?? '').trim();
      if (text.isEmpty) continue;
      final type = b['type'] as String;
      // Dialogue and parentheticals stick to their character cue.
      final tight = type == 'dialogue' || type == 'parenthetical';
      if (!first) out.write(tight ? '\n' : '\n\n');
      if (first && out.isNotEmpty) out.write('\n');
      first = false;
      out.write(_element(type, text));
    }
  }
  out.write('\n');
  return out.toString();
}

final _heading = RegExp(
  r'^(INT|EXT|EST|INT\./EXT|INT/EXT|I/E)[. ]',
  caseSensitive: false,
);

String _element(String type, String text) => switch (type) {
  'scene_heading' =>
    _heading.hasMatch(text) ? text.toUpperCase() : '.${text.toUpperCase()}',
  'character' => text.toUpperCase(),
  'parenthetical' => text.startsWith('(') ? text : '($text)',
  'transition' =>
    text.toUpperCase().endsWith('TO:')
        ? text.toUpperCase()
        : '> ${text.toUpperCase()}',
  _ => text,
};
