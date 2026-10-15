import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';

/// Half-open range of UTF-16 offsets into [TranscriptHighlight.transcript]
/// (docs/AI_CONTRACT.md 2: `start` inclusive, `end` exclusive).
@immutable
class HighlightRange {
  const HighlightRange(this.start, this.end);
  final int start, end;
}

/// Shows the raw transcript with the given spans lit (S4 "Where did this come
/// from?"). Overlapping spans merge; out-of-range or empty spans are ignored.
/// Lit text gets a teal fill (teal = where you are), not amber.
class TranscriptHighlight extends StatelessWidget {
  const TranscriptHighlight({
    super.key,
    required this.transcript,
    required this.spans,
    this.onPaper = false,
  });
  final String transcript;
  final List<HighlightRange> spans;

  /// Use paper ink (for paper surfaces, which stay light in the dark theme).
  final bool onPaper;

  /// Sorted, merged, clamped ranges.
  static List<HighlightRange> merge(int length, List<HighlightRange> spans) {
    final s = [
      for (final r in spans)
        if (r.start >= 0 && r.end > r.start && r.start < length)
          HighlightRange(r.start, r.end > length ? length : r.end),
    ]..sort((a, b) => a.start.compareTo(b.start));
    final out = <HighlightRange>[];
    for (final r in s) {
      if (out.isNotEmpty && r.start <= out.last.end) {
        if (r.end > out.last.end) {
          out[out.length - 1] = HighlightRange(out.last.start, r.end);
        }
      } else {
        out.add(r);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = AppType.story.copyWith(
      color: onPaper
          ? Theme.of(context).extension<PaperColors>()!.ink
          : scheme.onSurface,
    );
    final lit = base.copyWith(
      backgroundColor: scheme.secondary.withValues(alpha: 0.3),
    );
    final kids = <TextSpan>[];
    var at = 0;
    for (final r in merge(transcript.length, spans)) {
      if (r.start > at) {
        kids.add(TextSpan(text: transcript.substring(at, r.start)));
      }
      kids.add(
        TextSpan(text: transcript.substring(r.start, r.end), style: lit),
      );
      at = r.end;
    }
    if (at < transcript.length) {
      kids.add(TextSpan(text: transcript.substring(at)));
    }
    return Text.rich(TextSpan(style: base, children: kids));
  }
}
