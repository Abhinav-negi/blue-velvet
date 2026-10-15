import 'package:go_router/go_router.dart';

import 'proposal_screen.dart';
import 'proposals_screen.dart';

final proposalsRoutes = <RouteBase>[
  GoRoute(
    path: '/proposals',
    name: 'proposals',
    builder: (context, state) => const ProposalsScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: 'proposal',
        builder: (context, state) =>
            ProposalScreen(id: state.pathParameters['id']!),
      ),
    ],
  ),
];
