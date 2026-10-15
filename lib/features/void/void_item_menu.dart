import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/ai/organize.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:lynch/core/widgets/diff_view.dart';

import 'void_actions.dart';
import 'void_providers.dart';

enum _Act { edit, ai, type, merge }

/// App-bar menu on the item screen: edit by hand, ask the AI, change type,
/// merge. AI results only ever reach the DB through [_approve].
class VoidItemMenu extends ConsumerWidget {
  const VoidItemMenu(this.item, {super.key});
  final VoidItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(voidItemsProvider); // keep loaded for the merge picker
    return PopupMenuButton<_Act>(
      icon: const Icon(LucideIcons.ellipsis),
      onSelected: (a) => switch (a) {
        _Act.edit => _edit(context, ref),
        _Act.ai => _ask(context, ref),
        _Act.type => _changeType(context, ref),
        _Act.merge => _merge(context, ref),
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _Act.edit, child: Text('Edit')),
        PopupMenuItem(value: _Act.ai, child: Text('Edit with AI')),
        PopupMenuItem(value: _Act.type, child: Text('Change type')),
        PopupMenuItem(value: _Act.merge, child: Text('Merge with...')),
      ],
    );
  }

  void _done(WidgetRef ref) => ref.invalidate(voidItemProvider(item.id));

  Future<String?> _prompt(
    BuildContext context,
    String title,
    String initial, {
    String? hint,
  }) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(onPressed: ctx.pop, child: const Text('Cancel')),
          TextButton(onPressed: () => ctx.pop(c.text), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final s = await _prompt(context, 'Edit summary', item.summary);
    if (s == null || s.trim().isEmpty) return;
    await saveManual(
      ref.read(dbProvider),
      item,
      summary: s.trim(),
      tags: item.tags,
    );
    _done(ref);
  }

  Future<void> _ask(BuildContext context, WidgetRef ref) async {
    final s = await _prompt(
      context,
      'Edit with AI',
      '',
      hint: 'e.g. remove the second part',
    );
    if (s == null || s.trim().isEmpty || !context.mounted) return;
    await _propose(context, ref, s.trim());
  }

  Future<void> _changeType(BuildContext context, WidgetRef ref) async {
    final t = await showDialog<VoidType>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Change type'),
        children: [
          for (final t in VoidType.values)
            if (t != item.type)
              SimpleDialogOption(
                onPressed: () => ctx.pop(t),
                child: Text(t.label),
              ),
        ],
      ),
    );
    if (t == null || !context.mounted) return;
    await _propose(
      context,
      ref,
      changeTypeInstruction(t.label),
      forceType: itemTypes[t.index],
    );
  }

  Future<void> _propose(
    BuildContext context,
    WidgetRef ref,
    String instruction, {
    String? forceType,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    ItemEdit e;
    try {
      e = await proposeItemEdit(
        ref.read(voidAiProvider),
        item,
        instruction,
        forceType: forceType,
      );
    } on Exception {
      messenger.showSnackBar(
        const SnackBar(content: Text('The AI could not do that. Try again.')),
      );
      return;
    }
    if (!context.mounted) return;
    final d = e.item;
    if (d == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.note ?? 'Not possible.')),
      );
      return;
    }
    final lines = itemDiff(item, d);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Proposed edit'),
        content: SingleChildScrollView(
          child: lines.isEmpty
              ? const Text('No changes.')
              : DiffView(lines: lines),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Reject'),
          ),
          if (lines.isNotEmpty)
            TextButton(
              onPressed: () => ctx.pop(true),
              child: const Text('Approve'),
            ),
        ],
      ),
    );
    if (ok != true) return;
    await _approve(ref, d);
  }

  Future<void> _approve(WidgetRef ref, ItemDraft d) async {
    await applyDraft(ref.read(dbProvider), item, d);
    _done(ref);
  }

  Future<void> _merge(BuildContext context, WidgetRef ref) async {
    final others = (ref.read(voidItemsProvider).value ?? const <VoidItem>[])
        .where((i) => i.id != item.id)
        .toList();
    final picked = <String>{};
    final chosen = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Merge with'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final o in others)
                  CheckboxListTile(
                    value: picked.contains(o.id),
                    onChanged: (v) => set(
                      () => v == true ? picked.add(o.id) : picked.remove(o.id),
                    ),
                    title: Text(
                      o.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.body,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: ctx.pop, child: const Text('Cancel')),
            TextButton(
              onPressed: () => ctx.pop(picked),
              child: const Text('Merge'),
            ),
          ],
        ),
      ),
    );
    if (chosen == null || chosen.isEmpty) return;
    await mergeItems(ref.read(dbProvider), item, [
      for (final o in others)
        if (chosen.contains(o.id)) o,
    ]);
    _done(ref);
  }
}
