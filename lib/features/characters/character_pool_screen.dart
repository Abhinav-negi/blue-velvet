import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'characters_providers.dart';

/// The global character pool: every character from every project.
class CharacterPoolScreen extends ConsumerWidget {
  const CharacterPoolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pool = ref.watch(poolProvider).value ?? const <Character>[];
    final pid = GoRouterState.of(context).pathParameters['projectId']!;
    return Scaffold(
      appBar: AppBar(title: const Text('Character pool')),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          for (final c in pool)
            ListTile(
              leading: const Icon(LucideIcons.user),
              title: Text(c.name),
              subtitle: Text(c.role),
              trailing: IconButton(
                key: Key('import-${c.id}'),
                tooltip: 'Import (linked)',
                icon: const Icon(LucideIcons.download),
                onPressed: () async {
                  await importCharacter(ref.read(dbProvider), pid, c.id);
                  if (context.mounted) context.pop();
                },
              ),
              onTap: () => context.pushNamed(
                'pool-character',
                pathParameters: {'projectId': pid, 'id': c.id},
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          'pool-character-new',
          pathParameters: {'projectId': pid},
        ),
        icon: const Icon(LucideIcons.plus),
        label: const Text('New character'),
      ),
    );
  }
}
