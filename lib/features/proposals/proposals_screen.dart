import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'proposals_providers.dart';

/// Inbox: pending proposals, oldest first.
class ProposalsScreen extends ConsumerWidget {
  const ProposalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(pendingProposalsProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Proposals')),
      body: items == null
          ? const SizedBox.shrink()
          : items.isEmpty
          ? Center(child: Text('Nothing to review.', style: AppType.body))
          : ListView(
              padding: const EdgeInsets.all(AppSize.sideMargin),
              children: [
                for (final p in items)
                  ListTile(
                    minTileHeight: AppSize.minTouch,
                    title: Text(
                      p.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.body,
                    ),
                    subtitle: Text(
                      '${ref.watch(projectTitleProvider(p.projectId)).value ?? ''}'
                      ' · ${touchHeader(p.changes)}',
                      style: AppType.caption,
                    ),
                    onTap: () => context.pushNamed(
                      'proposal',
                      pathParameters: {'id': p.id},
                    ),
                  ),
              ],
            ),
    );
  }
}
