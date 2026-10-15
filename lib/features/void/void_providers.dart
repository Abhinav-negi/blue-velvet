import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';

/// All Void items, newest first.
final voidItemsProvider = StreamProvider<List<VoidItem>>(
  (ref) => ref.watch(dbProvider).voidItemsDao.watchAll(),
);

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
