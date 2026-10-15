import 'package:drift/drift.dart' show OrderingTerm;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/data/seed_loader.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/beats/template_library_screen.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));

  Future<void> pumpLib(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(
      () => SeedLoader(
        db,
        read: (n) => File('assets/seed/$n.json').readAsString(),
      ).load(),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const TemplateLibraryScreen(),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets('built-ins list from seed; opening one shows ordered slots', (
    tester,
  ) async {
    await pumpLib(tester);

    expect(find.text('Three-act'), findsOneWidget);
    await tester.tap(find.text('Three-act'));
    await settle(tester);
    final slots = await tester.runAsync(
      () =>
          (db.select(db.slots)
                ..where((s) => s.templateId.equals('three-act'))
                ..orderBy([(s) => OrderingTerm.asc(s.position)]))
              .get(),
    );
    expect(slots!.length, greaterThan(2));
    final ys = [
      for (final (i, s) in slots.indexed)
        tester.getTopLeft(find.text('${i + 1}. ${s.name}')).dy,
    ];
    expect(ys, [...ys]..sort());
    expect(find.text(slots.first.description), findsOneWidget);
    await finish(tester);
  });

  testWidgets(
    'create with 3 slots saves; editing a built-in marks user_edited',
    (tester) async {
      await pumpLib(tester);
      await tester.tap(find.text('New template'));
      await settle(tester);
      await tester.enterText(find.byKey(const Key('tpl-name')), 'Mine');
      for (var i = 0; i < 3; i++) {
        await tester.ensureVisible(find.text('Add slot'));
        await tester.tap(find.text('Add slot'));
        await tester.pump();
        await tester.enterText(find.byKey(Key('slot-name-$i')), 'S$i');
      }
      await tester.tap(find.text('Save'));
      await settle(tester);
      final mine = await tester.runAsync(
        () => (db.select(
          db.templates,
        )..where((t) => t.name.equals('Mine'))).getSingle(),
      );
      expect(mine!.builtin, false);
      final saved = await tester.runAsync(
        () =>
            (db.select(db.slots)
                  ..where((s) => s.templateId.equals(mine.id))
                  ..orderBy([(s) => OrderingTerm.asc(s.position)]))
                .get(),
      );
      expect(saved!.map((s) => s.name), ['S0', 'S1', 'S2']);

      await tester.tap(find.text('Three-act'));
      await settle(tester);
      await tester.tap(find.byTooltip('Edit'));
      await settle(tester);
      await tester.enterText(find.byKey(const Key('tpl-desc')), 'Changed');
      await tester.tap(find.text('Save'));
      await settle(tester);
      final t = await tester.runAsync(
        () => (db.select(
          db.templates,
        )..where((t) => t.id.equals('three-act'))).getSingle(),
      );
      expect(t!.userEdited, true);
      expect(t.description, 'Changed');
      final s0 = await tester.runAsync(
        () => (db.select(
          db.slots,
        )..where((s) => s.templateId.equals('three-act'))).get(),
      );
      expect(
        s0!.every((s) => !s.userEdited),
        true,
      ); // untouched slots stay clean
      await finish(tester);
    },
  );
}
