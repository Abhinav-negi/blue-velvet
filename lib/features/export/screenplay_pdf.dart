import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_layout.dart';

/// Renders [beatBlocks] (DATA_MODEL 9.1, in beat order) as an industry-format
/// screenplay PDF. [fontData] is Courier Prime Regular.
/// ponytail: no (MORE)/(CONT'D) at page breaks and no title page; add if asked.
Future<Uint8List> screenplayPdf(
  ScreenplayLayout l,
  ByteData fontData,
  List<List<dynamic>> beatBlocks,
) {
  const inch = ScreenplayLayout.pointsPerInch;
  final font = pw.Font.ttf(fontData);
  final style = pw.TextStyle(font: font, fontSize: ScreenplayLayout.fontSizePt);
  final blocks = l.layout([for (final b in beatBlocks) ...b.cast<Map>()]);
  pw.TextAlign align(String a) => switch (a) {
    'right' => pw.TextAlign.right,
    'center' => pw.TextAlign.center,
    _ => pw.TextAlign.left,
  };

  final doc = pw.Document();
  // Header band (0.5 in) + top margin 0.5 in = 1 in; page number sits 0.5 in down.
  const headerPt = 0.5 * inch;
  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat(l.widthIn * inch, l.heightIn * inch),
        margin: pw.EdgeInsets.fromLTRB(
          l.marginLeftIn * inch,
          (l.marginTopIn - 0.5) * inch,
          l.marginRightIn * inch,
          l.marginBottomIn * inch,
        ),
        theme: pw.ThemeData.withFont(base: font),
      ),
      header: (c) => pw.Container(
        height: headerPt,
        alignment: pw.Alignment.bottomRight,
        child: c.pageNumber > 1
            ? pw.Text('${c.pageNumber}.', style: style)
            : null,
      ),
      // One widget per 12 pt line so lines/page is exactly 6 per inch and
      // pages can break between any two lines.
      build: (c) => [
        for (final b in blocks)
          for (var i = 0; i < b.lines.length; i++)
            pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(
                (b.style.leftIn - l.marginLeftIn) * inch,
                i == 0 ? b.blankLinesBefore * ScreenplayLayout.linePt : 0,
                (b.style.rightIn - l.marginRightIn) * inch,
                0,
              ),
              child: pw.SizedBox(
                width: double.infinity,
                height: ScreenplayLayout.linePt,
                child: pw.Text(
                  b.lines[i],
                  style: style,
                  textAlign: align(b.style.align),
                ),
              ),
            ),
      ],
    ),
  );
  return doc.save();
}
