import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/ai/ai_provider.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'idea_project.dart';

final _ideaProvider = FutureProvider.family<VoidItem?, String>(
  (ref, id) => ref.watch(dbProvider).voidItemsDao.byId(id),
);

/// Pre-project review (spec 7): edit the summary, pick type and template, then
/// generate the project.
class IdeaScreen extends ConsumerStatefulWidget {
  const IdeaScreen({super.key, required this.voidItemId});
  final String voidItemId;

  @override
  ConsumerState<IdeaScreen> createState() => _IdeaScreenState();
}

class _IdeaScreenState extends ConsumerState<IdeaScreen> {
  final _summary = TextEditingController();
  final _title = TextEditingController();
  bool _loaded = false;
  IdeaType? _type;
  String? _template;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _summary.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _create(VoidItem item) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await createProjectFromIdea(
        ref.read(dbProvider),
        ref.read(aiClientProvider),
        item: item,
        summary: _summary.text,
        title: _title.text,
        type: _type!,
        templateId: _template!,
      );
      if (mounted) {
        context.goNamed('overview', pathParameters: {'projectId': id});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Could not create the project: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(_ideaProvider(widget.voidItemId)).value;
    final types = ref.watch(ideaTypesProvider).value;
    final theme = Theme.of(context);
    if (item != null && !_loaded) {
      _loaded = true;
      _summary.text = item.summary;
    }
    final templates = _type == null
        ? null
        : ref.watch(ideaTemplatesProvider(_type!)).value;
    final ready =
        item != null &&
        _type != null &&
        _template != null &&
        _title.text.trim().isNotEmpty &&
        !_busy;
    return Scaffold(
      appBar: AppBar(title: const Text('Story idea')),
      body: item == null || types == null
          ? const SizedBox()
          : ListView(
              padding: const EdgeInsets.all(AppSize.sideMargin),
              children: [
                TextField(
                  controller: _summary,
                  minLines: 3,
                  maxLines: 8,
                  decoration: const InputDecoration(labelText: 'Summary'),
                ),
                const SizedBox(height: AppSpace.s2),
                TextField(
                  controller: _title,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'Working title'),
                ),
                const SizedBox(height: AppSpace.s3),
                Text('Project type', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpace.s1),
                Wrap(
                  spacing: AppSpace.s1,
                  children: [
                    for (final t in types)
                      ChoiceChip(
                        label: Text(t.name),
                        selected: _type?.id == t.id,
                        onSelected: (_) => setState(() {
                          _type = t;
                          _template = t.templateIds.first;
                        }),
                      ),
                  ],
                ),
                if (templates != null) ...[
                  const SizedBox(height: AppSpace.s3),
                  Text('Template', style: theme.textTheme.titleSmall),
                  RadioGroup<String>(
                    groupValue: _template,
                    onChanged: (v) => setState(() => _template = v),
                    child: Column(
                      children: [
                        for (final t in templates)
                          RadioListTile<String>(
                            value: t.id,
                            title: Text(t.name),
                            subtitle: Text(
                              t.id == _type!.templateIds.first
                                  ? 'Default. ${t.description}'
                                  : t.description,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.s2),
                    child: Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                const SizedBox(height: AppSpace.s3),
                FilledButton(
                  onPressed: ready ? () => _create(item) : null,
                  child: Text(_busy ? 'Creating...' : 'Approve and create'),
                ),
              ],
            ),
    );
  }
}
