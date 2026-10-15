import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'frames_providers.dart';

/// Bottom sheet to edit a frame's shot details, notes, characters and block link.
Future<void> showFrameEditor(BuildContext context, Frame frame, Beat beat) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FrameEditor(frame: frame, beat: beat),
    );

class FrameEditor extends ConsumerStatefulWidget {
  const FrameEditor({super.key, required this.frame, required this.beat});
  final Frame frame;
  final Beat beat;

  @override
  ConsumerState<FrameEditor> createState() => _FrameEditorState();
}

class _FrameEditorState extends ConsumerState<FrameEditor> {
  late final _size = TextEditingController(text: widget.frame.shotSize);
  late final _angle = TextEditingController(text: widget.frame.angle);
  late final _move = TextEditingController(text: widget.frame.movement);
  late final _lens = TextEditingController(text: widget.frame.lensFeel);
  late final _dur = TextEditingController(
    text: widget.frame.durationMs == null
        ? ''
        : '${widget.frame.durationMs! / 1000}',
  );
  late final _notes = TextEditingController(text: widget.frame.notes);
  late String? _block = widget.frame.blockId;
  late final Set<String> _chars = {...widget.frame.characterIds};

  @override
  void dispose() {
    for (final c in [_size, _angle, _move, _lens, _dur, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  /// (id, label) of the beat's screenplay blocks / say-show rows.
  List<(String, String)> get _blocks => [
    for (final b in [...?widget.beat.blocks, ...?widget.beat.sayShow])
      if (b['id'] is String)
        (
          b['id'] as String,
          '${b['text'] ?? b['say'] ?? ''}'.trim().isEmpty
              ? '(empty)'
              : '${b['text'] ?? b['say']}',
        ),
  ];

  Future<void> _save() async {
    await saveFrameDetails(
      ref.read(dbProvider),
      widget.frame.id,
      shotSize: _size.text,
      angle: _angle.text,
      movement: _move.text,
      lensFeel: _lens.text,
      durationSecs: double.tryParse(_dur.text.trim()),
      notes: _notes.text,
      blockId: _block,
      characterIds: _chars.toList(),
    );
    if (mounted) Navigator.pop(context);
  }

  Widget _field(String label, TextEditingController c, {bool number = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.s1),
        child: TextField(
          controller: c,
          keyboardType: number ? TextInputType.number : null,
          decoration: InputDecoration(labelText: label),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final members =
        ref.watch(frameCharactersProvider(widget.beat.projectId)).value ??
        const <String, String>{};
    final blocks = _blocks;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpace.s2,
        right: AppSpace.s2,
        top: AppSpace.s2,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpace.s2,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('Shot size', _size),
            _field('Angle', _angle),
            _field('Movement', _move),
            _field('Lens', _lens),
            _field('Duration (seconds)', _dur, number: true),
            _field('Notes', _notes),
            if (blocks.isNotEmpty)
              DropdownButtonFormField<String?>(
                initialValue: blocks.any((b) => b.$1 == _block) ? _block : null,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Script block'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  for (final b in blocks)
                    DropdownMenuItem(
                      value: b.$1,
                      child: Text(b.$2, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (v) => setState(() => _block = v),
              ),
            if (members.isNotEmpty)
              Wrap(
                spacing: AppSpace.s1,
                children: [
                  for (final m in members.entries)
                    FilterChip(
                      label: Text(m.value),
                      selected: _chars.contains(m.key),
                      onSelected: (on) => setState(
                        () => on ? _chars.add(m.key) : _chars.remove(m.key),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: AppSpace.s2),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
