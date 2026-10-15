import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// All Void items, newest first.
final voidItemsProvider = StreamProvider<List<VoidItem>>(
  (ref) => ref.watch(dbProvider).voidItemsDao.watchAll(),
);

enum VoidDate {
  week('Last 7 days', Duration(days: 7)),
  month('Last 30 days', Duration(days: 30));

  const VoidDate(this.label, this.span);
  final String label;
  final Duration span;
}

/// Active Void filters. Null means "no filter on that axis"; all combine (AND).
class VoidFilter {
  const VoidFilter({
    this.query = '',
    this.type,
    this.tag,
    this.date,
    this.used,
  });
  final String query;
  final VoidType? type;
  final String? tag;
  final VoidDate? date;

  /// true = used only, false = unused only.
  final bool? used;

  VoidFilter copyWith({
    String? query,
    ({VoidType? v})? type,
    ({String? v})? tag,
    ({VoidDate? v})? date,
    ({bool? v})? used,
  }) => VoidFilter(
    query: query ?? this.query,
    type: type == null ? this.type : type.v,
    tag: tag == null ? this.tag : tag.v,
    date: date == null ? this.date : date.v,
    used: used == null ? this.used : used.v,
  );
}

class VoidFilterNotifier extends Notifier<VoidFilter> {
  @override
  VoidFilter build() => const VoidFilter();
  void set(VoidFilter f) => state = f;
}

final voidFilterProvider = NotifierProvider<VoidFilterNotifier, VoidFilter>(
  VoidFilterNotifier.new,
);

/// Items after search + filters. Search uses the DAO's FTS5 query (summary +
/// transcript, best match first); filters are plain Dart over the stream.
final filteredVoidItemsProvider = FutureProvider<List<VoidItem>>((ref) async {
  final all = await ref.watch(voidItemsProvider.future);
  final f = ref.watch(voidFilterProvider);
  var items = all;
  if (f.query.trim().isNotEmpty) {
    final hits = await ref.watch(dbProvider).voidItemsDao.search(f.query);
    final byId = {for (final a in all) a.id: a};
    items = [
      for (final h in hits)
        if (byId[h.id] != null) byId[h.id]!,
    ];
  }
  final since = f.date == null
      ? null
      : DateTime.now().subtract(f.date!.span).millisecondsSinceEpoch;
  return [
    for (final i in items)
      if ((f.type == null || i.type == f.type) &&
          (f.tag == null || i.tags.contains(f.tag)) &&
          (since == null || i.createdAt >= since) &&
          (f.used == null || i.usedInProjectIds.isNotEmpty == f.used))
        i,
  ];
});

final voidItemProvider = FutureProvider.family<VoidItem?, String>(
  (ref, id) => ref.watch(dbProvider).voidItemsDao.byId(id),
);

extension VoidTypeView on VoidType {
  IconData get icon => switch (this) {
    VoidType.storyIdea => LucideIcons.sparkles,
    VoidType.concept => LucideIcons.lightbulb,
    VoidType.character => LucideIcons.user,
    VoidType.dialogue => LucideIcons.messageSquare,
    VoidType.lyric => LucideIcons.music,
    VoidType.sceneFragment => LucideIcons.clapperboard,
    VoidType.other => LucideIcons.fileText,
  };

  String get label => switch (this) {
    VoidType.storyIdea => 'Story idea',
    VoidType.concept => 'Concept',
    VoidType.character => 'Character',
    VoidType.dialogue => 'Dialogue',
    VoidType.lyric => 'Lyric',
    VoidType.sceneFragment => 'Scene fragment',
    VoidType.other => 'Other',
  };
}
