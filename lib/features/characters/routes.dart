import 'package:go_router/go_router.dart';

import 'characters_screen.dart';

final charactersRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/characters',
    name: 'characters',
    builder: (context, state) => const CharactersScreen(),
  ),
];
