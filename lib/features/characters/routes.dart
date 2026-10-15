import 'package:go_router/go_router.dart';

import 'character_pool_screen.dart';
import 'character_sheet_screen.dart';
import 'characters_screen.dart';

final charactersRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/characters',
    name: 'characters',
    builder: (context, state) =>
        CharactersScreen(projectId: state.pathParameters['projectId']!),
    routes: [
      GoRoute(
        path: 'new',
        name: 'character-new',
        builder: (context, state) =>
            CharacterSheetScreen(projectId: state.pathParameters['projectId']),
      ),
      // Global pool, inside the project shell (router.dart is frozen).
      GoRoute(
        path: 'pool',
        name: 'character-pool',
        builder: (context, state) => const CharacterPoolScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: 'pool-character-new',
            builder: (context, state) => const CharacterSheetScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'pool-character',
            builder: (context, state) =>
                CharacterSheetScreen(id: state.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(
        path: ':memberId',
        name: 'character-sheet',
        builder: (context, state) => CharacterSheetScreen(
          projectId: state.pathParameters['projectId'],
          id: state.pathParameters['memberId'],
        ),
      ),
    ],
  ),
];
