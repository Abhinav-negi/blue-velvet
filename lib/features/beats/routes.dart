import 'package:go_router/go_router.dart';

import 'beats_screen.dart';

final beatsRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/beats',
    name: 'beats',
    builder: (context, state) => const BeatsScreen(),
  ),
];
