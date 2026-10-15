import 'package:go_router/go_router.dart';

import 'proposals_screen.dart';

final proposalsRoutes = <RouteBase>[
  GoRoute(
    path: '/proposals',
    name: 'proposals',
    builder: (context, state) => const ProposalsScreen(),
  ),
];
