import 'package:go_router/go_router.dart';

import 'void_item_screen.dart';
import 'void_screen.dart';

final voidRoutes = <RouteBase>[
  GoRoute(
    path: '/void',
    name: 'void',
    builder: (context, state) => const VoidScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: 'void-item',
        builder: (context, state) =>
            VoidItemScreen(id: state.pathParameters['id']!),
      ),
    ],
  ),
];
