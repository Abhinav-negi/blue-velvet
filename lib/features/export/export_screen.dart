import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/data/providers.dart';
import 'bible_pdf.dart';
import 'fountain.dart';
import 'pdf_layout.dart';
import 'screenplay_pdf.dart';
import 'script_pdf.dart';

/// Writes [content] to a temp file named [filename] and opens the share sheet.
/// Tests override this to avoid platform channels. EXP-02/04 reuse it.
typedef ShareFile = Future<void> Function(String filename, String content);

final shareFileProvider = Provider<ShareFile>(
  (ref) => (name, content) async {
    final file = File('${(await getTemporaryDirectory()).path}/$name');
    await file.writeAsString(content);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  },
);

/// Binary twin of [shareFileProvider] (PDF). Tests override it.
typedef ShareBytes = Future<void> Function(String filename, Uint8List bytes);

final shareBytesProvider = Provider<ShareBytes>(
  (ref) => (name, bytes) async {
    final file = File('${(await getTemporaryDirectory()).path}/$name');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  },
);

/// Entry screen; EXP-02/EXP-04 add their formats as more tiles.
class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key, required this.projectId});
  final String projectId;

  /// Project title + beat blocks in beats.position order (same as the script).
  Future<(String, List<List<dynamic>>)?> _load(WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final project = await db.projectsDao.byId(projectId);
    if (project == null) return null;
    final beats =
        await (db.select(db.beats)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    return (project.title, [for (final b in beats) b.blocks ?? const []]);
  }

  static String _fileName(String title, String ext) {
    final name = title.trim().replaceAll(RegExp(r'[^\w\-]+'), '_');
    return '${name.isEmpty ? 'screenplay' : name}.$ext';
  }

  Future<void> _fountain(WidgetRef ref) async {
    final data = await _load(ref);
    if (data == null) return;
    await ref.read(shareFileProvider)(
      _fileName(data.$1, 'fountain'),
      toFountain(data.$1, data.$2),
    );
  }

  Future<void> _pdf(WidgetRef ref) async {
    final data = await _load(ref);
    if (data == null) return;
    final layout = ScreenplayLayout.fromJson(
      await rootBundle.loadString('assets/seed/screenplay_format.json'),
    );
    final bytes = await screenplayPdf(
      layout,
      await rootBundle.load('assets/fonts/CourierPrime-Regular.ttf'),
      data.$2,
    );
    await ref.read(shareBytesProvider)(_fileName(data.$1, 'pdf'), bytes);
  }

  Future<ByteData> _font(String name) => rootBundle.load('assets/fonts/$name');

  Future<void> _script(WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final project = await db.projectsDao.byId(projectId);
    if (project == null) return;
    final beats =
        await (db.select(db.beats)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final model = ScriptModel.from(project.title, [
      for (final b in beats) b.sayShow ?? const [],
    ]);
    final bytes = await scriptPdf(
      model,
      await _font('Literata-VF.ttf'),
      await _font('Inter-VF.ttf'),
    );
    await ref.read(shareBytesProvider)(
      _fileName('${project.title} script', 'pdf'),
      bytes,
    );
  }

  Future<void> _bible(WidgetRef ref) async {
    final model = await BibleModel.load(ref.read(dbProvider), projectId);
    if (model == null) return;
    final bytes = await biblePdf(
      model,
      await _font('Literata-VF.ttf'),
      await _font('Inter-VF.ttf'),
    );
    await ref.read(shareBytesProvider)(
      _fileName('${model.title} story bible', 'pdf'),
      bytes,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Export')),
    body: ListView(
      children: [
        ListTile(
          title: const Text('Fountain (.fountain)'),
          subtitle: const Text('Screenplay as plain text'),
          onTap: () => _fountain(ref),
        ),
        ListTile(
          title: const Text('Screenplay PDF (.pdf)'),
          subtitle: const Text('Films: industry format, Courier 12 pt'),
          onTap: () => _pdf(ref),
        ),
        ListTile(
          title: const Text('Script PDF (.pdf)'),
          subtitle: const Text('YouTube and Shorts: Say / Show columns'),
          onTap: () => _script(ref),
        ),
        ListTile(
          title: const Text('Story bible PDF (.pdf)'),
          subtitle: const Text('Summary and character sheets'),
          onTap: () => _bible(ref),
        ),
      ],
    ),
  );
}
