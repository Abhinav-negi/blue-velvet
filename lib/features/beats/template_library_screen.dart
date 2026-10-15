import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'template_detail_screen.dart';
import 'template_edit_screen.dart';
import 'template_providers.dart';

/// Browse built-in and saved templates; "New template" starts a blank one.
class TemplateLibraryScreen extends ConsumerWidget {
  const TemplateLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(templatesProvider).value ?? const <Template>[];
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const TemplateEditScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New template'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          for (final t in list)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s1),
              child: Material(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TemplateDetailScreen(id: t.id),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpace.s2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpace.s05),
                        Text(
                          t.builtin
                              ? (t.userEdited ? 'Built-in, edited' : 'Built-in')
                              : 'Yours',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpace.s05),
                        Text(
                          t.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
