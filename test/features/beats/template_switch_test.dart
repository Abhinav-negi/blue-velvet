import 'package:drift/drift.dart' show OrderingTerm;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/beats/template_switch.dart';

class FakeAi extends AiClient {
  FakeAi(this.reply) : super(readStoredKey: () async => 'k');
  final Map<String, dynamic> Function() reply;
  int calls = 0;
  @override
  Future<Map<String, dynamic>> generateJson({
    required String prompt,
    required Map<String, dynamic> schema,
    List<Map<String, dynamic>> extraParts = const [],
    AiPermission? gate,
    Map<String, dynamic> permissions = const {},
  }) async {
    calls++;
    return reply();
  }
}

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<List<Slot>> seed(WidgetTester tester, bool auto) async {
    await tester.runAsync(() async {
      await SeedLoader(
        db,
        read: (n) => File('assets/seed/$n.json').readAsString(),
      ).load();
      await db
          .into(db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: 'p',
              title: 'P',
              type: ProjectType.shortFilm,
              summary: '',
              aspectRatio: '16:9',
              typeFields: const {},
              aiPermissions: {'auto_placement': auto},
              createdAt: 1,
              updatedAt: 1,
            ),
          );
      for (var i = 0; i < 3; i++) {
        await db.beatsDao.upsert(
          BeatsCompanion.insert(
            id: 'b$i',
            projectId: 'p',
            position: i,
            title: 'Beat $i',
            description: '',
            characterIds: const [],
            createdAt: 1,
            updatedAt: 1,
          ),
        );
      }
    });
    return tester
        .runAsync(
          () =>
              (db.select(db.slots)
                    ..where((s) => s.templateId.equals(_tpl))
                    ..orderBy([(s) => OrderingTerm.asc(s.position)]))
                  .get(),
        )
        .then((v) => v!);
  }

  Future<void> pump(WidgetTester tester, FakeAi ai) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          beatsAiProvider.overrideWithValue(ai),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const TemplateSwitchScreen(projectId: 'p', templateId: _tpl),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('AI proposal, drag in preview, confirm: count unchanged', (
    tester,
  ) async {
    final slots = await seed(tester, true);
    final ai = FakeAi(
      () => {
        'placements': [
          for (var i = 0; i < 3; i++)
            {'beat_id': 'b$i', 'slot_id': slots[0].id, 'position': i},
        ],
      },
    );
    await pump(tester, ai);
    expect(ai.calls, 1);

    // Drag Beat 0 from the first slot onto the "Unplaced" header.
    final g = await tester.startGesture(tester.getCenter(find.text('Beat 0')));
    await g.moveBy(const Offset(0, 20));
    await g.moveTo(tester.getCenter(find.text('Unplaced')));
    await g.up();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    final rows = await tester.runAsync(() => db.select(db.beats).get());
    expect(rows!.length, 3);
    expect(rows.firstWhere((b) => b.id == 'b0').slotId, null);
    expect(rows.firstWhere((b) => b.id == 'b1').slotId, slots[0].id);
    final p = await tester.runAsync(() => db.select(db.projects).getSingle());
    expect(p!.templateId, _tpl);
    await finish(tester);
  });

  testWidgets('auto-placement off: no AI call, all beats unplaced', (
    tester,
  ) async {
    await seed(tester, false);
    final ai = FakeAi(() => throw StateError('must not be called'));
    await pump(tester, ai);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(ai.calls, 0);
    final rows = await tester.runAsync(() => db.select(db.beats).get());
    expect(rows!.length, 3);
    expect(rows.every((b) => b.slotId == null), isTrue);
    await finish(tester);
  });
}

const _tpl = 'three-act';
