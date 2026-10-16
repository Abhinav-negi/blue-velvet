import 'dart:convert';

/// Placement of one screenplay element type, in inches from the page's left
/// edge (indents) and in blank lines (spacing). From screenplay_format.json.
class ElementStyle {
  const ElementStyle({
    required this.leftIn,
    required this.rightIn,
    required this.upper,
    required this.blankBefore,
    required this.blankAfter,
    required this.align,
  });
  final double leftIn, rightIn;
  final bool upper;
  final int blankBefore, blankAfter;
  final String align; // left | right | center
}

/// One block ready to draw. [blankLinesBefore] already merges the previous
/// element's blank_lines_after (max of the two, like word processors do).
class LaidOutBlock {
  const LaidOutBlock(
    this.type,
    this.text,
    this.style,
    this.blankLinesBefore,
    this.lines,
  );
  final String type, text;

  /// [text] wrapped to the element's column (10 characters per inch).
  final List<String> lines;
  final ElementStyle style;
  final int blankLinesBefore;
}

/// Pure screenplay page model: page size, margins, font and element styles.
/// The PDF renderer only consumes this.
class ScreenplayLayout {
  ScreenplayLayout._(
    this.widthIn,
    this.heightIn,
    this.marginTopIn,
    this.marginBottomIn,
    this.marginLeftIn,
    this.marginRightIn,
    this.styles,
  );

  /// Parses assets/seed/screenplay_format.json (US Letter page).
  factory ScreenplayLayout.fromJson(String json) {
    final items = {
      for (final i in (jsonDecode(json)['items'] as List).cast<Map>())
        i['id'] as String: i['rules'] as Map,
    };
    double d(Map r, String k) => (r[k] as num).toDouble();
    final page = items['page-us-letter']!;
    ElementStyle el(String id) {
      final r = items['$id-element']!;
      return ElementStyle(
        leftIn: d(r, 'left_indent_in'),
        rightIn: d(r, 'right_indent_in'),
        upper: r['uppercase'] as bool,
        blankBefore: (r['blank_lines_before'] as int?) ?? 0,
        blankAfter: (r['blank_lines_after'] as int?) ?? 0,
        align: r['alignment'] as String,
      );
    }

    return ScreenplayLayout._(
      d(page, 'page_width_in'),
      d(page, 'page_height_in'),
      d(page, 'margin_top_in'),
      d(page, 'margin_bottom_in'),
      d(page, 'margin_left_in'),
      d(page, 'margin_right_in'),
      {
        for (final t in const [
          'scene-heading',
          'action',
          'character',
          'dialogue',
          'parenthetical',
          'transition',
        ])
          t.replaceAll('-', '_'): el(t),
      },
    );
  }

  /// Courier Prime 12 pt, 6 lines per inch (12 pt line).
  static const fontSizePt = 12.0;
  static const linePt = 12.0;
  static const pointsPerInch = 72.0;

  final double widthIn, heightIn;
  final double marginTopIn, marginBottomIn, marginLeftIn, marginRightIn;
  final Map<String, ElementStyle> styles;

  /// Width of the text column between the margins.
  double get textWidthIn => widthIn - marginLeftIn - marginRightIn;

  /// Text width of [s] in inches (indents measured from the page edge).
  double widthOf(ElementStyle s) => widthIn - s.leftIn - s.rightIn;

  /// Greedy word wrap at 10 characters per inch; overlong words stay whole.
  static List<String> wrap(String text, double widthIn) {
    final max = (widthIn * 10).floor();
    final lines = <String>[];
    for (final para in text.split('\n')) {
      var cur = '';
      for (final w in para.split(RegExp(r'\s+')).where((w) => w.isNotEmpty)) {
        if (cur.isEmpty) {
          cur = w;
        } else if (cur.length + 1 + w.length <= max) {
          cur = '$cur $w';
        } else {
          lines.add(cur);
          cur = w;
        }
      }
      lines.add(cur);
    }
    return lines;
  }

  /// Empty and unknown-typed text is skipped/treated as action.
  List<LaidOutBlock> layout(Iterable<Map> blocks) {
    final out = <LaidOutBlock>[];
    var prevAfter = 0;
    for (final b in blocks) {
      var text = ((b['text'] as String?) ?? '').trim();
      if (text.isEmpty) continue;
      final type = styles.containsKey(b['type'])
          ? b['type'] as String
          : 'action';
      final s = styles[type]!;
      if (s.upper) text = text.toUpperCase();
      if (type == 'parenthetical' && !text.startsWith('(')) text = '($text)';
      final before = out.isEmpty
          ? 0
          : (s.blankBefore > prevAfter ? s.blankBefore : prevAfter);
      out.add(LaidOutBlock(type, text, s, before, wrap(text, widthOf(s))));
      prevAfter = s.blankAfter;
    }
    return out;
  }
}
