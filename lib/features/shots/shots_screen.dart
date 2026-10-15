import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'shot_options.dart';
import 'shot_providers.dart';

/// Shot library: search, category chips, list of entries.
class ShotsScreen extends ConsumerWidget {
  const ShotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shots = ref.watch(filteredShotsProvider);
    final cat = ref.watch(shotCategoryFilter);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shot library'),
        actions: [
          IconButton(
            tooltip: 'Ask for shot options',
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ShotOptionsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSize.sideMargin),
            child: TextField(
              onChanged: (v) => ref.read(shotQuery.notifier).state = v,
              decoration: const InputDecoration(
                hintText: 'Search shots',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: AppSize.minTouch,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.sideMargin,
              ),
              children: [
                for (final c in <ShotCategory?>[null, ...ShotCategory.values])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.s1),
                    child: ChoiceChip(
                      label: Text(c?.label ?? 'All'),
                      selected: cat == c,
                      onSelected: (_) =>
                          ref.read(shotCategoryFilter.notifier).state = c,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: shots.isEmpty
                ? Center(
                    child: Text(
                      'No shots match.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSize.sideMargin),
                    children: [
                      for (final s in shots)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpace.s1),
                          child: Material(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                              ),
                              title: Text(s.name, style: AppType.heading),
                              subtitle: Text(
                                s.category.label,
                                style: AppType.caption.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              onTap: () => context.pushNamed(
                                'shot',
                                pathParameters: {'id': s.id},
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
