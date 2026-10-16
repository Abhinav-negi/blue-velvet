import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/features/export/screenplay_pdf.dart';

import 'screenplay_pdf_test.dart' show font, layout;

/// Renders the sample project's screenplay to build/exp02_sample.pdf.
void main() {
  test('sample project PDF', () async {
    final doc = jsonDecode(
      File('assets/seed/sample_project.json').readAsStringSync(),
    );
    final beats = [
      for (final bt in doc['beats'] as List)
        (bt['blocks'] as List?) ?? const [],
    ];
    final bytes = await screenplayPdf(layout(), font(), beats);
    Directory('build').createSync();
    File('build/exp02_sample.pdf').writeAsBytesSync(bytes);
    final pages = RegExp(r'/Type/Page/')
        .allMatches(latin1.decode(bytes))
        .length;
    // ignore: avoid_print
    print('PAGES=$pages');
    expect(pages, greaterThan(0));
    final long = await screenplayPdf(layout(), font(), [
      [
        for (var i = 0; i < 120; i++) {'type': 'action', 'text': 'Line $i.'},
      ],
    ]);
    File('build/exp02_long.pdf').writeAsBytesSync(long);
  });
}
