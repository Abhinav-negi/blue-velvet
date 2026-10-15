import 'package:go_router/go_router.dart';

import 'storyboard_screen.dart';

final storyboardRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/board',
    name: 'board',
    builder: (context, state) => const BoardScreen(),
  ),
];
