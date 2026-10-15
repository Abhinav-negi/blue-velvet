import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'beats_providers.dart';
import 'template_providers.dart';

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

    Widget card(Beat b, {Color? band}) => _BeatCard(
      beat: b,
      band: band,
      hasFrames: withFrames.contains(b.id),
      onTap: () => _edit(context, ref, b),
    );

    final children = <Widget>[];
    if (tplId == null) {
      children.addAll(beats.map(card));
    } else {
      final loose = [
        for (final b in beats)
          if (!slotIds.contains(b.slotId)) b,
      ];
      for (final s in slots) {
        children.add(
          _SlotHeader(slot: s, onAdd: () => _edit(context, ref, null, s.id)),
        );
        children.addAll([
          for (final b in beats)
            if (b.slotId == s.id) card(b, band: AppColors.tealFill),
        ]);
      }
      if (loose.isNotEmpty) {
        children.add(const _SlotHeader(slot: null));
        children.addAll(loose.map(card));
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.goNamed(
                'templates',
                pathParameters: {'projectId': projectId},
              ),
              icon: const Icon(LucideIcons.layoutTemplate),
              label: const Text('Templates'),
            ),
          ),
          ...children,
        ],
      ),
    );
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
    this.band,
  });
  final Beat beat;
  final bool hasFrames;
  final VoidCallback onTap;
  final Color? band;

  @override
  Widget build(BuildContext context) {
    final paper = Theme.of(context).extension<PaperColors>()!;
    final hasScript = (beat.blocks ?? const []).isNotEmpty;
    return Padding(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
