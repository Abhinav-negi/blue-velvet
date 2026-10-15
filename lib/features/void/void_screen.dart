import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'void_providers.dart';

/// The Infinite Void: a two-column masonry of cards, newest first.
class VoidScreen extends ConsumerWidget {
  const VoidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(voidItemsProvider).value ?? const <VoidItem>[];
    if (items.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'Nothing here yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    // Masonry: each card (in newest-first order) goes to the shorter column,
    // judged by text length. ponytail: length is a height proxy, not measured.
    final cols = [<VoidItem>[], <VoidItem>[]];
    final heights = [0, 0];
    for (final it in items) {
      final c = heights[0] <= heights[1] ? 0 : 1;
      cols[c].add(it);
      heights[c] += it.summary.length + 40;
    }
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 2; i++) ...[
              if (i == 1) const SizedBox(width: AppSpace.s1),
              Expanded(
                child: Column(
                  children: [for (final it in cols[i]) VoidCard(it)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class VoidCard extends StatelessWidget {
  const VoidCard(this.item, {super.key});
  final VoidItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s1),
      child: Material(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () =>
              context.goNamed('void-item', pathParameters: {'id': item.id}),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item.type.icon,
                  size: AppSize.iconInline,
                  color: scheme.onSurfaceVariant,
                  semanticLabel: item.type.label,
                ),
                const SizedBox(height: AppSpace.s1),
                Text(
                  item.summary,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.story.copyWith(color: scheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
