import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/features/storyboard/frames_providers.dart';
import 'package:lynch/features/storyboard/storyboard_screen.dart';

void main() {
  late AppDatabase db;
  late Directory dir;
  late Beat beat;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dir = Directory.systemTemp.createTempSync('sb01');
  });
  tearDown(() => dir.deleteSync(recursive: true));

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
    await db.beatsDao.upsert(
      BeatsCompanion.insert(
        id: 'b',
        projectId: 'p',
        position: 0,
        title: 'Opening',
        description: '',
        characterIds: const [],
        createdAt: 1,
        updatedAt: 1,
      ),
    );
    beat = await db.select(db.beats).getSingle();
  }

  Future<List<Frame>> frames() => (db.select(
    db.frames,
  )..orderBy([(f) => OrderingTerm.asc(f.position)])).get();

  /// Real IO (drift, files) and fake-async continuations alternate.
  Future<void> work(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> pumpBoard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          filesDirProvider.overrideWith((ref) async => dir),
        ],
        child: MaterialApp(
          home: Scaffold(body: BoardScreen(projectId: 'p')),
        ),
      ),
    );
    await work(tester);
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('duplicate copies details and stroke file; delete keeps file', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await seed();
      await addFrame(db, beat.id);
      File('${dir.path}/strokes.json').writeAsStringSync('[1]');
      await (db.update(db.frames)).write(
        const FramesCompanion(
          strokesPath: Value('strokes.json'),
          shotSize: Value('Close-up'),
          notes: Value('hands'),
        ),
      );
      await addFrame(db, beat.id);
    });
    await pumpBoard(tester);
    await tester.tap(find.byTooltip('Duplicate frame').first);
    await work(tester);
    final all = (await tester.runAsync(frames))!;
    expect(all.map((f) => f.position), [0, 1, 2]);
    final copy = all[1];
    expect(copy.shotSize, 'Close-up');
    expect(copy.notes, 'hands');
    expect(copy.strokesPath, isNot('strokes.json'));
    expect(File('${dir.path}/${copy.strokesPath}').readAsStringSync(), '[1]');

    await tester.tap(find.byTooltip('Delete frame').at(1));
    await work(tester);
    final left = (await tester.runAsync(frames))!;
    expect(left.map((f) => f.position), [0, 1]);
    expect(left.any((f) => f.id == copy.id), isFalse);
    // DATA_MODEL 13.1: stroke file survives delete until compaction.
    expect(File('${dir.path}/${copy.strokesPath}').existsSync(), isTrue);
    await finish(tester);
  });

  testWidgets('shot details save and show in the caption', (tester) async {
    await tester.runAsync(() async {
      await seed();
      await addFrame(db, beat.id);
    });
    await pumpBoard(tester);
    expect(find.text('No shot details'), findsOneWidget);
    await tester.tap(find.text('No shot details'));
    await tester.pumpAndSettle();
    for (final e in {
      'Shot size': 'Wide',
      'Angle': 'Low',
      'Movement': 'Dolly',
      'Lens': '35mm',
      'Duration (seconds)': '2.5',
      'Notes': 'Rain',
    }.entries) {
      await tester.enterText(find.widgetWithText(TextField, e.key), e.value);
    }
    await tester.tap(find.text('Save'));
    await work(tester);
    expect(find.text('Wide · Low · Dolly · 35mm · 2.5s'), findsOneWidget);
    expect(find.text('Rain'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('reorder keeps positions contiguous', (tester) async {
    await tester.runAsync(() async {
      await seed();
      for (var i = 0; i < 3; i++) {
        await addFrame(db, beat.id);
      }
      final ids = (await frames()).map((f) => f.id).toList();
      await moveFrame(db, beat.id, 0, 2);
      final after = await frames();
      expect(after.map((f) => f.position), [0, 1, 2]);
      expect(after.map((f) => f.id), [ids[1], ids[2], ids[0]]);
    });
    await pumpBoard(tester);
    expect(find.text('Board'), findsOneWidget);
    await finish(tester);
  });
}
