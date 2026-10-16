import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/key_store.dart';
import 'package:lynch/core/ai/permissions.dart';
import 'package:lynch/core/ai/remap.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'template_providers.dart';

/// The app's AI gateway for beats. Not wired in core yet; tests override it.
final beatsAiProvider = Provider<AiClient>(
  (ref) => AiClient(readStoredKey: readSecureGeminiKey),
);

Future<List<Beat>> _loadBeats(AppDatabase db, String projectId) =>
    (db.select(db.beats)
          ..where((b) => b.projectId.equals(projectId))
          ..orderBy([(b) => OrderingTerm.asc(b.position)]))
        .get();

/// Beat ids per new slot id (null key = unplaced), in board order.
typedef SwitchPlan = Map<String?, List<String>>;

/// Proposes a plan for moving [projectId]'s beats into [slots]. Auto-placement
/// off (or the AI failing) leaves every beat unplaced: nothing is lost.
Future<SwitchPlan> proposeSwitch(
  AppDatabase db,
  AiClient ai,
  String projectId,
  List<Slot> slots,
) async {
  final p = await (db.select(
    db.projects,
  )..where((t) => t.id.equals(projectId))).getSingle();
  final beats = await _loadBeats(db, projectId);
  final plan = <String?, List<String>>{
    for (final s in slots) s.id: <String>[],
    null: [for (final b in beats) b.id],
  };
  if (!aiAllowed(p.aiPermissions, AiPermission.autoPlacement) ||
      beats.isEmpty) {
    return plan;
  }
  final old = {for (final s in await db.select(db.slots).get()) s.id: s.name};
  try {
    final ps = await remapTemplate(
      ai,
      beats: [
        for (final b in beats)
          {
            'id': b.id,
            'title': b.title,
            'description': b.description,
            'current_slot_name': old[b.slotId],
          },
      ],
      newTemplate: {
        'slots': [
          for (final s in slots)
            {
              'slot_id': s.id,
              'seed_id': s.seedId,
              'name': s.name,
              'description': s.description,
              'runtime_proportion': s.runtimeProportion,
            },
        ],
      },
      permissions: p.aiPermissions,
    );
    final bySeed = {
      for (final s in slots)
        if (s.seedId != null) s.seedId!: s.id,
    };
    final ordered = [...ps]..sort((a, b) => a.position.compareTo(b.position));
    for (final l in plan.values) {
      l.clear();
    }
    for (final x in ordered) {
      plan[x.slotId ?? bySeed[x.slotSeedId]]!.add(x.beatId);
    }
  } on Object {
    // ponytail: any AI failure falls back to unplaced; surface why if needed.
  }
  return plan;
}

/// Writes the confirmed switch: sets the template and every beat's slot and
/// position in one transaction. Beats are only moved, never deleted.
Future<void> applySwitch(
  AppDatabase db,
  String projectId,
  String templateId,
  List<String> slotOrder,
  SwitchPlan plan,
) => db.transaction(() async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await (db.update(db.projects)..where((p) => p.id.equals(projectId))).write(
    ProjectsCompanion(templateId: Value(templateId), updatedAt: Value(now)),
  );
  var pos = 0;
  for (final slot in [...slotOrder, null]) {
    for (final id in plan[slot] ?? const <String>[]) {
      await (db.update(db.beats)..where((b) => b.id.equals(id))).write(
        BeatsCompanion(
          slotId: Value(slot),
          position: Value(pos++),
          updatedAt: Value(now),
        ),
      );
    }
  }
});

/// Remap preview: drag beats between the new slots, then confirm.
class TemplateSwitchScreen extends ConsumerStatefulWidget {
  const TemplateSwitchScreen({
    required this.projectId,
    required this.templateId,
    super.key,
  });
  final String projectId;
  final String templateId;

  @override
  ConsumerState<TemplateSwitchScreen> createState() => _SwitchState();
}

class _SwitchState extends ConsumerState<TemplateSwitchScreen> {
  SwitchPlan? _plan;
  List<Slot> _slots = const [];
  Map<String, Beat> _beats = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    final slots =
        await (db.select(db.slots)
              ..where((s) => s.templateId.equals(widget.templateId))
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
    final beats = await _loadBeats(db, widget.projectId);
    final plan = await proposeSwitch(
      db,
      ref.read(beatsAiProvider),
      widget.projectId,
      slots,
    );
    if (!mounted) return;
    setState(() {
      _slots = slots;
      _beats = {for (final b in beats) b.id: b};
      _plan = plan;
    });
  }

  void _move(String id, String? to) => setState(() {
    for (final l in _plan!.values) {
      l.remove(id);
    }
    _plan![to]!.add(id);
  });

  Future<void> _confirm() async {
    final nav = Navigator.of(context);
    await applySwitch(
      ref.read(dbProvider),
      widget.projectId,
      widget.templateId,
      [for (final s in _slots) s.id],
      _plan!,
    );
    nav.pop();
  }

  Widget _group(String? slotId, String name) => DragTarget<String>(
    onAcceptWithDetails: (d) => _move(d.data, slotId),
    builder: (_, _, _) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: double.infinity, height: AppSpace.s1),
          for (final id in _plan![slotId]!)
            Draggable<String>(
              data: id,
              feedback: Material(child: Text(_beats[id]!.title)),
              child: Card(
                child: ListTile(dense: true, title: Text(_beats[id]!.title)),
              ),
            ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch template'),
        actions: [
          TextButton(
            onPressed: plan == null ? null : _confirm,
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: plan == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSize.sideMargin),
              children: [
                for (final s in _slots) _group(s.id, s.name),
                _group(null, 'Unplaced'),
              ],
            ),
    );
  }
}

/// Lets the user pick a template, then opens the remap preview.
Future<void> startSwitch(
  BuildContext context,
  WidgetRef ref,
  String projectId,
) async {
  final tpls = ref.read(templatesProvider).value ?? const <Template>[];
  final pick = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Switch to template'),
      children: [
        for (final t in tpls)
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, t.id),
            child: Text(t.name),
          ),
      ],
    ),
  );
  if (pick == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          TemplateSwitchScreen(projectId: projectId, templateId: pick),
    ),
  );
}
