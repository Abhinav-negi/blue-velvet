import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/beats/beats_screen.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  late AppDatabase db;
  late List<Slot> slots;

  setUpAll(() async {
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    await loadFont('Literata', 'assets/fonts/Literata-VF.ttf');
    final lucide = Directory(
      '${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev',
    ).listSync().firstWhere((e) => e.path.contains('lucide_icons_flutter-'));
    await loadFont(
      'packages/lucide_icons_flutter/Lucide',
      '${lucide.path}/assets/lucide.ttf',
    );
  });

  Future<void> addBeat(String id, String? slot, int pos, String title) =>
      db.beatsDao.upsert(
        BeatsCompanion.insert(
          id: id,
          projectId: 'p',
          slotId: Value(slot),
          position: pos,
          title: title,
          description: 'About $title.',
          characterIds: const [],
          blocks: Value(id == 'b1' ? [<String, dynamic>{}] : null),
          createdAt: 1,
          updatedAt: 1,
        ),
      );

  Future<void> pump(
    WidgetTester t, {
    required bool template,
    bool still = false,
    GoRouter? router,
  }) async {
    t.view.physicalSize = const Size(400, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    db = AppDatabase(NativeDatabase.memory());
    await t.runAsync(() async {
      await SeedLoader(
        db,
        read: (n) => File('assets/seed/$n.json').readAsString(),
      ).load();
      slots =
          await (db.select(
              db.slots,
            )..where((s) => s.templateId.equals('three-act'))).get()
            ..sort((a, b) => a.position.compareTo(b.position));
      await db
          .into(db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: 'p',
              title: 'P',
              type: ProjectType.shortFilm,
              summary: '',
              templateId: Value(template ? 'three-act' : null),
              aspectRatio: '16:9',
              typeFields: const {},
              aiPermissions: const {},
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      // Second slot stays empty on purpose.
      await addBeat('b1', slots[0].id, 0, 'Opening image');
      await addBeat('b2', slots[2].id, 1, 'The turn');
      await addBeat('b3', slots[0].id, 2, 'First look');
      await addBeat('b4', null, 3, 'Loose idea');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await t.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          builder: still
              ? (c, w) => MediaQuery(
                  data: MediaQuery.of(c).copyWith(disableAnimations: true),
                  child: w!,
                )
              : null,
          routerConfig:
              router ??
              GoRouter(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (_, _) => const BeatsScreen(projectId: 'p'),
                  ),
                ],
              ),
        ),
      ),
    );
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
    await t.pumpAndSettle();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await t.runAsync(db.close);
  }

  testWidgets('beats sit under their slots; empty slots show no warning', (
    t,
  ) async {
    await pump(t, template: true);
    double top(String s) => t.getTopLeft(find.text(s)).dy;
    final h = [for (final s in slots) top(s.name)];
    expect(h, [...h]..sort());
    expect(top('Opening image'), inOrderBetween(h[0], h[1]));
    expect(top('First look'), inOrderBetween(h[0], h[1]));
    expect(top('The turn'), inOrderBetween(h[2], h.length > 3 ? h[3] : 1e9));
    // Empty slot: header only, nothing between it and the next header.
    expect(find.text(slots[1].name), findsOneWidget);
    expect(find.textContaining('empty', findRichText: true), findsNothing);
    expect(top('Loose idea'), greaterThan(top('The turn')));
    expect(find.text('Unplaced'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/board.png'),
    );
    await finish(t);
  });

  testWidgets('Pull from Void pushes void-pick with the project id', (t) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const BeatsScreen(projectId: 'p'),
        ),
        GoRoute(
          path: '/void/pick/:projectId',
          name: 'void-pick',
          builder: (_, s) => Text('pick ${s.pathParameters['projectId']}'),
        ),
      ],
    );
    await pump(t, template: false, router: router);
    await t.tap(find.byTooltip('Pull from Void'));
    await t.pumpAndSettle();
    expect(find.text('pick p'), findsOneWidget);
    await finish(t);
  });

  testWidgets('no template: ordered plain list', (t) async {
    await pump(t, template: false);
    final ys = [
      for (final s in ['Opening image', 'The turn', 'First look', 'Loose idea'])
        t.getTopLeft(find.text(s)).dy,
    ];
    expect(ys, [...ys]..sort());
    expect(find.text(slots[0].name), findsNothing);
    await finish(t);
  });

  testWidgets('add a beat saves it', (t) async {
    await pump(t, template: false);
    await t.tap(find.text('Add beat'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).first, 'Fresh beat');
    await t.tap(find.text('Save'));
    await t.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await t.pumpAndSettle();
    expect(find.text('Fresh beat'), findsOneWidget);
    await finish(t);
  });

  Future<void> drag(WidgetTester t, String from, Finder to) async {
    final g = await t.startGesture(t.getCenter(find.text(from)));
    await t.pump(const Duration(milliseconds: 600));
    await g.moveTo(t.getCenter(to));
    await t.pump();
    await g.up();
  }

  Future<List<Beat>> rows(WidgetTester t) async => (await t.runAsync(
    () => (db.select(
      db.beats,
    )..orderBy([(b) => OrderingTerm.asc(b.position)])).get(),
  ))!;

  testWidgets('dragging a beat to another slot updates slot and order', (
    t,
  ) async {
    await pump(t, template: true);
    // Drop "The turn" (slot 2) onto "Opening image" (slot 0, index 0).
    await drag(t, 'The turn', find.text('Opening image'));
    await t.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await t.pumpAndSettle();
    final r = await rows(t);
    expect([for (final b in r) b.id], ['b2', 'b1', 'b3', 'b4']);
    expect([for (final b in r) b.position], [0, 1, 2, 3]);
    expect(r.first.slotId, slots[0].id);
    await finish(t);
  });

  testWidgets('disableAnimations: reorder completes in one frame', (t) async {
    await pump(t, template: false, still: true);
    await drag(t, 'Loose idea', find.text('Opening image'));
    for (var i = 0; i < 3; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
    }
    expect(t.hasRunningAnimations, isFalse);
    expect(
      t.getTopLeft(find.text('Loose idea')).dy,
      lessThan(t.getTopLeft(find.text('Opening image')).dy),
    );
    await finish(t);
  });
}

Matcher inOrderBetween(double a, double b) =>
    allOf(greaterThan(a), lessThan(b));
