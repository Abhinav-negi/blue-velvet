import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'router.dart';

void main() => runApp(const ProviderScope(child: LynchApp()));

class LynchApp extends StatelessWidget {
  const LynchApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Lynch',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    routerConfig: router,
  );
}
