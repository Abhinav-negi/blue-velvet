import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'void_providers.dart';
import 'void_send.dart';

/// Sends [item] to a project the user picks. Shared by the item menu.
Future<void> sendWithFeedback(
  BuildContext context,
  WidgetRef ref,
  VoidItem item,
  String projectId,
) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await sendToProject(
      ref.read(dbProvider),
      ref.read(aiClientProvider),
      item: item,
      projectId: projectId,
    );
    ref.invalidate(voidItemProvider(item.id));
    messenger.showSnackBar(
      const SnackBar(content: Text('Sent as a proposal to review.')),
    );
  } on Exception {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not send. Try again.')),
    );
  }
}

/// Pull an item in from inside a project: pick a Void item, it becomes a
/// pending proposal for [projectId]. Route `void-pick`.
class VoidPickScreen extends ConsumerWidget {
  const VoidPickScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(voidItemsProvider).value ?? const <VoidItem>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Pull from Void')),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          for (final i in items)
            ListTile(
              leading: Icon(i.type.icon, size: AppSize.icon),
              title: Text(
                i.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppType.body,
              ),
              subtitle: Text(
                i.usedInProjectIds.contains(projectId)
                    ? '${i.type.label} - used here'
                    : i.type.label,
              ),
              onTap: () async {
                await sendWithFeedback(context, ref, i, projectId);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ),
    );
  }
}
