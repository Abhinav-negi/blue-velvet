import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'db.dart';
import 'seed_mapping.dart';

/// Seed files that have a table (templates+slots, shots+images). The other
/// files in assets/seed (project types, screenplay rules...) have no table and
/// are read straight from the bundle by their features.
const seedFiles = ['templates', 'shots_camera', 'shots_look'];

/// Loads assets/seed/*.json into the DB (docs/DATA_MODEL 0.1): insert missing
/// `seed_id`s, update `builtin AND NOT user_edited` rows, never delete.
/// A file is (re)loaded only when its `version` exceeds the one stored in
/// settings `seed_version`. A bad file is logged and skipped.
class SeedLoader {
  SeedLoader(this.db,
      {Future<String> Function(String)? read,
      this.log,
      int Function()? now})
      : _read = read ?? ((n) => rootBundle.loadString('assets/seed/$n.json')),
        _now = now ?? (() => DateTime.now().millisecondsSinceEpoch);

  final AppDatabase db;
  final Future<String> Function(String name) _read;
  final void Function(String message)? log;
  final int Function() _now;

  Future<void> load() async {
    final stored = await db.settingsDao.get('seed_version');
    final versions = <String, dynamic>{
      if (stored != null) ...jsonDecode(stored) as Map<String, dynamic>,
    };
    for (final name in seedFiles) {
      try {
        final json = jsonDecode(await _read(name)) as Map<String, dynamic>;
        final version = json['version'] as int;
        if (version <= ((versions[name] as int?) ?? 0)) continue;
        await _apply(
            name, (json['items'] as List).cast<Map<String, dynamic>>());
        versions[name] = version;
        await db.settingsDao.put('seed_version', jsonEncode(versions), _now());
      } catch (e) {
        (log ?? debugPrint)('Seed $name skipped: $e');
      }
    }
  }

  Future<void> _apply(String name, List<Map<String, dynamic>> items) {
    final now = _now();
    // Map everything first so a malformed item skips the whole file.
    if (name == 'templates') {
      final rows = [for (final i in items) mapSeedTemplate(i, now)];
      return db.transaction(() async {
        for (final r in rows) {
          await _merge(db.templates, r.template);
          for (final s in r.slots) {
            await _merge(db.slots, s);
          }
        }
      });
    }
    final rows = [for (final i in items) mapSeedShot(i, now)];
    return db.transaction(() async {
      for (final r in rows) {
        await _merge(db.shots, r.shot);
        for (final im in r.images) {
          await _merge(db.shotImages, im);
        }
      }
    });
  }

  /// Insert, or on `seed_id` conflict update only untouched built-in rows.
  Future<void> _merge<T extends SeedColumns, D>(
      TableInfo<T, D> table, Insertable<D> row) {
    // Keep the original creation time on update.
    final update =
        RawValuesInsertable<D>(row.toColumns(false)..remove('created_at'));
    return db.into(table).insert(
          row,
          onConflict: DoUpdate<T, D>(
            (_) => update,
            target: [(table as dynamic).seedId as GeneratedColumn],
            where: (old) =>
                old.builtin.equals(true) & old.userEdited.equals(false),
          ),
        );
  }
}
