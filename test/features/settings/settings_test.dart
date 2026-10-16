import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/ai/key_store.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/features/settings/settings_providers.dart';
import 'package:lynch/features/settings/settings_screen.dart';

void main() {
  late AppDatabase db;
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
  });

  Future<void> seedProject(Map<String, dynamic> perms) => db.projectsDao.upsert(
    ProjectsCompanion.insert(
      id: 'p',
      title: 'P',
      type: ProjectType.shortFilm,
      summary: '',
      aspectRatio: '16:9',
      typeFields: const {},
      aiPermissions: perms,
      createdAt: 1,
      updatedAt: 1,
    ),
  );

  Future<void> pump(WidgetTester t) async {
    t.view.physicalSize = const Size(800, 3000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [dbProvider.overrideWithValue(db)],
        child: Consumer(
          builder: (c, ref, _) => MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ref.watch(themeModeProvider).value ?? ThemeMode.dark,
            home: const Scaffold(body: SettingsScreen(projectId: 'p')),
          ),
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 50));
  }

  Future<void> end(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 1));
  }

  testWidgets('new project inherits global defaults; project toggle persists', (
    t,
  ) async {
    await t.runAsync(() async {
      // Unset: contract values.
      expect(await newProjectAiPermissions(db), contractAiDefaults);
      await seedProject(await newProjectAiPermissions(db));
    });
    await pump(t);
    // Change a global default, then a new project inherits it.
    await t.tap(find.byKey(const ValueKey('default-internet_fetch')));
    await t.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect((await newProjectAiPermissions(db))['internet_fetch'], true);
      expect(
        (await db.projectsDao.byId('p'))!.aiPermissions['internet_fetch'],
        false,
      );
    });
    // Toggle the project switch.
    await t.tap(find.byKey(const ValueKey('project-shot_suggestions')));
    await t.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final p = await db.projectsDao.byId('p');
      expect(aiAllowed(p!.aiPermissions, AiPermission.shotSuggestions), true);
      expect(p.aiPermissions.length, 8);
    });
    await end(t);
  });

  testWidgets('API key saves to secure storage and shows masked only', (
    t,
  ) async {
    await t.runAsync(() => seedProject({}));
    await pump(t);
    await t.enterText(find.byType(TextField), 'AIzaSECRET1234');
    await t.tap(find.text('Save key'));
    await t.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(await readSecureGeminiKey(), 'AIzaSECRET1234');
    });
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('•••• 1234'), findsOneWidget);
    expect(find.textContaining('AIzaSECRET'), findsNothing);
    await end(t);
  });

  testWidgets('theme toggle changes frame colours, not paper', (t) async {
    await t.runAsync(() => seedProject({}));
    await pump(t);
    BuildContext ctx() => t.element(find.byType(SettingsScreen));
    final darkBg = Theme.of(ctx()).scaffoldBackgroundColor;
    final paper = Theme.of(ctx()).extension<PaperColors>()!.bg;
    await t.tap(find.byKey(const ValueKey('theme-light')));
    await t.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    for (var i = 0; i < 3; i++) {
      await t.pump(const Duration(milliseconds: 500));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
    }
    expect(Theme.of(ctx()).scaffoldBackgroundColor, isNot(darkBg));
    expect(Theme.of(ctx()).extension<PaperColors>()!.bg, paper);
    await end(t);
  });
}
