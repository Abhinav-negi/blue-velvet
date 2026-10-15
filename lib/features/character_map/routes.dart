import 'package:go_router/go_router.dart';

import 'map_screen.dart';

final characterMapRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/map',
    name: 'character-map',
    builder: (context, state) =>
        MapScreen(projectId: state.pathParameters['projectId']!),
  ),
];
