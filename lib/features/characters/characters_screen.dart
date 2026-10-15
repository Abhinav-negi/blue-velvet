import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'characters_providers.dart';

/// A project's Characters tab.
class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members =
        ref.watch(projectMembersProvider(projectId)).value ?? const [];
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Text('Characters', style: AppType.title),
          ListTile(
            leading: const Icon(LucideIcons.users),
            title: const Text('Character pool'),
            onTap: () => context.pushNamed(
              'character-pool',
              pathParameters: {'projectId': projectId},
            ),
          ),
          for (final m in members)
            ListTile(
              leading: const Icon(LucideIcons.user),
              title: Text(m.name),
              subtitle: Text(m.forked ? 'Forked. ${m.role}' : m.role),
              onTap: () => context.pushNamed(
                'character-sheet',
                pathParameters: {
                  'projectId': projectId,
                  'memberId': m.memberId,
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          'character-new',
          pathParameters: {'projectId': projectId},
        ),
        icon: const Icon(LucideIcons.plus),
        label: const Text('New character'),
      ),
    );
  }
}
