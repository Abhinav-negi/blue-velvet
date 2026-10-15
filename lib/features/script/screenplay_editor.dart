import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

import 'screenplay_format.dart';

class _Row {
  _Row(this.id, this.type, String text, this.ai)
    : controller = TextEditingController(text: text),
      focus = FocusNode();
  final String id;
  String type;
  bool ai;
  final TextEditingController controller;
  final FocusNode focus;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'text': controller.text,
    'scaffold': false,
    'ai_suggested': false,
  };
}

/// Screenplay blocks of one beat on a paper page. Every edit is written to
/// `beats.blocks` at once; the widget only reads the beat when it is created,
/// so key it by beat id.
class ScreenplayEditor extends ConsumerStatefulWidget {
  const ScreenplayEditor({super.key, required this.beat});
  final Beat beat;

  @override
  ConsumerState<ScreenplayEditor> createState() => _ScreenplayEditorState();
}

class _ScreenplayEditorState extends ConsumerState<ScreenplayEditor> {
  static const _uuid = Uuid();
  late final AppDatabase _db = ref.read(dbProvider);
  late final List<_Row> _rows;

  @override
  void initState() {
    super.initState();
    _rows = [
      for (final b in widget.beat.blocks ?? const [])
        _Row(
          b['id'] as String,
          b['type'] as String,
          b['text'] as String,
          (b['scaffold'] == true) || (b['ai_suggested'] == true),
        ),
    ];
    if (_rows.isEmpty) _rows.add(_Row(_uuid.v4(), 'scene_heading', '', false));
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.controller.dispose();
      r.focus.dispose();
    }
    super.dispose();
  }

  Future<void> _save() =>
      (_db.update(_db.beats)..where((b) => b.id.equals(widget.beat.id))).write(
        BeatsCompanion(
          blocks: Value([for (final r in _rows) r.toJson()]),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  void _edit(VoidCallback change) {
    setState(change);
    _save();
  }

  void _enter(int i) {
    final row = _rows[i];
    row.ai = false;
    final next = _Row(_uuid.v4(), nextOnEnter(row.type), '', false);
    _edit(() => _rows.insert(i + 1, next));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => next.focus.requestFocus(),
    );
  }

  void _setType(_Row r, String type, ScreenplayFormat f) => _edit(() {
    r.type = type;
    if (f.elements[type]!.uppercase) {
      r.controller.text = r.controller.text.toUpperCase();
    }
  });

  void _removeIfEmpty(int i) {
    if (i == 0 || _rows[i].controller.text.isNotEmpty) return;
    final gone = _rows[i];
    _edit(() => _rows.removeAt(i));
    _rows[i - 1].focus.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gone.controller.dispose();
      gone.focus.dispose();
    });
  }

  Future<void> _pickType(_Row r, ScreenplayFormat f) async {
    final t = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final type in elementTypes)
              ListTile(
                title: Text(f.elements[type]!.name),
                selected: type == r.type,
                onTap: () => Navigator.pop(c, type),
              ),
          ],
        ),
      ),
    );
    if (t != null) _setType(r, t, f);
  }

  @override
  Widget build(BuildContext context) {
    final f = ref.watch(screenplayFormatProvider).value;
    if (f == null) return const SizedBox.shrink();
    final paper = Theme.of(context).extension<PaperColors>()!;
    final style = AppType.screenplay.copyWith(color: paper.ink);
    final lineH = style.fontSize! * style.height!;
    // Inches to pixels: the page scales down to fit, never up past the
    // size where the font gives its characters-per-inch.
    final natural = style.fontSize! * 0.6 * f.charsPerInch;
    return ColoredBox(
      color: paper.bg,
      child: LayoutBuilder(
        builder: (context, box) {
          final ppi = (box.maxWidth / f.pageWidthIn).clamp(0.0, natural);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s2),
            child: Center(
              child: Container(
                width: f.pageWidthIn * ppi,
                color: paper.surface,
                padding: const EdgeInsets.symmetric(vertical: AppSpace.s2),
                child: Column(
                  children: [
                    for (var i = 0; i < _rows.length; i++)
                      _block(i, f, ppi, style, lineH, paper),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _block(
    int i,
    ScreenplayFormat f,
    double ppi,
    TextStyle style,
    double lineH,
    PaperColors paper,
  ) {
    final r = _rows[i];
    final rules = f.elements[r.type]!;
    final field = Focus(
      onKeyEvent: (_, e) {
        if (e is! KeyDownEvent) return KeyEventResult.ignored;
        if (e.logicalKey == LogicalKeyboardKey.tab) {
          _setType(r, nextOnTab(r.type), f);
          return KeyEventResult.handled;
        }
        if (e.logicalKey == LogicalKeyboardKey.backspace) _removeIfEmpty(i);
        return KeyEventResult.ignored;
      },
      child: TextField(
        key: ValueKey('block-${r.id}'),
        controller: r.controller,
        focusNode: r.focus,
        style: r.ai ? AppType.proposal.copyWith(color: paper.ink) : style,
        textAlign: switch (rules.align) {
          'right' => TextAlign.right,
          'center' => TextAlign.center,
          _ => TextAlign.left,
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        cursorColor: paper.ink,
        decoration: const InputDecoration.collapsed(hintText: null),
        inputFormatters: [
          if (rules.uppercase)
            TextInputFormatter.withFunction(
              (o, n) => n.copyWith(text: n.text.toUpperCase()),
            ),
        ],
        onChanged: (v) {
          // Enter (hard or soft keyboard) arrives as a newline: swallow it
          // and start the next block instead.
          if (v.contains('\n')) {
            r.controller.text = v.replaceAll('\n', '');
            _enter(i);
            return;
          }
          if (r.ai) setState(() => r.ai = false);
          _save();
        },
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: i == 0 ? 0 : rules.blankBefore * lineH),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: f.marginLeftIn * ppi,
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                key: ValueKey('chip-${r.id}'),
                onTap: () => _pickType(r, f),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.s05),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      rules.name,
                      style: AppType.caption.copyWith(
                        color: paper.inkSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                // Right-aligned text (transitions) must not wrap: its left indent
                // is only a hint, so drop it.
                left: rules.align == 'right'
                    ? 0
                    : (rules.leftIn - f.marginLeftIn) * ppi,
                right: rules.rightIn * ppi,
              ),
              child: field,
            ),
          ),
        ],
      ),
    );
  }
}
