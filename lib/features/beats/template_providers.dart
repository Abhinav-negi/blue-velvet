import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// Built-ins first, then the user's own, each A-Z.
final templatesProvider = StreamProvider<List<Template>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.templates)..orderBy([
        (t) => OrderingTerm.desc(t.builtin),
        (t) => OrderingTerm.asc(t.name),
      ]))
      .watch();
});

/// Slots of one template in order.
final slotsProvider = StreamProvider.family<List<Slot>, String>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.slots)
        ..where((s) => s.templateId.equals(id))
        ..orderBy([(s) => OrderingTerm.asc(s.position)]))
      .watch();
});

/// One slot as typed in the editor. [id] is null for a new slot.
class SlotDraft {
  SlotDraft({this.id, this.name = '', this.description = '', this.proportion});
  final String? id;
  String name;
  String description;
  double? proportion;
}

/// Creates a template ([id] null) or updates one. Editing a built-in marks it
/// and its changed slots `user_edited` so the seed merge keeps the edits.
/// Slots missing from [slots] are deleted; list order becomes position.
Future<String> saveTemplate(
  AppDatabase db, {
  String? id,
  required String name,
  required String description,
  String? sourceUrl,
  required List<String> projectTypes,
  required List<SlotDraft> slots,
}) => db.transaction(() async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final tid = id ?? 'tpl-$now';
  final old = id == null
      ? null
      : await (db.select(
          db.templates,
        )..where((t) => t.id.equals(id))).getSingle();
  final oldSlots = {
    for (final s
        in id == null
            ? const <Slot>[]
            : await (db.select(
                db.slots,
              )..where((s) => s.templateId.equals(id))).get())
      s.id: s,
  };
  final url = (sourceUrl ?? '').trim();
  await db
      .into(db.templates)
      .insertOnConflictUpdate(
        TemplatesCompanion(
          id: Value(tid),
          name: Value(name.trim()),
          description: Value(description.trim()),
          sourceUrl: Value(url.isEmpty ? null : url),
          projectTypes: Value(projectTypes),
          builtin: Value(old?.builtin ?? false),
          userEdited: Value(old?.builtin ?? false),
          seedId: Value(old?.seedId),
          createdAt: Value(old?.createdAt ?? now),
          updatedAt: Value(now),
        ),
      );
  final keep = slots.map((s) => s.id).whereType<String>().toSet();
  for (final gone in oldSlots.keys.where((k) => !keep.contains(k))) {
    await (db.delete(db.slots)..where((s) => s.id.equals(gone))).go();
  }
  for (var i = 0; i < slots.length; i++) {
    final d = slots[i];
    final o = d.id == null ? null : oldSlots[d.id];
    final changed =
        o == null ||
        o.name != d.name.trim() ||
        o.description != d.description.trim() ||
        o.runtimeProportion != d.proportion ||
        o.position != i;
    await db
        .into(db.slots)
        .insertOnConflictUpdate(
          SlotsCompanion(
            id: Value(o?.id ?? '$tid-slot-$now-$i'),
            templateId: Value(tid),
            position: Value(i),
            name: Value(d.name.trim()),
            description: Value(d.description.trim()),
            runtimeProportion: Value(d.proportion),
            builtin: Value(o?.builtin ?? false),
            userEdited: Value(
              (o?.userEdited ?? false) || (o != null && o.builtin && changed),
            ),
            seedId: Value(o?.seedId),
            createdAt: Value(o?.createdAt ?? now),
            updatedAt: Value(changed ? now : o.updatedAt),
          ),
        );
  }
  return tid;
});

/// Deletes a user-made template (built-ins are never deleted).
Future<void> deleteTemplate(AppDatabase db, String id) => (db.delete(
  db.templates,
)..where((t) => t.id.equals(id) & t.builtin.equals(false))).go();
