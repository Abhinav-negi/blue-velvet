import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/home/home_screen.dart';
import 'package:lynch/features/home/overview_screen.dart';
import 'package:lynch/features/home/sample_project.dart';

/// Pumps [screen] at '/' in a router whose other routes are stub pages.
Future<AppDatabase> pumpWithStubs(
  WidgetTester tester,
  Widget screen,
  String path,
  List<(String, String)> stubs,
) async {
  final db = AppDatabase(NativeDatabase.memory());
  await tester.runAsync(
    () => db.projectsDao.upsert(
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
    ),
  );
  final router = GoRouter(
    initialLocation: path.replaceAll(':projectId', 'p'),
    routes: [
      GoRoute(path: path, builder: (_, _) => screen),
      for (final (name, p) in stubs)
        GoRoute(
          path: p,
          name: name,
          builder: (_, _) => Scaffold(body: Text('stub-$name')),
        ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
        sampleInitProvider.overrideWith((ref) async {}),
      ],
      child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
    ),
  );
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
  return db;
}

Future<void> finish(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.runAsync(db.close);
}

void main() {
  for (final k in ['export', 'history']) {
    testWidgets('overview links to $k', (tester) async {
      final db = await pumpWithStubs(
        tester,
        const Scaffold(body: OverviewScreen()),
        '/project/:projectId/overview',
        [(k, '/project/:projectId/$k')],
      );
      await tester.tap(find.byKey(Key('overview-$k')));
      await tester.pumpAndSettle();
      expect(find.text('stub-$k'), findsOneWidget);
      await finish(tester, db);
    });
  }

  testWidgets('home links to the shot library', (tester) async {
    final db = await pumpWithStubs(tester, const HomeScreen(), '/', [
      ('shots', '/shots'),
    ]);
    await tester.tap(find.byTooltip('Shot library'));
    await tester.pumpAndSettle();
    expect(find.text('stub-shots'), findsOneWidget);
    await finish(tester, db);
  });
}
