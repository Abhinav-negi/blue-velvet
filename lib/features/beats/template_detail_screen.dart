import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'template_edit_screen.dart';
import 'template_providers.dart';

/// One template with its ordered slots.
class TemplateDetailScreen extends ConsumerWidget {
  const TemplateDetailScreen({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref
        .watch(templatesProvider)
        .value
        ?.where((t) => t.id == id)
        .firstOrNull;
    final slots = ref.watch(slotsProvider(id)).value ?? const <Slot>[];
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    if (t == null) return Scaffold(appBar: AppBar());
    return Scaffold(
      appBar: AppBar(
        title: Text(t.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TemplateEditScreen(id: id),
              ),
            ),
          ),
          if (!t.builtin)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final nav = Navigator.of(context);
                await deleteTemplate(ref.read(dbProvider), id);
                nav.pop();
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          Text(t.description, style: text.bodyLarge),
          if (t.sourceUrl != null) ...[
            const SizedBox(height: AppSpace.s1),
            Text(
              t.sourceUrl!,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpace.s3),
          for (final (i, s) in slots.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}. ${s.name}', style: text.titleMedium),
                  if (s.runtimeProportion != null)
                    Text(
                      '${(s.runtimeProportion! * 100).round()}% of runtime',
                      style: text.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  Text(s.description, style: text.bodyMedium),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
