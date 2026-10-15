import 'package:drift/drift.dart';

import 'db.dart';

/// The single seed -> DATA_MODEL name mapping (docs/SEED_SCHEMA.md vs
/// docs/DATA_MODEL.md). Fetched entries already use DATA_MODEL names.
const _projectTypeNames = {
  'short-film': 'short_film',
  'long-film': 'long_film',
  'youtube-video': 'youtube',
  'short': 'short',
};

const _categoryNames = {
  'shot_size': ShotCategory.size,
  'angle': ShotCategory.angle,
  'movement': ShotCategory.movement,
  'composition': ShotCategory.composition,
  'lens': ShotCategory.lens,
  'lighting': ShotCategory.lighting,
};

const seedImageDir = 'assets/seed/images/';

({TemplatesCompanion template, List<SlotsCompanion> slots}) mapSeedTemplate(
    Map<String, dynamic> j, int now) {
  final seed = j['id'] as String;
  final urls = (j['source_urls'] as List).cast<String>();
  final slots = (j['slots'] as List).cast<Map<String, dynamic>>();
  return (
    template: TemplatesCompanion.insert(
      id: seed,
      name: j['name'] as String,
      description: j['description'] as String,
      sourceUrl: Value(urls.firstOrNull),
      projectTypes: [
        for (final t in (j['project_types'] as List)) _projectTypeNames[t]!
      ],
      builtin: const Value(true),
      seedId: Value(seed),
      createdAt: now,
      updatedAt: now,
    ),
    slots: [
      for (final (i, s) in slots.indexed)
        SlotsCompanion.insert(
          id: '$seed/${s['id']}',
          templateId: seed,
          position: i,
          name: s['name'] as String,
          description: s['description'] as String,
          runtimeProportion: Value((s['proportion'] as num?)?.toDouble()),
          builtin: const Value(true),
          seedId: Value('$seed/${s['id']}'),
          createdAt: now,
          updatedAt: now,
        )
    ],
  );
}

({ShotsCompanion shot, List<ShotImagesCompanion> images}) mapSeedShot(
    Map<String, dynamic> j, int now) {
  final seed = j['id'] as String;
  final images = (j['images'] as List).cast<Map<String, dynamic>>();
  return (
    shot: ShotsCompanion.insert(
      id: seed,
      name: j['name'] as String,
      category: _categoryNames[j['category']]!,
      description: j['description'] as String,
      whenToUse: j['when_to_use'] as String,
      effect: j['effect'] as String,
      tags: (j['tags'] as List).cast<String>(),
      // Seed has bare URLs; DATA_MODEL wants {title, url}. Title = host.
      sources: [
        for (final u in (j['sources'] as List).cast<String>())
          {'title': Uri.parse(u).host, 'url': u}
      ],
      builtin: const Value(true),
      seedId: Value(seed),
      createdAt: now,
      updatedAt: now,
    ),
    images: [
      for (final (i, im) in images.indexed)
        ShotImagesCompanion.insert(
          id: '$seed/${im['file']}',
          shotId: seed,
          position: i,
          path: '$seedImageDir${im['file']}',
          kind: ShotImageKind.seedAsset,
          license: Value(im['license'] as String),
          author: Value(im['author'] as String),
          sourceUrl: Value(im['source_url'] as String),
          builtin: const Value(true),
          seedId: Value('$seed/${im['file']}'),
          createdAt: now,
          updatedAt: now,
        )
    ],
  );
}
