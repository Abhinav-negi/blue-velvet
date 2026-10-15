import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:lynch/core/widgets/diff_view.dart';
import 'package:lynch/core/widgets/suggested_text.dart';
import 'package:lynch/core/widgets/transcript_highlight.dart';

import 'proposals_providers.dart';

/// Review one proposal (design.md 8.2): diff per change, accept each, then
/// Approve, Reject (discard or to Void), or Defer.
class ProposalScreen extends ConsumerStatefulWidget {
  const ProposalScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends ConsumerState<ProposalScreen> {
  List<bool>? _accepted; // per change; starts from the stored flags
  bool _showSaid = false;
  bool _busy = false;

  Future<void> _approve(List<bool> accepted) async {
    setState(() => _busy = true);
    try {
      final notes = await ref
          .read(proposalActionsProvider)
          .approve(widget.id, accepted);
      await HapticFeedback.mediumImpact();
      if (!mounted) return;
      final m = ScaffoldMessenger.of(context);
      for (final n in notes) {
        m.showSnackBar(SnackBar(content: Text(n)));
      }
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not approve: $e')));
    }
  }

  Future<void> _reject() async {
    final choice = await showModalBottomSheet<bool>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Discard'),
              onTap: () => Navigator.pop(c, false),
            ),
            ListTile(
              title: const Text('Send to the Void'),
              onTap: () => Navigator.pop(c, true),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    await ref.read(proposalActionsProvider).reject(widget.id, toVoid: choice);
    if (mounted) context.pop();
  }

  Future<void> _edit(String current) async {
    final ctl = TextEditingController(text: current);
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit text'),
        content: TextField(controller: ctl, maxLines: null, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, ctl.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctl.dispose();
    if (text != null) {
      await ref.read(proposalActionsProvider).editSummary(widget.id, text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(proposalProvider(widget.id)).value;
    final lines = ref.watch(changeLinesProvider(widget.id)).value;
    if (p == null || lines == null) return const Scaffold();
    final accepted = _accepted ??= [
      for (final c in p.changes.cast<Map>()) c['accepted'] != false,
    ];
    final n = accepted.where((a) => a).length;
    final all = n == accepted.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        actions: [
          IconButton(
            tooltip: 'Edit text',
            icon: const Icon(LucideIcons.pencil),
            onPressed: () => _edit(p.summary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Text(touchHeader(p.changes), style: AppType.label),
          const SizedBox(height: AppSpace.s1),
          SuggestedText(p.summary),
          TextButton(
            onPressed: () => setState(() => _showSaid = !_showSaid),
            child: Text(_showSaid ? 'Hide what I said' : 'Show what I said'),
          ),
          if (_showSaid)
            TranscriptHighlight(
              transcript: p.rawTranscript,
              spans: [
                for (final s in p.summarySpans.cast<Map>())
                  HighlightRange(s['start'] as int, s['end'] as int),
              ],
            ),
          const SizedBox(height: AppSpace.s2),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Accept change ${i + 1}',
                    child: Checkbox(
                      key: ValueKey('accept-$i'),
                      value: accepted[i],
                      onChanged: (v) => setState(() => accepted[i] = v!),
                    ),
                  ),
                  Expanded(child: DiffView(lines: lines[i])),
                ],
              ),
            ),
          const SizedBox(height: AppSpace.s2),
          FilledButton(
            onPressed: _busy ? null : () => _approve(accepted),
            child: Text(
              all ? 'Approve all' : 'Approve $n of ${accepted.length}',
            ),
          ),
          const SizedBox(height: AppSpace.s1),
          OutlinedButton(
            onPressed: _busy ? null : _reject,
            child: const Text('Reject'),
          ),
          TextButton(
            onPressed: _busy ? null : () => context.pop(),
            child: const Text('Defer'),
          ),
        ],
      ),
    );
  }
}
