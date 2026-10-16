import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

const _recentLimit = 5;

final _projectProvider = StreamProvider.family<Project?, String>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(
    db.projects,
  )..where((p) => p.id.equals(id))).watchSingleOrNull();
});

final _pendingProvider = StreamProvider.family<int, String>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.proposals)..where(
        (p) =>
            p.projectId.equals(id) &
            p.status.equalsValue(ProposalStatus.pending),
      ))
      .watch()
      .map((r) => r.length);
});

final _recentSnapshotsProvider = StreamProvider.family<List<Snapshot>, String>((
  ref,
  id,
) {
  final db = ref.watch(dbProvider);
  return (db.select(db.snapshots)
        ..where((s) => s.projectId.equals(id))
        ..orderBy([(s) => OrderingTerm.desc(s.createdAt)])
        ..limit(_recentLimit))
      .watch();
});

List<String> _strings(Object? v) =>
    v is List ? [for (final e in v) '$e'] : const [];

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['projectId']!;
    final project = ref.watch(_projectProvider(id)).value;
    if (project == null) return const SizedBox.shrink();
    final pending = ref.watch(_pendingProvider(id)).value ?? 0;
    final recent = ref.watch(_recentSnapshotsProvider(id)).value ?? const [];
    final text = Theme.of(context).textTheme;
    final f = project.typeFields;

    Widget heading(String s) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.s3, bottom: AppSpace.s1),
      child: Text(s, style: text.titleMedium),
    );
    Widget list(String title, List<String> items) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [heading(title), for (final i in items) Text(i)],
    );

    return ListView(
      padding: const EdgeInsets.all(AppSize.sideMargin),
      children: [
        Text('Overview', style: text.headlineSmall),
        for (final (key, label, icon) in const [
          ('export', 'Export', LucideIcons.share),
          ('history', 'History', LucideIcons.history),
        ])
          ListTile(
            key: Key('overview-$key'),
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            title: Text(label),
            onTap: () =>
                context.pushNamed(key, pathParameters: {'projectId': id}),
          ),
        heading('Summary'),
        Text(project.summary.isEmpty ? 'No summary yet.' : project.summary),
        heading('Pending proposals'),
        ListTile(
          key: const Key('overview-pending'),
          contentPadding: EdgeInsets.zero,
          title: Text('$pending pending'),
          onTap: () => context.pushNamed('proposals'),
        ),
        heading('Recent history'),
        if (recent.isEmpty) const Text('No history yet.'),
        for (final s in recent) Text(s.label),
        if (project.type == ProjectType.youtube) ...[
          list('Title ideas', _strings(f['title_ideas'])),
          list('Thumbnail ideas', _strings(f['thumbnail_ideas'])),
        ],
        if (project.type == ProjectType.short) ...[
          list('Hook text', [
            if ('${f['hook_text'] ?? ''}' != '') '${f['hook_text']}',
          ]),
          list('Caption', [
            if ('${f['caption'] ?? ''}' != '') '${f['caption']}',
          ]),
          list('On-screen text', [
            if ('${f['on_screen_text'] ?? ''}' != '') '${f['on_screen_text']}',
          ]),
        ],
      ],
    );
  }
}
