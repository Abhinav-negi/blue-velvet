import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'template_providers.dart';

/// Create ([id] null) or edit a template by hand.
class TemplateEditScreen extends ConsumerStatefulWidget {
  const TemplateEditScreen({this.id, super.key});
  final String? id;

  @override
  ConsumerState<TemplateEditScreen> createState() => _State();
}

class _Row {
  _Row(this.id, String name, String desc, double? prop)
    : name = TextEditingController(text: name),
      desc = TextEditingController(text: desc),
      prop = TextEditingController(
        text: prop == null ? '' : '${(prop * 100).round()}',
      );
  final String? id;
  final TextEditingController name, desc, prop;
}

class _State extends ConsumerState<TemplateEditScreen> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _url = TextEditingController();
  final _types = <String>{};
  final _rows = <_Row>[];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      _loaded = true;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    final t = await (db.select(
      db.templates,
    )..where((t) => t.id.equals(widget.id!))).getSingle();
    final slots =
        await (db.select(db.slots)
              ..where((s) => s.templateId.equals(t.id))
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
    if (!mounted) return;
    setState(() {
      _name.text = t.name;
      _desc.text = t.description;
      _url.text = t.sourceUrl ?? '';
      _types.addAll(t.projectTypes);
      for (final s in slots) {
        _rows.add(_Row(s.id, s.name, s.description, s.runtimeProportion));
      }
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final nav = Navigator.of(context);
    await saveTemplate(
      ref.read(dbProvider),
      id: widget.id,
      name: _name.text,
      description: _desc.text,
      sourceUrl: _url.text,
      projectTypes: _types.toList(),
      slots: [
        for (final r in _rows)
          SlotDraft(
            id: r.id,
            name: r.name.text,
            description: r.desc.text,
            proportion: double.tryParse(r.prop.text.trim()) == null
                ? null
                : (double.parse(r.prop.text.trim()) / 100).clamp(0, 1),
          ),
      ],
    );
    nav.pop();
  }

  void _move(int i, int by) => setState(() {
    final j = i + by;
    if (j < 0 || j >= _rows.length) return;
    _rows.insert(j, _rows.removeAt(i));
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New template' : 'Edit template'),
        actions: [
          TextButton(
            onPressed: _loaded && _name.text.trim().isNotEmpty ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSize.sideMargin),
        children: [
          TextField(
            key: const Key('tpl-name'),
            controller: _name,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: AppSpace.s2),
          TextField(
            key: const Key('tpl-desc'),
            controller: _desc,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: AppSpace.s2),
          TextField(
            controller: _url,
            decoration: const InputDecoration(labelText: 'Source link'),
          ),
          const SizedBox(height: AppSpace.s2),
          Wrap(
            spacing: AppSpace.s1,
            children: [
              for (final p in ProjectType.values)
                FilterChip(
                  label: Text(_typeLabel(p)),
                  selected: _types.contains(_snake(p)),
                  onSelected: (v) => setState(
                    () => v ? _types.add(_snake(p)) : _types.remove(_snake(p)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s3),
          Text('Slots', style: text.titleMedium),
          for (final (i, r) in _rows.indexed)
            Padding(
              key: ObjectKey(r),
              padding: const EdgeInsets.only(top: AppSpace.s2),
              child: Column(
                children: [
                  TextField(
                    key: Key('slot-name-$i'),
                    controller: r.name,
                    decoration: InputDecoration(labelText: 'Slot ${i + 1}'),
                  ),
                  TextField(
                    key: Key('slot-desc-$i'),
                    controller: r.desc,
                    maxLines: null,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: AppSize.maxTextColumn / 4,
                        child: TextField(
                          controller: r.prop,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Runtime %',
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Move up',
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () => _move(i, -1),
                      ),
                      IconButton(
                        tooltip: 'Move down',
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () => _move(i, 1),
                      ),
                      IconButton(
                        tooltip: 'Remove slot',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _rows.removeAt(i)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpace.s2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _rows.add(_Row(null, '', '', null))),
              icon: const Icon(Icons.add),
              label: const Text('Add slot'),
            ),
          ),
        ],
      ),
    );
  }
}

/// DB form of a project type (DATA_MODEL 4): `shortFilm` -> `short_film`.
String _snake(ProjectType p) =>
    p.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

String _typeLabel(ProjectType p) => switch (p) {
  ProjectType.shortFilm => 'Short film',
  ProjectType.longFilm => 'Long film',
  ProjectType.youtube => 'YouTube',
  ProjectType.short => 'Short',
};
