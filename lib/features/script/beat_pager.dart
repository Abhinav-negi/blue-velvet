import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/data/db.dart';
import 'package:lynch/core/data/providers.dart';
import 'package:lynch/core/theme/tokens.dart';

final _framesProvider = StreamProvider.autoDispose.family<List<Frame>, String>(
  (ref, beatId) => ref.watch(dbProvider).beatsDao.watchFrames(beatId),
);

/// Two pages for one beat: [script] on the left, its storyboard frames on the
/// right, with a two-dot indicator. Frames are read from core tables (features
/// can't import storyboard); "Open board" goes to the `board` route.
class BeatPager extends StatefulWidget {
  const BeatPager({
    super.key,
    required this.projectId,
    required this.beatId,
    required this.script,
  });
  final String projectId;
  final String beatId;
  final Widget script;

  @override
  State<BeatPager> createState() => _BeatPagerState();
}

class _BeatPagerState extends State<BeatPager> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: PageView(
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              widget.script,
              _BoardPage(projectId: widget.projectId, beatId: widget.beatId),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpace.s1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 2; i++)
                Container(
                  key: ValueKey('dot-$i${i == _page ? '-active' : ''}'),
                  width: AppSpace.s1,
                  height: AppSpace.s1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s1 / 2,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _page ? scheme.primary : scheme.outlineVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoardPage extends ConsumerWidget {
  const _BoardPage({required this.projectId, required this.beatId});
  final String projectId;
  final String beatId;

  static String _caption(Frame f) => [
    f.shotSize,
    f.angle,
    f.movement,
    f.lensFeel,
  ].where((s) => s != null && s.trim().isNotEmpty).join(' · ');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frames = ref.watch(_framesProvider(beatId)).value ?? const <Frame>[];
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpace.s2),
      children: [
        if (frames.isEmpty)
          Text('No frames yet.', style: theme.textTheme.bodyMedium),
        for (final f in frames)
          Card(
            child: ListTile(
              key: ValueKey('frame-${f.id}'),
              leading: CircleAvatar(child: Text('${f.position + 1}')),
              title: Text(
                _caption(f).isEmpty ? 'Frame ${f.position + 1}' : _caption(f),
              ),
              subtitle: f.notes.isEmpty ? null : Text(f.notes),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => context.pushNamed(
              'board',
              pathParameters: {'projectId': projectId},
            ),
            child: const Text('Open board'),
          ),
        ),
      ],
    );
  }
}
