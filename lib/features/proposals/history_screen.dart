import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/proposal_engine.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'proposals_providers.dart';

bool _hasLinked(Map<String, dynamic> data) =>
    (data['project_characters'] as List).any(
      (c) => (c as Map)['mode'] == 'linked',
    );

/// Confirms, restores through the engine, shows ProposalException text on failure.
Future<bool> restoreWithConfirm(
  BuildContext context,
  WidgetRef ref,
  String snapshotId,
  Map<String, dynamic> data,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Restore this version?'),
      content: Text(
        'The project goes back to this version. The current state is saved first, so you can undo it.'
        '${_hasLinked(data) ? '\n\nThis version has linked characters. Restoring changes their shared sheets in every project that uses them.' : ''}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Restore'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return false;
  final m = ScaffoldMessenger.of(context);
  try {
    await ref.read(proposalActionsProvider).restore(snapshotId);
    return true;
  } on ProposalException catch (e) {
    m.showSnackBar(SnackBar(content: Text(e.message)));
    return false;
  }
}

/// Snapshot list, newest first (spec 16.1).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(snapshotsProvider(projectId)).value;
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: items == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(AppSize.sideMargin),
              children: [
                for (final s in items)
                  ListTile(
                    minTileHeight: AppSize.minTouch,
                    title: Text(s.label, style: AppType.body),
                    subtitle: Text(
                      DateTime.fromMillisecondsSinceEpoch(s.createdAt)
                          .toString()
                          .substring(0, 16),
                      style: AppType.caption,
                    ),
                    onTap: () => context.pushNamed(
                      'snapshot',
                      pathParameters: {
                        'projectId': projectId,
                        'snapshotId': s.id,
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}

/// The project as it was (read-only), with Restore.
class SnapshotViewScreen extends ConsumerWidget {
  const SnapshotViewScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(snapshotProvider(id)).value;
    if (s == null) return const Scaffold();
    final d = s.data;
    final project = d['project'] as Map;
    final beats = (d['beats'] as List).cast<Map>();
    final chars = (d['project_characters'] as List).cast<Map>();
    return Scaffold(
      appBar: AppBar(title: Text(s.label, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Text('${project['title']}', style: AppType.label),
          const SizedBox(height: AppSpace.s1),
          Text('${project['summary']}', style: AppType.body),
          const SizedBox(height: AppSpace.s2),
          Text('Beats (${beats.length})', style: AppType.label),
          for (final b in beats) Text('${b['title']}', style: AppType.body),
          const SizedBox(height: AppSpace.s2),
          Text('Characters (${chars.length})', style: AppType.label),
          for (final c in chars)
            Text(
              '${c['name'] ?? (c['resolved'] as Map?)?['name'] ?? ''}',
              style: AppType.body,
            ),
          const SizedBox(height: AppSpace.s2),
          FilledButton(
            onPressed: () async {
              if (await restoreWithConfirm(context, ref, s.id, d) &&
                  context.mounted) {
                context.pop();
              }
            },
            child: const Text('Restore this version'),
          ),
        ],
      ),
    );
  }
}
