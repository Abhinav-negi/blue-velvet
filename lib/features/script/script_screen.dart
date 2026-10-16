import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

import 'beat_pager.dart';
import 'say_show_editor.dart';
import 'scaffold_suggestions.dart';
import 'screenplay_editor.dart';

final _beatsProvider = StreamProvider.autoDispose.family<List<Beat>, String>(
  (ref, projectId) => ref.watch(dbProvider).beatsDao.watchForProject(projectId),
);

final _projectProvider = FutureProvider.autoDispose.family<Project?, String>(
  (ref, id) => ref.watch(dbProvider).projectsDao.byId(id),
);

/// Script tab: pick a beat, write its screenplay (films) or Say/Show
/// (YouTube, Short).
class ScriptScreen extends ConsumerStatefulWidget {
  const ScriptScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends ConsumerState<ScriptScreen> {
  String? _beatId;
  Beat? _saved; // beat as written by an accepted suggestion
  int _rev = 0;
  final _asked = <String>{};

  String _key(Beat b) => '${b.id}-$_rev';

  @override
  Widget build(BuildContext context) {
    final beats = ref.watch(_beatsProvider(widget.projectId)).value;
    final theme = Theme.of(context);
    final type = ref.watch(_projectProvider(widget.projectId)).value?.type;
    final first = beats == null || beats.isEmpty
        ? null
        : beats.firstWhere((b) => b.id == _beatId, orElse: () => beats.first);
    final selected = _saved?.id == first?.id ? _saved : first;
    final project = ref.watch(_projectProvider(widget.projectId)).value;
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
                      onSelected: (_) => setState(() {
                        _beatId = b.id;
                        _saved = null;
                      }),
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
              : type == null
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Expanded(
                      child: BeatPager(
                        key: ValueKey('pager-${selected.id}'),
                        projectId: widget.projectId,
                        beatId: selected.id,
                        script:
                            type == ProjectType.youtube ||
                                type == ProjectType.short
                            ? SayShowEditor(
                                key: ValueKey(_key(selected)),
                                beat: selected,
                              )
                            : ScreenplayEditor(
                                key: ValueKey(_key(selected)),
                                beat: selected,
                              ),
                      ),
                    ),
                    if (project != null)
                      ScaffoldSuggestions(
                        key: ValueKey('sugg-${selected.id}'),
                        beat: selected,
                        project: project,
                        auto: _asked.add(selected.id),
                        onAccepted: (b) => setState(() {
                          _saved = b;
                          _rev++;
                        }),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
