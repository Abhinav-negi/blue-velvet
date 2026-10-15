import 'package:go_router/go_router.dart';

import 'beats_screen.dart';
import 'template_library_screen.dart';

final beatsRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/beats',
    name: 'beats',
    builder: (context, state) => const BeatsScreen(),
    routes: [
      GoRoute(
        path: 'templates',
        name: 'templates',
        builder: (context, state) => const TemplateLibraryScreen(),
      ),
    ],
  ),
];
