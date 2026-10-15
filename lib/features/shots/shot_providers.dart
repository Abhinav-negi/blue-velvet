import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// App documents folder ("files"). Tests override with a temp dir.
final filesDirProvider = FutureProvider<Directory>(
  (ref) => getApplicationDocumentsDirectory(),
);

/// Returns a picked image's path, or null if cancelled. Tests override.
final imagePickerProvider = Provider<Future<String?> Function()>(
  (ref) =>
      () async =>
          (await ImagePicker().pickImage(source: ImageSource.gallery))?.path,
);

final shotsProvider = StreamProvider<List<Shot>>(
  (ref) =>
      (ref.watch(dbProvider).select(ref.watch(dbProvider).shots)
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch(),
);

final shotProvider = Provider.family<Shot?, String>(
  (ref, id) =>
      ref.watch(shotsProvider).value?.where((s) => s.id == id).firstOrNull,
);

final shotImagesProvider = StreamProvider.family<List<ShotImage>, String>((
  ref,
  shotId,
) {
  final db = ref.watch(dbProvider);
  return (db.select(db.shotImages)
        ..where((t) => t.shotId.equals(shotId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
      .watch();
});

/// Category filter (null = all) and search text.
final shotCategoryFilter = StateProvider<ShotCategory?>((ref) => null);
final shotQuery = StateProvider<String>((ref) => '');

final filteredShotsProvider = Provider<List<Shot>>((ref) {
  final cat = ref.watch(shotCategoryFilter);
  final q = ref.watch(shotQuery).trim().toLowerCase();
  return [
    for (final s in ref.watch(shotsProvider).value ?? const <Shot>[])
      if ((cat == null || s.category == cat) &&
          (q.isEmpty ||
              s.name.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q))))
        s,
  ];
});

/// Copies [source] into `<files>/shot_images/<id>.<ext>` and links it to the
/// shot as a user image (last position).
Future<void> addUserImage(
  AppDatabase db,
  Directory filesDir,
  String shotId,
  File source,
) async {
  final id = const Uuid().v4();
  final rel = 'shot_images/$id${p.extension(source.path).toLowerCase()}';
  final dest = File(p.join(filesDir.path, rel));
  await dest.parent.create(recursive: true);
  await source.copy(dest.path);
  final count = await (db.select(
    db.shotImages,
  )..where((t) => t.shotId.equals(shotId))).get();
  final now = DateTime.now().millisecondsSinceEpoch;
  await db
      .into(db.shotImages)
      .insert(
        ShotImagesCompanion.insert(
          id: id,
          shotId: shotId,
          position: count.length,
          path: rel,
          kind: ShotImageKind.userFile,
          createdAt: now,
          updatedAt: now,
        ),
      );
}

extension ShotCategoryView on ShotCategory {
  String get label => switch (this) {
    ShotCategory.size => 'Size',
    ShotCategory.angle => 'Angle',
    ShotCategory.movement => 'Movement',
    ShotCategory.composition => 'Composition',
    ShotCategory.lens => 'Lens',
    ShotCategory.lighting => 'Lighting',
  };
}

/// A shot image from the bundle or the files folder.
class ShotImageView extends ConsumerWidget {
  const ShotImageView(this.image, {super.key});
  final ShotImage image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broken = Icon(
      Icons.broken_image_outlined,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    if (image.kind == ShotImageKind.seedAsset) {
      return Image.asset(
        image.path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => broken,
      );
    }
    final dir = ref.watch(filesDirProvider).value;
    if (dir == null) return const SizedBox();
    return Image.file(
      File(p.join(dir.path, image.path)),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => broken,
    );
  }
}
