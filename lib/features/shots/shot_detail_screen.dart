import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'shot_providers.dart';

class ShotDetailScreen extends ConsumerWidget {
  const ShotDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shot = ref.watch(shotProvider(id));
    final images = ref.watch(shotImagesProvider(id)).value ?? const [];
    final scheme = Theme.of(context).colorScheme;
    if (shot == null) return const Scaffold(body: SizedBox());

    Widget section(String title, String body) => body.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: AppSpace.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.label.copyWith(color: scheme.onSurfaceVariant),
                ),
                Text(body, style: AppType.body),
              ],
            ),
          );

    return Scaffold(
      appBar: AppBar(title: Text(shot.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Text(shot.category.label, style: AppType.label),
          section('What it is', shot.description),
          section('When to use', shot.whenToUse),
          section('Effect', shot.effect),
          if (shot.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s2),
              child: Wrap(
                spacing: AppSpace.s1,
                children: [for (final t in shot.tags) Chip(label: Text(t))],
              ),
            ),
          for (final s in shot.sources)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s1),
              child: Text(
                '${s['title']}: ${s['url']}',
                style: AppType.caption.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          const SizedBox(height: AppSpace.s2),
          for (final im in images)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ShotImageView(im),
                    ),
                  ),
                  if (im.kind == ShotImageKind.seedAsset)
                    Text(
                      '${im.author ?? 'Unknown'} · ${im.license ?? 'Unknown'}',
                      style: AppType.caption.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          OutlinedButton.icon(
            onPressed: () async {
              final path = await ref.read(imagePickerProvider)();
              final dir = await ref.read(filesDirProvider.future);
              if (path == null) return;
              await addUserImage(ref.read(dbProvider), dir, id, File(path));
            },
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Add image'),
          ),
        ],
      ),
    );
  }
}
