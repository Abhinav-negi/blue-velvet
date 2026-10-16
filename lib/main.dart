import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/data/providers.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await openAppDatabase();
  runApp(
    ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const LynchApp(),
    ),
  );
}

class LynchApp extends ConsumerWidget {
  const LynchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Lynch',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ref.watch(themeModeProvider).value ?? ThemeMode.dark,
    routerConfig: router,
  );
}
