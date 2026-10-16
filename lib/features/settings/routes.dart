import 'package:go_router/go_router.dart';

import 'settings_screen.dart';

final settingsRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/settings',
    name: 'settings',
    builder: (context, state) =>
        SettingsScreen(projectId: state.pathParameters['projectId']),
  ),
];
