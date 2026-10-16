import 'package:drift/drift.dart' show countAll;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/ai_defaults.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

import 'sample_project.dart';

final _projectsProvider = StreamProvider<List<Project>>(
  (ref) => ref.watch(dbProvider).projectsDao.watchAll(),
);

/// Pending proposals across all projects.
final _pendingCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(dbProvider);
  final count = countAll(
    filter: db.proposals.status.equalsValue(ProposalStatus.pending),
  );
  return (db.selectOnly(
    db.proposals,
  )..addColumns([count])).map((r) => r.read(count) ?? 0).watchSingle();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sampleInitProvider);
    final projects = ref.watch(_projectsProvider).value ?? const <Project>[];
    final pending = ref.watch(_pendingCountProvider).value ?? 0;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            tooltip: 'Shot library',
            onPressed: () => context.pushNamed('shots'),
            icon: const Icon(LucideIcons.camera),
          ),
          IconButton(
            tooltip: 'Proposals',
            onPressed: () => context.pushNamed('proposals'),
            icon: const Icon(LucideIcons.inbox),
          ),
          if (pending > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpace.s2),
              child: Container(
                key: const Key('pending-badge'),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s1,
                  vertical: AppSpace.s05,
                ),
                decoration: BoxDecoration(
                  color: AppColors.emberFill,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$pending',
                  style: text.labelSmall!.copyWith(color: AppColors.darkText),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          ListTile(
            leading: const Icon(LucideIcons.orbit),
            title: const Text('Infinite Void'),
            onTap: () => context.goNamed('void'),
          ),
          for (final p in projects)
            ListTile(
              leading: const Icon(LucideIcons.film),
              title: Text(p.title),
              subtitle: p.isSample ? const Text('Sample project') : null,
              onLongPress: p.isSample
                  ? () => _deleteSample(context, ref, p)
                  : null,
              onTap: () => context.goNamed(
                'overview',
                pathParameters: {'projectId': p.id},
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(LucideIcons.plus),
        label: const Text('New project'),
      ),
    );
  }

  Future<void> _deleteSample(
    BuildContext context,
    WidgetRef ref,
    Project p,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete sample project?'),
        content: const Text(
          'Only the sample is removed. It will not come back.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await deleteSampleProject(ref.read(dbProvider), p.id);
  }

  /// Characters-first start: an empty project with a working title only.
  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const _TitleDialog(),
    );
    if (title == null || title.trim().isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();
    final db = ref.read(dbProvider);
    final perms = await newProjectAiPermissions(db);
    await db.projectsDao.upsert(
      ProjectsCompanion.insert(
        id: id,
        title: title.trim(),
        type: ProjectType.shortFilm,
        summary: '',
        aspectRatio: '16:9',
        typeFields: const {},
        aiPermissions: perms,
        createdAt: now,
        updatedAt: now,
      ),
    );
    if (context.mounted) {
      context.goNamed('overview', pathParameters: {'projectId': id});
    }
  }
}

class _TitleDialog extends StatefulWidget {
  const _TitleDialog();

  @override
  State<_TitleDialog> createState() => _TitleDialogState();
}

class _TitleDialogState extends State<_TitleDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('New project'),
    content: TextField(
      controller: _c,
      autofocus: true,
      decoration: const InputDecoration(labelText: 'Working title'),
      onSubmitted: (v) => Navigator.pop(context, v),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, _c.text),
        child: const Text('Create'),
      ),
    ],
  );
}
