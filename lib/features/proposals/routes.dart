import 'package:go_router/go_router.dart';

import 'history_screen.dart';
import 'proposal_screen.dart';
import 'proposals_screen.dart';

final proposalsRoutes = <RouteBase>[
  GoRoute(
    path: '/project/:projectId/history',
    name: 'history',
    builder: (context, state) =>
        HistoryScreen(projectId: state.pathParameters['projectId']!),
    routes: [
      GoRoute(
        path: ':snapshotId',
        name: 'snapshot',
        builder: (context, state) =>
            SnapshotViewScreen(id: state.pathParameters['snapshotId']!),
      ),
    ],
  ),
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
