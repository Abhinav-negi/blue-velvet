import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// Spec 11.1 sheet fields, in display order: (key, label, multiline).
const sheetFields = <(String, String, bool)>[
  ('name', 'Name', false),
  ('age', 'Age', false),
  ('role', 'Role in story', false),
  ('appearance', 'Appearance', true),
  ('background', 'Background story', true),
  ('traits', 'Personality traits', true),
  ('habits', 'Habits', true),
  ('wantsNeedsFears', 'Wants / needs / fears', true),
  ('notes', 'Notes', true),
];

/// A sheet as plain strings keyed by [sheetFields]; empty age = no age.
typedef Sheet = Map<String, String>;

Sheet sheetOfCharacter(Character c) => {
  'name': c.name,
  'age': c.age ?? '',
  'role': c.role,
  'appearance': c.appearance,
  'background': c.background,
  'traits': c.traits,
  'habits': c.habits,
  'wantsNeedsFears': c.wantsNeedsFears,
  'notes': c.notes,
};

Sheet sheetOfFork(ProjectCharacter m) => {
  'name': m.name ?? '',
  'age': m.age ?? '',
  'role': m.role ?? '',
  'appearance': m.appearance ?? '',
  'background': m.background ?? '',
  'traits': m.traits ?? '',
  'habits': m.habits ?? '',
  'wantsNeedsFears': m.wantsNeedsFears ?? '',
  'notes': m.notes ?? '',
};

String? _age(Sheet s) => s['age']!.trim().isEmpty ? null : s['age']!.trim();

CharactersCompanion characterCompanion(Sheet s, int now) => CharactersCompanion(
  name: Value(s['name']!.trim()),
  age: Value(_age(s)),
  role: Value(s['role']!),
  appearance: Value(s['appearance']!),
  background: Value(s['background']!),
  traits: Value(s['traits']!),
  habits: Value(s['habits']!),
  wantsNeedsFears: Value(s['wantsNeedsFears']!),
  notes: Value(s['notes']!),
  updatedAt: Value(now),
);

ProjectCharactersCompanion forkCompanion(Sheet s, int now) =>
    ProjectCharactersCompanion(
      name: Value(s['name']!.trim()),
      age: Value(_age(s)),
      role: Value(s['role']),
      appearance: Value(s['appearance']),
      background: Value(s['background']),
      traits: Value(s['traits']),
      habits: Value(s['habits']),
      wantsNeedsFears: Value(s['wantsNeedsFears']),
      notes: Value(s['notes']),
      updatedAt: Value(now),
    );

/// The global pool: every character, A to Z.
final poolProvider = StreamProvider<List<Character>>(
  (ref) => ref.watch(dbProvider).charactersDao.watchAll(),
);

/// A project's character as shown in its list.
class MemberView {
  const MemberView(this.memberId, this.name, this.role, {required this.forked});
  final String memberId, name, role;
  final bool forked;
}

/// Members of a project, sheet resolved (linked = global row, forked = own).
final projectMembersProvider = StreamProvider.family<List<MemberView>, String>((
  ref,
  projectId,
) {
  final pool = ref.watch(poolProvider).value ?? const <Character>[];
  final byId = {for (final c in pool) c.id: c};
  final members = ref.watch(dbProvider).charactersDao.watchMembers(projectId);
  return members.map((ms) {
    final out = <MemberView>[];
    for (final m in ms) {
      if (m.mode == CharacterMode.forked) {
        out.add(MemberView(m.id, m.name ?? '', m.role ?? '', forked: true));
      } else if (byId[m.characterId] case final c?) {
        out.add(MemberView(m.id, c.name, c.role, forked: false));
      }
    }
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  });
});

/// Sheet key: [projectId] set = [id] is a project_characters id, else a
/// characters id. A null [id] is a new sheet.
typedef SheetKey = ({String? projectId, String? id});

final sheetProvider = FutureProvider.family<Sheet?, SheetKey>((ref, k) async {
  final db = ref.watch(dbProvider);
  if (k.id == null) return {for (final f in sheetFields) f.$1: ''};
  var charId = k.id;
  if (k.projectId != null) {
    final m = await (db.select(
      db.projectCharacters,
    )..where((t) => t.id.equals(k.id!))).getSingleOrNull();
    if (m == null) return null;
    if (m.mode == CharacterMode.forked) return sheetOfFork(m);
    charId = m.characterId;
  }
  final c = await (db.select(
    db.characters,
  )..where((t) => t.id.equals(charId!))).getSingleOrNull();
  return c == null ? null : sheetOfCharacter(c);
});

/// "Appears in" (derived): titles of beats that reference this character.
final appearsInProvider = FutureProvider.family<List<String>, SheetKey>((
  ref,
  k,
) async {
  if (k.id == null) return const [];
  final db = ref.watch(dbProvider);
  final ids = k.projectId != null
      ? {k.id!}
      : (await (db.select(
              db.projectCharacters,
            )..where((t) => t.characterId.equals(k.id!))).get())
            .map((m) => m.id)
            .toSet();
  final beats = await db.select(db.beats).get();
  return [
    for (final b in beats)
      if (b.characterIds.any(ids.contains)) b.title,
  ];
});
