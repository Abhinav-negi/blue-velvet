import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'core/widgets/app_shell.dart';
import 'features/beats/routes.dart';
import 'features/capture/routes.dart';
import 'features/character_map/routes.dart';
import 'features/characters/routes.dart';
import 'features/export/routes.dart';
import 'features/home/routes.dart';
import 'features/proposals/routes.dart';
import 'features/script/routes.dart';
import 'features/settings/routes.dart';
import 'features/shots/routes.dart';
import 'features/storyboard/routes.dart';
import 'features/void/routes.dart';

/// Project sections in tab order; [name] is the section's route name.
const _sections = <({String name, ShellTab tab})>[
  (
    name: 'overview',
    tab: ShellTab(label: 'Overview', icon: LucideIcons.layoutDashboard),
  ),
  (
    name: 'characters',
    tab: ShellTab(label: 'Characters', icon: LucideIcons.users),
  ),
  (name: 'beats', tab: ShellTab(label: 'Beats', icon: LucideIcons.layoutGrid)),
  (name: 'script', tab: ShellTab(label: 'Script', icon: LucideIcons.fileText)),
  (
    name: 'board',
    tab: ShellTab(label: 'Board', icon: LucideIcons.clapperboard),
  ),
  (
    name: 'settings',
    tab: ShellTab(label: 'Settings', icon: LucideIcons.settings),
  ),
];

final router = GoRouter(
  routes: [
    ...homeRoutes,
    ...voidRoutes,
    ...proposalsRoutes,
    ...captureRoutes,
    ...characterMapRoutes,
    ...shotsRoutes,
    ...exportRoutes,
    ShellRoute(
      builder: (context, state, child) {
        final id = state.pathParameters['projectId']!;
        final index = _sections.indexWhere(
          (s) => s.name == state.topRoute?.name,
        );
        return AppShell(
          tabs: [for (final s in _sections) s.tab],
          selectedIndex: index < 0 ? 0 : index,
          onTab: (i) => context.goNamed(
            _sections[i].name,
            pathParameters: {'projectId': id},
          ),
          onHome: () => context.goNamed('home'),
          onInbox: () => context.pushNamed('proposals'),
          child: child,
        );
      },
      routes: [
        ...overviewRoutes,
        ...charactersRoutes,
        ...beatsRoutes,
        ...scriptRoutes,
        ...storyboardRoutes,
        ...settingsRoutes,
      ],
    ),
  ],
);
