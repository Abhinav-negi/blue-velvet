import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/character_map/map_providers.dart';
import 'package:lynch/features/character_map/routes.dart';

Future<void> loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  late AppDatabase db;
  String? opened;

  setUpAll(() async {
    // Real async asset read, cached for the dialog's provider.
    await rootBundle.loadString('assets/seed/relationship_labels.json');
    final lucide = Directory(
      '${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev',
    ).listSync().firstWhere((e) => e.path.contains('lucide_icons_flutter-'));
    await loadFont(
      'packages/lucide_icons_flutter/Lucide',
      '${lucide.path}/assets/lucide.ttf',
    );
    await loadFont('Inter', 'assets/fonts/Inter-VF.ttf');
    await loadFont('Literata', 'assets/fonts/Literata-VF.ttf');
  });

  Future<void> seed() async {
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: 'p',
        title: 'P',
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: const {},
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    for (final (i, n) in ['Ada Lovelace', 'Bob'].indexed) {
      await db
          .into(db.characters)
          .insert(
            CharactersCompanion.insert(
              id: 'c$i',
              name: n,
              role: '',
              appearance: '',
              background: '',
              traits: '',
              habits: '',
              wantsNeedsFears: '',
              notes: '',
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      await db
          .into(db.projectCharacters)
          .insert(
            ProjectCharactersCompanion.insert(
              id: 'm$i',
              projectId: 'p',
              characterId: Value('c$i'),
              mode: CharacterMode.linked,
              createdAt: 1,
              updatedAt: 1,
            ),
          );
    }
    await editMap(db, 'p', (d) {
      d.nodes.addAll([
        {
          'id': 'n0',
          'project_character_id': 'm0',
          'x': 100.0,
          'y': 100.0,
          'group_id': null,
        },
        {
          'id': 'n1',
          'project_character_id': 'm1',
          'x': 300.0,
          'y': 200.0,
          'group_id': null,
        },
      ]);
    });
  }

  Future<void> pump(WidgetTester t) async {
    t.view.physicalSize = const Size(400, 700);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            initialLocation: '/project/p/map',
            routes: [
              ...characterMapRoutes,
              GoRoute(
                path: '/project/:projectId/characters/:memberId',
                name: 'character-sheet',
                builder: (c, s) {
                  opened = s.pathParameters['memberId'];
                  return const Scaffold(body: Text('SHEET'));
                },
              ),
            ],
          ),
        ),
      ),
    );
    await settle(t);
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await t.runAsync(db.close);
  }

  setUp(() {
    opened = null;
    db = AppDatabase(NativeDatabase.memory());
  });

  testWidgets('drag and link persist across reload', (t) async {
    await t.runAsync(seed);
    await pump(t);
    await t.drag(find.byKey(const Key('node-n0')), const Offset(50, 30));
    await settle(t);
    await t.longPress(find.byKey(const Key('node-n0')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('link-n1')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('label-field')), 'rival');
    await t.tap(find.byKey(const Key('label-save')));
    await settle(t);
    // Fresh tree = reload; everything must come from the DB.
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await pump(t);
    final row = (await t.runAsync(() => db.charactersDao.mapFor('p')))!;
    final n0 = row.nodes.firstWhere((n) => n['id'] == 'n0');
    // Touch slop eats part of the first move; the rest must be saved.
    expect(n0['x'], greaterThan(110));
    expect(n0['y'], greaterThan(100));
    expect(row.edges.single['label'], 'rival');
    expect(find.text('rival'), findsOneWidget);
    await finish(t);
  });

  testWidgets('label quick-picks come from the seed; free text works', (
    t,
  ) async {
    await t.runAsync(seed);
    await pump(t);
    await t.longPress(find.byKey(const Key('node-n0')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('link-n1')));
    await t.pumpAndSettle();
    await settle(t);
    final seedLabels = [
      for (final i in jsonDecode(
        File('assets/seed/relationship_labels.json').readAsStringSync(),
      )['items'])
        i['name'] as String,
    ];
    expect(seedLabels, isNotEmpty);
    expect(find.widgetWithText(ActionChip, seedLabels.first), findsOneWidget);
    await t.tap(find.widgetWithText(ActionChip, seedLabels.first));
    await t.pump();
    expect(
      (t.widget<TextField>(find.byKey(const Key('label-field'))).controller!)
          .text,
      seedLabels.first,
    );
    await t.enterText(find.byKey(const Key('label-field')), 'old flame');
    await t.tap(find.byKey(const Key('label-save')));
    await settle(t);
    final row = (await t.runAsync(() => db.charactersDao.mapFor('p')))!;
    expect(row.edges.single['label'], 'old flame');
    await finish(t);
  });

  testWidgets('tapping a node opens the character sheet', (t) async {
    await t.runAsync(seed);
    await pump(t);
    await t.tap(find.byKey(const Key('node-n1')));
    await t.pumpAndSettle();
    expect(find.text('SHEET'), findsOneWidget);
    expect(opened, 'm1');
    await finish(t);
  });

  testWidgets('screenshot', (t) async {
    await t.runAsync(seed);
    await t.runAsync(
      () => editMap(db, 'p', (d) {
        d.groups.add({'id': 'g', 'name': 'Family', 'color': 'sage'});
        d.nodes[0]['group_id'] = 'g';
        d.nodes[0]['x'] = 40.0;
        d.nodes[0]['y'] = 120.0;
        d.nodes[1]['x'] = 240.0;
        d.nodes[1]['y'] = 260.0;
        d.edges.add({
          'id': 'e',
          'from_node_id': 'n0',
          'to_node_id': 'n1',
          'label': 'sister',
        });
      }),
    );
    await pump(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/map.png'),
    );
    await finish(t);
  });
}

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 3; i++) {
    await t.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await t.pump();
  }
  await t.pumpAndSettle();
}
