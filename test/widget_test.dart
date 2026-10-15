import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/main.dart';

void main() {
  testWidgets('app starts on Home', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: const LynchApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  });
}
