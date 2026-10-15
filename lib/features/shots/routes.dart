import 'package:go_router/go_router.dart';

import 'shot_detail_screen.dart';
import 'shots_screen.dart';

final shotsRoutes = <RouteBase>[
  GoRoute(
    path: '/shots',
    name: 'shots',
    builder: (context, state) => const ShotsScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: 'shot',
        builder: (context, state) =>
            ShotDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  ),
];
