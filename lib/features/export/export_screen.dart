import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/data/providers.dart';
import 'fountain.dart';

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

/// Entry screen; EXP-02/EXP-04 add their formats as more tiles.
class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key, required this.projectId});
  final String projectId;

  Future<void> _fountain(WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final project = await db.projectsDao.byId(projectId);
    if (project == null) return;
    final beats =
        await (db.select(db.beats)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final text = toFountain(project.title, [
      for (final b in beats) b.blocks ?? const [],
    ]);
    final name = project.title.trim().replaceAll(RegExp(r'[^\w\-]+'), '_');
    await ref.read(shareFileProvider)(
      '${name.isEmpty ? 'screenplay' : name}.fountain',
      text,
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
      ],
    ),
  );
}
