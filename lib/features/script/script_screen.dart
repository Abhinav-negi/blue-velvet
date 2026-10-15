import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'screenplay_editor.dart';

final _beatsProvider = StreamProvider.autoDispose.family<List<Beat>, String>(
  (ref, projectId) => ref.watch(dbProvider).beatsDao.watchForProject(projectId),
);

/// Script tab: pick a beat, write its screenplay.
// SCR-02: switch on project type here (screenplay vs Say/Show).
class ScriptScreen extends ConsumerStatefulWidget {
  const ScriptScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends ConsumerState<ScriptScreen> {
  String? _beatId;

  @override
  Widget build(BuildContext context) {
    final beats = ref.watch(_beatsProvider(widget.projectId)).value;
    final theme = Theme.of(context);
    final selected = beats == null || beats.isEmpty
        ? null
        : beats.firstWhere((b) => b.id == _beatId, orElse: () => beats.first);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpace.s2),
          child: Text('Script', style: theme.textTheme.titleLarge),
        ),
        if (beats != null && beats.length > 1)
          SizedBox(
            height: AppSize.minTouch,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
              children: [
                for (final b in beats)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.s1),
                    child: ChoiceChip(
                      label: Text(b.title),
                      selected: b.id == selected!.id,
                      onSelected: (_) => setState(() => _beatId = b.id),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: selected == null
              ? Center(
                  child: Text(
                    beats == null ? '' : 'Add a beat to start writing.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ScreenplayEditor(key: ValueKey(selected.id), beat: selected),
        ),
      ],
    );
  }
}
