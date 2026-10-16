import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/beats/template_library_screen.dart';

void main() {
  testWidgets('template library links to shot-fetch', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const TemplateLibraryScreen()),
        GoRoute(
          path: '/shots/fetch',
          name: 'shot-fetch',
          builder: (_, _) => const Scaffold(body: Text('stub-fetch')),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Fetch shots'));
    await tester.pumpAndSettle();
    expect(find.text('stub-fetch'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  });
}
