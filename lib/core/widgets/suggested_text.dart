import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';

/// AI-suggested text before approval (design.md 6.1): Literata italic with a
/// thin amber left rule. After approval it becomes plain story text.
class SuggestedText extends StatelessWidget {
  const SuggestedText(this.text, {super.key, this.onPaper = false});
  final String text;

  /// Use paper ink (for paper surfaces, which stay light in the dark theme).
  final bool onPaper;

  @override
  Widget build(BuildContext context) {
    final rule = Theme.of(context).extension<DiffColors>()!.proposalRule;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: rule, width: AppSpace.s05),
        ),
      ),
      padding: const EdgeInsets.only(left: AppSpace.s1),
      child: Text(
        text,
        style: AppType.proposal.copyWith(
          color: onPaper
              ? Theme.of(context).extension<PaperColors>()!.ink
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
