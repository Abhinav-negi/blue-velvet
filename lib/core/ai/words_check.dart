/// Grounding check (AI_CONTRACT 9.2): returns the specifics in [output] that
/// do not occur in [input]. Empty list = clean. Specifics are numbers, number
/// words, capitalised words not at a sentence start, and quoted strings.
List<String> wordsCheck(String output, String input) {
  final src = _fold(input);
  final srcWords = _words(src).map(_stem).toSet();
  final bad = <String>[];

  bool known(String w) {
    final alt = _numAlt[w];
    return srcWords.contains(_stem(w)) ||
        (alt != null && srcWords.contains(alt));
  }

  // Quoted strings: must appear whole in the input.
  final quoted = RegExp('["“]([^"”]+)["”]');
  for (final m in quoted.allMatches(output)) {
    if (!src.contains(_fold(m[1]!))) bad.add(m[0]!);
  }

  // Tokens with a flag for "starts a sentence".
  final tok = RegExp(r"[A-Za-z0-9][A-Za-z0-9'’]*");
  var atStart = true;
  var last = 0;
  for (final m in tok.allMatches(output)) {
    final gap = output.substring(last, m.start);
    if (RegExp(r'[.!?]').hasMatch(gap)) atStart = true;
    last = m.end;
    final w = m[0]!;
    final lw = w.toLowerCase();
    final isNum = RegExp(r'^\d').hasMatch(w) || _numAlt.containsKey(lw);
    final isCap = RegExp(r'^[A-Z]').hasMatch(w) && !atStart && w != 'I';
    atStart = false;
    if ((isNum || isCap) && !known(_fold(w))) bad.add(w);
  }
  return bad;
}

const _small = [
  'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight',
  'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
  'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',
];

// word <-> digit, both directions, so "eight" in input grounds "8" in output.
final Map<String, String> _numAlt = {
  for (var i = 0; i < _small.length; i++) ...{_small[i]: '$i', '$i': _small[i]},
};

String _fold(String s) =>
    s.toLowerCase().replaceAll('’', "'").replaceAll('‘', "'");

Iterable<String> _words(String s) =>
    RegExp(r"[a-z0-9]+(?:'[a-z]+)?").allMatches(s).map((m) => m[0]!);

// Simple plural / possessive tolerance.
String _stem(String w) {
  var s = w.replaceAll(RegExp(r"'s$"), '');
  if (s.length > 3 && s.endsWith('s')) s = s.substring(0, s.length - 1);
  return s;
}
