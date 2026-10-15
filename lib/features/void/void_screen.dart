import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'void_providers.dart';

/// The Infinite Void: a two-column masonry of cards, newest first.
class VoidScreen extends ConsumerWidget {
  const VoidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(filteredVoidItemsProvider).value ?? const <VoidItem>[];
    final all = ref.watch(voidItemsProvider).value ?? const <VoidItem>[];
    final f = ref.watch(voidFilterProvider);
    final set = ref.read(voidFilterProvider.notifier);
    final tags = ({for (final i in all) ...i.tags}.toList()..sort());
    final empty = all.isEmpty
        ? 'Nothing here yet.'
        : (items.isEmpty ? 'No matches.' : null);
    Widget chip(String label, bool on, VoidFilter Function() toggle) => Padding(
      padding: const EdgeInsets.only(right: AppSpace.s1),
      child: FilterChip(
        label: Text(label),
        selected: on,
        onSelected: (_) => set.set(toggle()),
      ),
    );
    final bar = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.sideMargin,
            AppSpace.s1,
            AppSize.sideMargin,
            0,
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search summary and transcript',
              prefixIcon: Icon(LucideIcons.search),
            ),
            onChanged: (q) => set.set(f.copyWith(query: q)),
          ),
        ),
        SizedBox(
          height: AppSize.minTouch,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.sideMargin,
              vertical: AppSpace.s1,
            ),
            child: Row(
              children: [
                for (final t in VoidType.values)
                  chip(
                    t.label,
                    f.type == t,
                    () => f.copyWith(type: (v: f.type == t ? null : t)),
                  ),
                for (final d in VoidDate.values)
                  chip(
                    d.label,
                    f.date == d,
                    () => f.copyWith(date: (v: f.date == d ? null : d)),
                  ),
                chip(
                  'Used',
                  f.used == true,
                  () => f.copyWith(used: (v: f.used == true ? null : true)),
                ),
                chip(
                  'Unused',
                  f.used == false,
                  () => f.copyWith(used: (v: f.used == false ? null : false)),
                ),
                for (final t in tags)
                  chip(
                    '#$t',
                    f.tag == t,
                    () => f.copyWith(tag: (v: f.tag == t ? null : t)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
    if (empty != null) {
      return Scaffold(
        body: Column(
          children: [
            bar,
            Expanded(
              child: Center(
                child: Text(
                  empty,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
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
      body: Column(
        children: [
          bar,
          Expanded(
            child: SingleChildScrollView(
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
          ),
        ],
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
