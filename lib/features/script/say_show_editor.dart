import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

const _showKeys = ['a_roll', 'b_roll', 'on_screen_text', 'graphics'];
const _showLabels = ['A-roll', 'B-roll', 'On-screen text', 'Graphics'];

class _Row {
  _Row(Map<String, dynamic> j)
    : id = j['id'] as String,
      ai = (j['scaffold'] == true) || (j['ai_suggested'] == true),
      say = TextEditingController(text: j['say'] as String? ?? ''),
      show = [
        for (final k in _showKeys)
          TextEditingController(text: (j['show'] as Map?)?[k] as String? ?? ''),
      ];
  final String id;
  bool ai;
  final TextEditingController say;
  final List<TextEditingController> show;

  Map<String, dynamic> toJson() => {
    'id': id,
    'say': say.text,
    'show': {
      for (var i = 0; i < _showKeys.length; i++) _showKeys[i]: show[i].text,
    },
    'scaffold': false,
    'ai_suggested': false,
  };

  void dispose() {
    say.dispose();
    for (final c in show) {
      c.dispose();
    }
  }
}

/// Say/Show rows of one beat. Every edit is written to `beats.say_show` at
/// once; the widget only reads the beat when it is created, so key it by
/// beat id.
class SayShowEditor extends ConsumerStatefulWidget {
  const SayShowEditor({super.key, required this.beat});
  final Beat beat;

  @override
  ConsumerState<SayShowEditor> createState() => _SayShowEditorState();
}

class _SayShowEditorState extends ConsumerState<SayShowEditor> {
  static const _uuid = Uuid();
  late final AppDatabase _db = ref.read(dbProvider);
  late final List<_Row> _rows = [
    for (final j in widget.beat.sayShow ?? const []) _Row(j),
  ];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _save() =>
      (_db.update(_db.beats)..where((b) => b.id.equals(widget.beat.id))).write(
        BeatsCompanion(
          sayShow: Value([for (final r in _rows) r.toJson()]),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  void _add() {
    setState(
      () => _rows.add(
        _Row({'id': _uuid.v4(), 'say': '', 'show': const <String, String>{}}),
      ),
    );
    _save();
  }

  void _remove(_Row r) {
    setState(() => _rows.remove(r));
    _save();
    // Dispose after the frame that stops using the controllers.
    WidgetsBinding.instance.addPostFrameCallback((_) => r.dispose());
  }

  void _changed(_Row r) {
    if (r.ai) setState(() => r.ai = false);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpace.s2),
      children: [
        for (final r in _rows) _row(r, theme),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: const ValueKey('add-row'),
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: const Text('Add row'),
          ),
        ),
      ],
    );
  }

  Widget _row(_Row r, ThemeData theme) {
    final style = r.ai ? AppType.proposal : AppType.body;
    InputDecoration deco(String label) => InputDecoration(
      labelText: label,
      isDense: true,
      border: const OutlineInputBorder(),
    );
    return Card(
      key: ValueKey('row-${r.id}'),
      margin: const EdgeInsets.only(bottom: AppSpace.s2),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.s1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: ValueKey('say-${r.id}'),
                controller: r.say,
                style: style,
                maxLines: null,
                minLines: 4,
                decoration: deco('Say'),
                onChanged: (_) => _changed(r),
              ),
            ),
            const SizedBox(width: AppSpace.s1),
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < _showKeys.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.s1),
                      child: TextField(
                        key: ValueKey('${_showKeys[i]}-${r.id}'),
                        controller: r.show[i],
                        style: style,
                        maxLines: null,
                        decoration: deco(_showLabels[i]),
                        onChanged: (_) => _changed(r),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              key: ValueKey('del-${r.id}'),
              tooltip: 'Delete row',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _remove(r),
            ),
          ],
        ),
      ),
    );
  }
}
