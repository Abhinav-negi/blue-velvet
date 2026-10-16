import 'dart:typed_data';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/data/db.dart';

/// One character sheet: [name] plus the non-empty other fields (label, text).
class BibleCharacter {
  const BibleCharacter(this.name, this.fields);
  final String name;
  final List<(String, String)> fields;
}

/// Pure story-bible model: project summary + one sheet per project character.
class BibleModel {
  const BibleModel(this.title, this.summary, this.characters);
  final String title, summary;
  final List<BibleCharacter> characters;

  /// Sheet fields after name, in display order (same as the Characters screen).
  static const labels = [
    'Age',
    'Role in story',
    'Appearance',
    'Background story',
    'Personality traits',
    'Habits',
    'Wants / needs / fears',
    'Notes',
  ];

  /// [sheets] = per character, the 9 values name..notes (nulls = unset).
  factory BibleModel.from(
    String title,
    String summary,
    List<List<String?>> sheets,
  ) {
    String t(String? s) => (s ?? '').trim();
    return BibleModel(title.trim(), summary.trim(), [
      for (final s in sheets)
        BibleCharacter(t(s[0]), [
          for (var i = 0; i < labels.length; i++)
            if (t(s[i + 1]).isNotEmpty) (labels[i], t(s[i + 1])),
        ]),
    ]);
  }

  /// Loads a project's bible. A member's own non-null values override the
  /// library character's (linked rows have none, forked rows have all).
  static Future<BibleModel?> load(AppDatabase db, String projectId) async {
    final p = await db.projectsDao.byId(projectId);
    if (p == null) return null;
    final members =
        await (db.select(db.projectCharacters)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final sheets = <List<String?>>[];
    for (final m in members) {
      final c = m.characterId == null
          ? null
          : await (db.select(
              db.characters,
            )..where((t) => t.id.equals(m.characterId!))).getSingleOrNull();
      sheets.add([
        m.name ?? c?.name,
        m.age ?? c?.age,
        m.role ?? c?.role,
        m.appearance ?? c?.appearance,
        m.background ?? c?.background,
        m.traits ?? c?.traits,
        m.habits ?? c?.habits,
        m.wantsNeedsFears ?? c?.wantsNeedsFears,
        m.notes ?? c?.notes,
      ]);
    }
    return BibleModel.from(p.title, p.summary, sheets);
  }
}

/// Story bible: title, summary, then a block per character.
Future<Uint8List> biblePdf(
  BibleModel m,
  ByteData bodyFont,
  ByteData labelFont,
) {
  final body = pw.TextStyle(font: pw.Font.ttf(bodyFont), fontSize: 11);
  final label = pw.TextStyle(font: pw.Font.ttf(labelFont), fontSize: 9);
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(54),
      build: (c) => [
        pw.Text(m.title, style: body.copyWith(fontSize: 24)),
        if (m.summary.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          pw.Text('SUMMARY', style: label),
          pw.Text(m.summary, style: body),
        ],
        if (m.characters.isNotEmpty) ...[
          pw.SizedBox(height: 18),
          pw.Text('CHARACTERS', style: label),
        ],
        for (final ch in m.characters) ...[
          pw.SizedBox(height: 12),
          pw.Text(ch.name, style: body.copyWith(fontSize: 16)),
          pw.Divider(color: PdfColors.grey500, thickness: 0.5),
          for (final (l, t) in ch.fields)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(l.toUpperCase(), style: label),
                  pw.Text(t, style: body),
                ],
              ),
            ),
        ],
      ],
    ),
  );
  return doc.save();
}
