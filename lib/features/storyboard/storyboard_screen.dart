import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:path/path.dart' as p;

import 'frame_editor.dart';
import 'frames_providers.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  String? _beatId;

  @override
  Widget build(BuildContext context) {
    final beats = ref.watch(boardBeatsProvider(widget.projectId)).value ?? [];
    final beat =
        beats.where((b) => b.id == _beatId).firstOrNull ?? beats.firstOrNull;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSize.sideMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Board', style: text.titleLarge),
          if (beat == null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s2),
              child: Text(
                'Add a beat to start storyboarding.',
                style: text.bodySmall,
              ),
            )
          else ...[
            const SizedBox(height: AppSpace.s1),
            SizedBox(
              height: AppSize.chip,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final b in beats)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpace.s1),
                      child: ChoiceChip(
                        label: Text(b.title),
                        selected: b.id == beat.id,
                        onSelected: (_) => setState(() => _beatId = b.id),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: FramesList(beat: beat)),
          ],
        ],
      ),
    );
  }
}

/// Ordered frames of one beat with add / reorder / duplicate / delete / edit.
class FramesList extends ConsumerWidget {
  const FramesList({super.key, required this.beat});
  final Beat beat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final frames = ref.watch(framesProvider(beat.id)).value ?? const <Frame>[];
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            itemCount: frames.length,
            onReorderItem: (from, to) => moveFrame(db, beat.id, from, to),
            itemBuilder: (context, i) {
              final f = frames[i];
              final caption = frameCaption(f);
              return ListTile(
                key: ValueKey(f.id),
                leading: _Thumb(frame: f, index: i),
                title: Text(caption.isEmpty ? 'No shot details' : caption),
                subtitle: f.notes.isEmpty
                    ? null
                    : Text(
                        f.notes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                onTap: () => showFrameEditor(context, f, beat),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Duplicate frame',
                      icon: const Icon(LucideIcons.copy),
                      onPressed: () async => duplicateFrame(
                        db,
                        await ref.read(filesDirProvider.future),
                        f,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete frame',
                      icon: const Icon(LucideIcons.trash2),
                      onPressed: () => deleteFrame(db, f),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (frames.isEmpty) Text('No frames yet.', style: text.bodySmall),
        TextButton.icon(
          onPressed: () => addFrame(db, beat.id),
          icon: const Icon(LucideIcons.plus),
          label: const Text('Add frame'),
        ),
      ],
    );
  }
}

/// Cached thumbnail if present, else a numbered blank (canvas arrives with SB-02+).
class _Thumb extends ConsumerWidget {
  const _Thumb({required this.frame, required this.index});
  final Frame frame;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dir = ref.watch(filesDirProvider).value;
    final rel = frame.thumbnailPath;
    final file = dir == null || rel == null
        ? null
        : File(p.join(dir.path, rel));
    return Container(
      width: AppSize.button,
      height: AppSize.button,
      alignment: Alignment.center,
      color: AppColors.paperSurface,
      child: file != null && file.existsSync()
          ? Image.file(file, fit: BoxFit.cover)
          : Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: AppColors.paperInkSecondary),
            ),
    );
  }
}
