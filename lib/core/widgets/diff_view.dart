import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';

/// Fill opacity for the soft added/removed backgrounds (design.md 8.2).
const double _kFaint = 0.12;

/// One diff entry. [changed] shows [before] struck through above [after].
@immutable
class DiffLine {
  const DiffLine.added(String text) : before = null, after = text;
  const DiffLine.removed(String text) : before = text, after = null;
  const DiffLine.changed({
    required String this.before,
    required String this.after,
  });

  final String? before;
  final String? after;
}

/// Soft diff (design.md 8.2): added = sage rule + faint fill, removed =
/// strike-through, changed = removed above added. Each row also carries an
/// icon and a screen-reader word, so meaning never rests on colour alone.
/// Set [onPaper] on paper surfaces (removed uses red pencil instead of ember).
class DiffView extends StatelessWidget {
  const DiffView({super.key, required this.lines, this.onPaper = false});
  final List<DiffLine> lines;
  final bool onPaper;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<DiffColors>()!;
    final removedColor = onPaper ? c.removedOnPaper : c.removedOnFrame;
    final ink = onPaper
        ? Theme.of(context).extension<PaperColors>()!.ink
        : Theme.of(context).colorScheme.onSurface;
    final base = AppType.story.copyWith(color: ink);

    Widget row(String text, {required bool added}) {
      final color = added ? c.added : removedColor;
      return Semantics(
        label: added ? 'Added' : 'Removed',
        child: Container(
          decoration: BoxDecoration(
            color: added ? color.withValues(alpha: _kFaint) : null,
            border: added
                ? Border(
                    left: BorderSide(color: color, width: AppSpace.s05),
                  )
                : null,
          ),
          padding: const EdgeInsets.all(AppSpace.s1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpace.s05),
                child: ExcludeSemantics(
                  child: Icon(
                    added ? LucideIcons.plus : LucideIcons.minus,
                    size: AppSize.iconInline,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.s1),
              Expanded(
                child: Text(
                  text,
                  style: added
                      ? base
                      : base.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: color,
                          color: color,
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final l in lines) ...[
          if (l.before != null) row(l.before!, added: false),
          if (l.after != null) row(l.after!, added: true),
        ],
      ],
    );
  }
}
