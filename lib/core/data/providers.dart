import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db.dart';
import 'seed_loader.dart';

/// The app's one database. main() overrides it with [openAppDatabase];
/// tests override it with `AppDatabase(NativeDatabase.memory())`.
final dbProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('dbProvider must be overridden'),
);

/// Opens the on-device DB and loads seed data (version-gated, so cheap after
/// the first run). Call once at startup.
Future<AppDatabase> openAppDatabase() async {
  final db = AppDatabase(driftDatabase(name: 'lynch'));
  await SeedLoader(db).load();
  return db;
}
