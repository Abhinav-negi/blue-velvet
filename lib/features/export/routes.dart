import 'package:go_router/go_router.dart';

import 'export_screen.dart';

final exportRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/export',
    name: 'export',
    builder: (context, state) =>
        ExportScreen(projectId: state.pathParameters['projectId']!),
  ),
];
