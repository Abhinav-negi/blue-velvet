import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:lynch/core/widgets/transcript_highlight.dart';

import 'void_item_menu.dart';
import 'void_providers.dart';

// AI_CONTRACT 2.1 sentence splitter.
final _sentenceEnd = RegExp(r'(?<=[.!?]["\x27)\]]?)\s+');
List<String> splitSentences(String s) =>
    s.trim().split(_sentenceEnd).where((x) => x.isNotEmpty).toList();

/// Item detail: type, summary (tap a sentence = S4), structure, raw transcript.
class VoidItemScreen extends ConsumerStatefulWidget {
  const VoidItemScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<VoidItemScreen> createState() => _VoidItemScreenState();
}

class _VoidItemScreenState extends ConsumerState<VoidItemScreen> {
  int? _sentence;

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(voidItemProvider(widget.id)).value;
    if (item == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final sentences = splitSentences(item.summary);
    final spans = [
      for (final s in item.summarySpans)
        if ((s as Map)['sentence_index'] == _sentence)
          HighlightRange(s['start'] as int, s['end'] as int),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(item.type.label),
        actions: [VoidItemMenu(item)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Row(
            children: [
              Icon(item.type.icon, size: AppSize.icon),
              const SizedBox(width: AppSpace.s1),
              Text(item.type.label, style: AppType.heading),
            ],
          ),
          const SizedBox(height: AppSpace.s2),
          for (var i = 0; i < sentences.length; i++)
            InkWell(
              onTap: () => setState(() => _sentence = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.s05),
                child: Text(
                  sentences[i],
                  style: AppType.story.copyWith(
                    color: _sentence == i ? scheme.secondary : scheme.onSurface,
                  ),
                ),
              ),
            ),
          if (item.structure.isNotEmpty) ...[
            const SizedBox(height: AppSpace.s3),
            Text('Structure', style: AppType.label),
            const SizedBox(height: AppSpace.s1),
            _Structure(item.structure),
          ],
          const SizedBox(height: AppSpace.s3),
          Text('Raw transcript', style: AppType.label),
          const SizedBox(height: AppSpace.s1),
          TranscriptHighlight(transcript: item.rawTranscript, spans: spans),
        ],
      ),
    );
  }
}

/// Type structure (DATA_MODEL 1.2): dialogue lines, lyric sections, else the
/// non-empty fields as "Label: value".
class _Structure extends StatelessWidget {
  const _Structure(this.data);
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[];
    data.forEach((k, v) {
      if (v is List && v.isNotEmpty && v.first is Map) {
        for (final e in v.cast<Map>()) {
          rows.add((
            '${e['speaker'] ?? e['kind'] ?? ''}'.replaceAll('_', ' '),
            '${e['text'] ?? ''}',
          ));
        }
      } else if (v is List) {
        if (v.isNotEmpty) rows.add((k, v.join(', ')));
      } else if (v != null && '$v'.isNotEmpty) {
        rows.add((k.replaceAll('_', ' '), '$v'));
      }
    });
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, text) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.s1),
            child: Text.rich(
              TextSpan(
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: AppType.body.copyWith(color: secondary),
                    ),
                  TextSpan(text: text, style: AppType.body),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
