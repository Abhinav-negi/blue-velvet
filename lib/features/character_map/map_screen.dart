import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'map_providers.dart';

/// Canvas extent in canvas units; nodes live inside it.
const _canvas = 3000.0;
const _node = AppSize.mic;

/// Per-project character map: drag, link, group, zoom and pan. Every edit is
/// written to the DB as it happens.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _tc = TransformationController();
  bool _restored = false;
  // Live position while a node is being dragged (saved on drag end).
  final _drag = <String, Offset>{};

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  Future<void> _edit(void Function(MapData d) f) =>
      editMap(ref.read(dbProvider), widget.projectId, f);

  void _restore(MapData d) {
    if (_restored) return;
    _restored = true;
    final z = (d.viewport['zoom'] as num).toDouble();
    _tc.value = Matrix4.identity()
      ..translateByDouble(
        (d.viewport['x'] as num).toDouble(),
        (d.viewport['y'] as num).toDouble(),
        0,
        1,
      )
      ..scaleByDouble(z, z, 1, 1);
  }

  void _saveViewport() {
    final m = _tc.value;
    _edit(
      (d) => d.viewport
        ..['x'] = m.getTranslation().x
        ..['y'] = m.getTranslation().y
        ..['zoom'] = m.getMaxScaleOnAxis(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(mapProvider(widget.projectId)).value;
    final names = ref.watch(mapNamesProvider(widget.projectId)).value ?? {};
    if (data == null) return const Scaffold(body: SizedBox());
    _restore(data);
    final onMap = {for (final n in data.nodes) n['project_character_id']};
    final addable = names.entries.where((e) => !onMap.contains(e.key)).toList();
    final nodes = {for (final n in data.nodes) n['id'] as String: n};
    Offset pos(Map<String, dynamic> n) =>
        _drag[n['id']] ??
        Offset((n['x'] as num).toDouble(), (n['y'] as num).toDouble());
    Color? tint(Map<String, dynamic> n) {
      for (final g in data.groups) {
        if (g['id'] == n['group_id']) return groupColors[g['color']];
      }
      return null;
    }

    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character map'),
        actions: [
          PopupMenuButton<String>(
            key: const Key('add-node'),
            tooltip: 'Add character',
            icon: const Icon(LucideIcons.userPlus),
            enabled: addable.isNotEmpty,
            onSelected: (id) => _edit((d) {
              d.nodes.add({
                'id': newId(),
                'project_character_id': id,
                // Stagger new nodes so they never stack.
                'x': _canvas / 2 + d.nodes.length * AppSpace.s3,
                'y': _canvas / 2 + d.nodes.length * AppSpace.s3,
                'group_id': null,
              });
            }),
            itemBuilder: (_) => [
              for (final e in addable)
                PopupMenuItem(value: e.key, child: Text(e.value)),
            ],
          ),
        ],
      ),
      body: data.nodes.isEmpty
          ? Center(
              child: Text(
                'Add characters with the button above, then drag them into place.',
                style: AppType.body.copyWith(color: secondary),
                textAlign: TextAlign.center,
              ),
            )
          : InteractiveViewer(
              transformationController: _tc,
              constrained: false,
              minScale: 0.25,
              maxScale: 3,
              boundaryMargin: const EdgeInsets.all(AppSpace.s8),
              onInteractionEnd: (_) => _saveViewport(),
              child: SizedBox(
                width: _canvas,
                height: _canvas,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: const Size(_canvas, _canvas),
                      painter: _EdgePainter([
                        for (final e in data.edges)
                          if (nodes[e['from_node_id']] case final a?)
                            if (nodes[e['to_node_id']] case final b?)
                              (
                                pos(a) + const Offset(_node / 2, _node / 2),
                                pos(b) + const Offset(_node / 2, _node / 2),
                              ),
                      ], secondary),
                    ),
                    for (final e in data.edges)
                      if (nodes[e['from_node_id']] case final a?)
                        if (nodes[e['to_node_id']] case final b?)
                          _edgeLabel(e, pos(a), pos(b), data),
                    for (final n in data.nodes)
                      Positioned(
                        left: pos(n).dx,
                        top: pos(n).dy,
                        child: _nodeWidget(n, names, tint(n), data),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _edgeLabel(Map<String, dynamic> e, Offset a, Offset b, MapData d) {
    final mid = (a + b) / 2 + const Offset(_node / 2, _node / 2);
    return Positioned(
      left: mid.dx - AppSpace.s6,
      top: mid.dy - AppSpace.s2,
      width: AppSpace.s6 * 2,
      child: GestureDetector(
        key: Key('edge-${e['id']}'),
        onTap: () => _editEdge(e),
        child: Text(
          e['label'] as String,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppType.caption.copyWith(color: AppColors.darkText),
        ),
      ),
    );
  }

  Widget _nodeWidget(
    Map<String, dynamic> n,
    Map<String, String> names,
    Color? tint,
    MapData d,
  ) {
    final id = n['id'] as String;
    final name = names[n['project_character_id']] ?? '';
    final initials = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return GestureDetector(
      key: Key('node-$id'),
      onTap: () => context.pushNamed(
        'character-sheet',
        pathParameters: {
          'projectId': widget.projectId,
          'memberId': n['project_character_id'] as String,
        },
      ),
      onLongPress: () => _nodeMenu(n, d),
      onPanUpdate: (u) => setState(() {
        final cur =
            _drag[id] ??
            Offset((n['x'] as num).toDouble(), (n['y'] as num).toDouble());
        _drag[id] = cur + u.delta / _tc.value.getMaxScaleOnAxis();
      }),
      onPanEnd: (_) {
        final p = _drag[id];
        if (p == null) return;
        _edit((d) {
          for (final x in d.nodes) {
            if (x['id'] == id) {
              x['x'] = p.dx;
              x['y'] = p.dy;
            }
          }
        }).then((_) => mounted ? setState(() => _drag.remove(id)) : null);
      },
      child: SizedBox(
        width: _node + AppSpace.s6,
        child: Column(
          children: [
            Container(
              width: _node,
              height: _node,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkSurfaceRaised,
                border: Border.all(
                  color: tint ?? AppColors.darkDivider,
                  width: AppSpace.s05 / 2,
                ),
              ),
              child: Text(
                initials,
                style: AppType.heading.copyWith(color: AppColors.darkText),
              ),
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption.copyWith(color: AppColors.darkText),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _nodeMenu(Map<String, dynamic> n, MapData d) async {
    final id = n['id'] as String;
    final others = d.nodes.where((x) => x['id'] != id).toList();
    final names = ref.read(mapNamesProvider(widget.projectId)).value ?? {};
    final act = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            for (final x in others)
              ListTile(
                key: Key('link-${x['id']}'),
                leading: const Icon(LucideIcons.link),
                title: Text(
                  'Link to ${names[x['project_character_id']] ?? ''}',
                ),
                onTap: () => Navigator.pop(context, 'link:${x['id']}'),
              ),
            for (final g in d.groups)
              ListTile(
                leading: Icon(
                  LucideIcons.circleDot,
                  color: groupColors[g['color']],
                ),
                title: Text('Group: ${g['name']}'),
                onTap: () => Navigator.pop(context, 'group:${g['id']}'),
              ),
            ListTile(
              key: const Key('new-group'),
              leading: const Icon(LucideIcons.plus),
              title: const Text('New group'),
              onTap: () => Navigator.pop(context, 'newgroup'),
            ),
            if (n['group_id'] != null)
              ListTile(
                leading: const Icon(LucideIcons.circle),
                title: const Text('Remove from group'),
                onTap: () => Navigator.pop(context, 'group:'),
              ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('Remove from map'),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (act == null || !mounted) return;
    void setGroup(MapData d, String? gid) {
      for (final x in d.nodes) {
        if (x['id'] == id) x['group_id'] = gid;
      }
    }

    if (act.startsWith('link:')) {
      final to = act.substring(5);
      final label = await _askLabel('');
      if (label == null) return;
      await _edit(
        (d) => d.edges.add({
          'id': newId(),
          'from_node_id': id,
          'to_node_id': to,
          'label': label,
        }),
      );
    } else if (act.startsWith('group:')) {
      final g = act.substring(6);
      await _edit((d) => setGroup(d, g.isEmpty ? null : g));
    } else if (act == 'newgroup') {
      final g = await _askGroup();
      if (g == null) return;
      await _edit((d) {
        final gid = newId();
        d.groups.add({'id': gid, 'name': g.$1, 'color': g.$2});
        setGroup(d, gid);
      });
    } else if (act == 'remove') {
      await _edit((d) {
        d.nodes.removeWhere((x) => x['id'] == id);
        d.edges.removeWhere(
          (e) => e['from_node_id'] == id || e['to_node_id'] == id,
        );
      });
    }
  }

  Future<void> _editEdge(Map<String, dynamic> e) async {
    final label = await _askLabel(e['label'] as String, canDelete: true);
    if (label == null) return;
    await _edit((d) {
      if (label == '\u0000delete') {
        d.edges.removeWhere((x) => x['id'] == e['id']);
      } else {
        for (final x in d.edges) {
          if (x['id'] == e['id']) x['label'] = label;
        }
      }
    });
  }

  Future<String?> _askLabel(String initial, {bool canDelete = false}) {
    return showDialog<String>(
      context: context,
      builder: (_) => _LabelDialog(initial: initial, canDelete: canDelete),
    );
  }

  Future<(String, String)?> _askGroup() => showDialog<(String, String)>(
    context: context,
    builder: (_) => const _GroupDialog(),
  );
}

class _EdgePainter extends CustomPainter {
  _EdgePainter(this.lines, this.color);
  final List<(Offset, Offset)> lines;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = AppSpace.s05 / 4;
    for (final (a, b) in lines) {
      canvas.drawLine(a, b, p);
    }
  }

  @override
  bool shouldRepaint(_EdgePainter o) => true;
}

/// Free text plus quick picks from the seed.
class _LabelDialog extends ConsumerStatefulWidget {
  const _LabelDialog({required this.initial, required this.canDelete});
  final String initial;
  final bool canDelete;

  @override
  ConsumerState<_LabelDialog> createState() => _LabelDialogState();
}

class _LabelDialogState extends ConsumerState<_LabelDialog> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = ref.watch(relationshipLabelsProvider).value ?? const [];
    return AlertDialog(
      title: const Text('Relationship'),
      content: SizedBox(
        width: AppSize.maxTextColumn / 2,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('label-field'),
                controller: _c,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'sister, rival...'),
              ),
              const SizedBox(height: AppSpace.s1),
              Wrap(
                spacing: AppSpace.s1,
                children: [
                  for (final l in labels)
                    ActionChip(label: Text(l), onPressed: () => _c.text = l),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.canDelete)
          TextButton(
            onPressed: () => Navigator.pop(context, '\u0000delete'),
            child: const Text('Delete link'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: const Key('label-save'),
          onPressed: () => Navigator.pop(context, _c.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _GroupDialog extends StatefulWidget {
  const _GroupDialog();

  @override
  State<_GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<_GroupDialog> {
  final _c = TextEditingController();
  String _color = groupColors.keys.first;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('New group'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _c,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        const SizedBox(height: AppSpace.s1),
        Wrap(
          spacing: AppSpace.s1,
          children: [
            for (final e in groupColors.entries)
              ChoiceChip(
                avatar: Icon(LucideIcons.circleDot, color: e.value),
                label: Text(e.key),
                selected: _color == e.key,
                onSelected: (_) => setState(() => _color = e.key),
              ),
          ],
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => _c.text.trim().isEmpty
            ? null
            : Navigator.pop(context, (_c.text.trim(), _color)),
        child: const Text('Create'),
      ),
    ],
  );
}
