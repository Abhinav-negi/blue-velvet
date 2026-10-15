import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Block types in the standard order (plan/areas/06-script.md).
const elementTypes = [
  'scene_heading',
  'action',
  'character',
  'dialogue',
  'parenthetical',
  'transition',
];

/// Seed item id for each block type.
const _seedId = {
  'scene_heading': 'scene-heading-element',
  'action': 'action-element',
  'character': 'character-element',
  'dialogue': 'dialogue-element',
  'parenthetical': 'parenthetical-element',
  'transition': 'transition-element',
};

/// Type of the block Enter creates after [type]: the standard chain; a
/// parenthetical leads back to dialogue and a transition to a new scene.
String nextOnEnter(String type) => switch (type) {
  'parenthetical' => 'dialogue',
  'transition' => 'scene_heading',
  _ => elementTypes[elementTypes.indexOf(type) + 1],
};

/// Type Tab turns the current block into: next in the order, wrapping.
String nextOnTab(String type) =>
    elementTypes[(elementTypes.indexOf(type) + 1) % elementTypes.length];

class ElementRules {
  const ElementRules({
    required this.name,
    required this.leftIn,
    required this.rightIn,
    required this.uppercase,
    required this.blankBefore,
    required this.align,
  });
  final String name;
  final double leftIn, rightIn;
  final bool uppercase;
  final int blankBefore;
  final String align;
}

/// Measurements read from assets/seed/screenplay_format.json (US Letter).
class ScreenplayFormat {
  ScreenplayFormat._(
    this.elements,
    this.pageWidthIn,
    this.marginLeftIn,
    this.charsPerInch,
  );

  factory ScreenplayFormat.parse(String json) {
    final items = {
      for (final i in (jsonDecode(json)['items'] as List))
        (i as Map)['id'] as String: i,
    };
    final page = (items['page-us-letter'] as Map)['rules'] as Map;
    return ScreenplayFormat._(
      {
        for (final e in _seedId.entries)
          e.key: () {
            final i = items[e.value] as Map;
            final r = i['rules'] as Map;
            return ElementRules(
              name: i['name'] as String,
              leftIn: (r['left_indent_in'] as num).toDouble(),
              rightIn: (r['right_indent_in'] as num).toDouble(),
              uppercase: r['uppercase'] as bool,
              blankBefore: (r['blank_lines_before'] as num?)?.toInt() ?? 0,
              align: r['alignment'] as String,
            );
          }(),
      },
      (page['page_width_in'] as num).toDouble(),
      (page['margin_left_in'] as num).toDouble(),
      (page['characters_per_inch'] as num).toDouble(),
    );
  }

  final Map<String, ElementRules> elements;
  final double pageWidthIn, marginLeftIn, charsPerInch;
}

final screenplayFormatProvider = FutureProvider<ScreenplayFormat>(
  (ref) async => ScreenplayFormat.parse(
    await rootBundle.loadString('assets/seed/screenplay_format.json'),
  ),
);
