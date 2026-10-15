import 'package:go_router/go_router.dart';

import 'script_screen.dart';

final scriptRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/script',
    name: 'script',
    builder: (context, state) =>
        ScriptScreen(projectId: state.pathParameters['projectId']!),
  ),
];
