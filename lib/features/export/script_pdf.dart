import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// One Say/Show row (DATA_MODEL 9.2) with its fields trimmed.
class ScriptRow {
  const ScriptRow(this.say, this.show);
  final String say;

  /// Non-empty show fields as (label, text), in a fixed order.
  final List<(String, String)> show;
}

/// Pure Say/Show script model; [scriptPdf] only consumes it.
class ScriptModel {
  const ScriptModel(this.title, this.rows);
  final String title;
  final List<ScriptRow> rows;

  static const _showLabels = [
    ('a_roll', 'A-roll'),
    ('b_roll', 'B-roll'),
    ('on_screen_text', 'On-screen text'),
    ('graphics', 'Graphics'),
  ];

  /// [beatRows] = each beat's say_show JSON in beat order; rows with nothing
  /// in them are dropped.
  factory ScriptModel.from(String title, List<List<dynamic>> beatRows) {
    final rows = <ScriptRow>[];
    for (final r in [for (final b in beatRows) ...b.cast<Map>()]) {
      final say = ((r['say'] as String?) ?? '').trim();
      final show = (r['show'] as Map?) ?? const {};
      final fields = [
        for (final (k, label) in _showLabels)
          if (((show[k] as String?) ?? '').trim().isNotEmpty)
            (label, (show[k] as String).trim()),
      ];
      if (say.isNotEmpty || fields.isNotEmpty) rows.add(ScriptRow(say, fields));
    }
    return ScriptModel(title.trim(), rows);
  }
}

/// Two-column Say | Show script. [regular] body font, [label] caption font.
Future<Uint8List> scriptPdf(ScriptModel m, ByteData regular, ByteData label) {
  final body = pw.TextStyle(font: pw.Font.ttf(regular), fontSize: 11);
  final head = pw.TextStyle(font: pw.Font.ttf(label), fontSize: 9);
  final doc = pw.Document();
  pw.Widget cell(List<pw.Widget> c) => pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: c,
    ),
  );
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(54),
      build: (c) => [
        if (m.title.isNotEmpty)
          pw.Text(m.title, style: body.copyWith(fontSize: 20)),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                cell([pw.Text('SAY', style: head)]),
                cell([pw.Text('SHOW', style: head)]),
              ],
            ),
            for (final r in m.rows)
              pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.top,
                children: [
                  cell([pw.Text(r.say, style: body)]),
                  cell([
                    for (final (l, t) in r.show) ...[
                      pw.Text(l.toUpperCase(), style: head),
                      pw.Text(t, style: body),
                      pw.SizedBox(height: 4),
                    ],
                  ]),
                ],
              ),
          ],
        ),
      ],
    ),
  );
  return doc.save();
}
