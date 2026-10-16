import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'beat_ops.dart';
import 'beats_providers.dart';
import 'template_providers.dart';
import 'template_switch.dart';

/// The beat board: beats grouped by template slot, or a plain ordered list.
/// Empty slots stay empty, with no warning.
class BeatsScreen extends ConsumerWidget {
  const BeatsScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tplId = ref.watch(projectTemplateProvider(projectId)).value;
    final beats = ref.watch(projectBeatsProvider(projectId)).value ?? const [];
    final slots = tplId == null
        ? const <Slot>[]
        : ref.watch(slotsProvider(tplId)).value ?? const <Slot>[];
    final withFrames = ref.watch(beatsWithFramesProvider).value ?? const {};
    final slotIds = {for (final s in slots) s.id};

    final db = ref.read(dbProvider);
    // One slot's cards, each a drop target (insert before) plus an end zone.
    List<Widget> group(
      String? slotId,
      List<Beat> items,
      Color? band, {
      bool flat = false,
    }) => [
      for (var i = 0; i < items.length; i++)
        _Drop(
          onDrop: (id) =>
              moveBeat(db, id, slotId: slotId, index: i, flat: flat),
          child: _BeatCard(
            beat: items[i],
            band: band,
            hasFrames: withFrames.contains(items[i].id),
            onTap: () => _edit(context, ref, items[i]),
            onSplit: () => _split(context, db, items[i]),
            onMerge: i + 1 < items.length
                ? () => mergeBeats(db, [items[i].id, items[i + 1].id])
                : null,
          ),
        ),
      _Drop(
        onDrop: (id) =>
            moveBeat(db, id, slotId: slotId, index: items.length, flat: flat),
        child: const SizedBox(height: AppSpace.s1, width: double.infinity),
      ),
    ];

    final children = <Widget>[];
    if (tplId == null) {
      children.addAll(group(null, beats, null, flat: true));
    } else {
      final loose = [
        for (final b in beats)
          if (!slotIds.contains(b.slotId)) b,
      ];
      for (final s in slots) {
        children.add(
          _Drop(
            onDrop: (id) => moveBeat(db, id, slotId: s.id, index: 0),
            child: _SlotHeader(
              slot: s,
              onAdd: () => _edit(context, ref, null, s.id),
            ),
          ),
        );
        children.addAll(
          group(s.id, [
            for (final b in beats)
              if (b.slotId == s.id) b,
          ], AppColors.tealFill),
        );
      }
      if (loose.isNotEmpty) {
        children.add(const _SlotHeader(slot: null));
        children.addAll(group(null, loose, null));
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, null),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add beat'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Row(
            children: [
              Expanded(child: Text('Beats', style: AppType.title)),
              TextButton(
                onPressed: () => startSwitch(context, ref, projectId),
                child: const Text('Switch template'),
              ),
              TextButton.icon(
                onPressed: () => context.goNamed(
                  'templates',
                  pathParameters: {'projectId': projectId},
                ),
                icon: const Icon(LucideIcons.layoutTemplate),
                label: const Text('Templates'),
              ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }

  Future<void> _split(BuildContext context, AppDatabase db, Beat beat) async {
    final c = TextEditingController(text: beat.description);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Split beat'),
        content: TextField(
          controller: c,
          maxLines: 4,
          decoration: const InputDecoration(
            helperText: 'Put the cursor where the beat should split.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Split at cursor'),
          ),
        ],
      ),
    );
    final at = c.selection.baseOffset;
    if (ok == true && at > 0) await splitBeat(db, beat.id, at: at);
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Beat? beat, [
    String? slotId,
  ]) async {
    final title = TextEditingController(text: beat?.title);
    final desc = TextEditingController(text: beat?.description);
    final db = ref.read(dbProvider);
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSize.sideMargin,
          AppSpace.s2,
          AppSize.sideMargin,
          AppSpace.s2 + MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: title,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Beat title'),
            ),
            const SizedBox(height: AppSpace.s1),
            TextField(
              controller: desc,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: AppSpace.s2),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && title.text.trim().isNotEmpty) {
      await saveBeat(
        db,
        projectId: projectId,
        id: beat?.id,
        slotId: slotId,
        title: title.text,
        description: desc.text,
      );
    }
  }
}

/// Accepts a dragged beat id.
class _Drop extends StatelessWidget {
  const _Drop({required this.child, required this.onDrop});
  final Widget child;
  final void Function(String beatId) onDrop;

  @override
  Widget build(BuildContext context) => DragTarget<String>(
    onAcceptWithDetails: (d) => onDrop(d.data),
    builder: (_, _, _) => child,
  );
}

class _SlotHeader extends StatelessWidget {
  const _SlotHeader({required this.slot, this.onAdd});
  final Slot? slot;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s2, bottom: AppSpace.s1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              slot?.name ?? 'Unplaced',
              style: AppType.heading.copyWith(color: scheme.onSurface),
            ),
          ),
          if (onAdd != null)
            IconButton(
              tooltip: 'Add beat to ${slot!.name}',
              onPressed: onAdd,
              icon: const Icon(LucideIcons.plus),
            ),
        ],
      ),
    );
  }
}

/// Index card (design.md 8.3): paper surface, colour band on top.
class _BeatCard extends StatelessWidget {
  const _BeatCard({
    required this.beat,
    required this.hasFrames,
    required this.onTap,
    required this.onSplit,
    this.onMerge,
    this.band,
  });
  final Beat beat;
  final bool hasFrames;
  final VoidCallback onTap;
  final VoidCallback onSplit;
  final VoidCallback? onMerge;
  final Color? band;

  @override
  Widget build(BuildContext context) {
    final paper = Theme.of(context).extension<PaperColors>()!;
    final hasScript = (beat.blocks ?? const []).isNotEmpty;
    final card = Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s1),
      child: Material(
        color: paper.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (band != null)
                Container(height: AppSpace.s05, color: band!.withAlpha(150)),
              Padding(
                padding: const EdgeInsets.all(AppSpace.s2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            beat.title,
                            style: AppType.label.copyWith(color: paper.ink),
                          ),
                          if (beat.description.isNotEmpty) ...[
                            const SizedBox(height: AppSpace.s05),
                            Text(
                              beat.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.story.copyWith(
                                color: paper.inkSecondary,
                                fontSize: AppType.body.fontSize,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (hasScript)
                      Icon(
                        LucideIcons.fileText,
                        size: AppSize.iconInline,
                        color: paper.inkSecondary,
                      ),
                    if (hasFrames)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpace.s05),
                        child: Icon(
                          LucideIcons.image,
                          size: AppSize.iconInline,
                          color: paper.inkSecondary,
                        ),
                      ),
                    PopupMenuButton<VoidCallback>(
                      tooltip: 'Beat actions',
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        size: AppSize.iconInline,
                        color: paper.inkSecondary,
                      ),
                      onSelected: (f) => f(),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: onSplit,
                          child: const Text('Split'),
                        ),
                        if (onMerge != null)
                          PopupMenuItem(
                            value: onMerge,
                            child: const Text('Merge with next'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return LongPressDraggable<String>(
      data: beat.id,
      feedback: SizedBox(
        width: MediaQuery.sizeOf(context).width - 2 * AppSize.sideMargin,
        child: Opacity(opacity: 0.9, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }
}
