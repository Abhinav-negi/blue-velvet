import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';
import 'package:uuid/uuid.dart';

import 'characters_providers.dart';

/// True when the membership [SheetKey.id] is still linked.
final _linkedProvider = StreamProvider.family<bool, SheetKey>((ref, k) {
  final db = ref.watch(dbProvider);
  return (db.select(db.projectCharacters)
        ..where((t) => t.id.equals(k.id ?? '')))
      .watchSingleOrNull()
      .map((m) => m?.mode == CharacterMode.linked);
});

/// One character sheet (spec 11.1). With [projectId], [id] is that project's
/// membership row; without, a pool character. Null [id] creates one.
class CharacterSheetScreen extends ConsumerWidget {
  const CharacterSheetScreen({super.key, this.projectId, this.id});
  final String? projectId, id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (projectId: projectId, id: id);
    final sheet = ref.watch(sheetProvider(key)).value;
    final linked = ref.watch(_linkedProvider(key)).value;
    final appears = ref.watch(appearsInProvider(key)).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'New character' : 'Character'),
        actions: [
          if (projectId != null && id != null && (linked ?? false))
            TextButton(
              key: const Key('fork'),
              onPressed: () => forkMember(ref.read(dbProvider), id!),
              child: const Text('Fork'),
            ),
        ],
      ),
      body: sheet == null
          ? const SizedBox.shrink()
          : _Form(
              initial: sheet,
              appearsIn: appears,
              onSave: (s) async {
                await _save(ref, s);
                if (context.mounted) context.pop();
              },
            ),
    );
  }

  Future<void> _save(WidgetRef ref, Sheet s) async {
    final db = ref.read(dbProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (id == null) {
      final cid = const Uuid().v4();
      await db
          .into(db.characters)
          .insert(
            characterCompanion(
              s,
              now,
            ).copyWith(id: Value(cid), createdAt: Value(now)),
          );
      if (projectId != null) {
        await db
            .into(db.projectCharacters)
            .insert(
              ProjectCharactersCompanion.insert(
                id: const Uuid().v4(),
                projectId: projectId!,
                characterId: Value(cid),
                mode: CharacterMode.linked,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      return;
    }
    var charId = id!;
    if (projectId != null) {
      final m = await (db.select(
        db.projectCharacters,
      )..where((t) => t.id.equals(id!))).getSingle();
      if (m.mode == CharacterMode.forked) {
        await (db.update(
          db.projectCharacters,
        )..where((t) => t.id.equals(id!))).write(forkCompanion(s, now));
        return;
      }
      charId = m.characterId!;
    }
    await (db.update(
      db.characters,
    )..where((t) => t.id.equals(charId))).write(characterCompanion(s, now));
  }
}

class _Form extends StatefulWidget {
  const _Form({
    required this.initial,
    required this.appearsIn,
    required this.onSave,
  });
  final Sheet initial;
  final List<String> appearsIn;
  final Future<void> Function(Sheet) onSave;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final _c = {
    for (final f in sheetFields)
      f.$1: TextEditingController(text: widget.initial[f.$1]),
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSize.sideMargin),
    children: [
      for (final (k, label, multi) in sheetFields)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s2),
          child: TextField(
            key: Key('field-$k'),
            controller: _c[k],
            minLines: multi ? 2 : 1,
            maxLines: multi ? null : 1,
            decoration: InputDecoration(labelText: label),
          ),
        ),
      Text('Appears in', style: AppType.label),
      const SizedBox(height: AppSpace.s1),
      if (widget.appearsIn.isEmpty)
        Text('No beats yet.', style: AppType.body)
      else
        for (final t in widget.appearsIn) Text(t, style: AppType.body),
      const SizedBox(height: AppSpace.s3),
      FilledButton(
        onPressed: () {
          final s = {for (final e in _c.entries) e.key: e.value.text};
          if (s['name']!.trim().isEmpty) return;
          widget.onSave(s);
        },
        child: const Text('Save'),
      ),
    ],
  );
}
