import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'idea_screen.dart';
import 'overview_screen.dart';

final homeRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/idea/:voidItemId',
    name: 'project-from-idea',
    builder: (context, state) =>
        IdeaScreen(voidItemId: state.pathParameters['voidItemId']!),
  ),
];

/// Project Overview tab (lives in the home/projects area).
final overviewRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/overview',
    name: 'overview',
    builder: (context, state) => const OverviewScreen(),
  ),
];
