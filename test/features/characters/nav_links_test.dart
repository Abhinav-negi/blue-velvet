import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/characters/characters_screen.dart';

void main() {
  testWidgets('characters link to the character map', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const CharactersScreen(projectId: 'p'),
        ),
        GoRoute(
          path: '/project/:projectId/map',
          name: 'character-map',
          builder: (_, _) => const Scaffold(body: Text('stub-map')),
        ),
        GoRoute(
          path: '/project/:projectId/pool',
          name: 'character-pool',
          builder: (_, _) => const Scaffold(body: Text('stub-pool')),
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
    await tester.tap(find.text('Character map'));
    await tester.pumpAndSettle();
    expect(find.text('stub-map'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Character pool'));
    await tester.pumpAndSettle();
    expect(find.text('stub-pool'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(db.close);
  });
}
