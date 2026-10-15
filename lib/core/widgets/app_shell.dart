import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';

/// One project section (tab or rail destination).
class ShellTab {
  const ShellTab({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

/// Width at which section tabs move from the top to a left rail (design.md 7.2).
const double kShellRailBreakpoint = 600;

/// Project shell: section tabs (top on phones, left rail from 600 dp) plus the
/// 64 dp bottom bar (home, mic dock slot, proposals inbox). Pure UI: the
/// caller (router) supplies tabs and callbacks, so core never knows features.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTab,
    required this.onHome,
    required this.onInbox,
    required this.child,
    this.onMic,
  });

  final List<ShellTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTab;
  final VoidCallback onHome, onInbox;

  /// Placeholder until CAP-01 provides the real mic dock.
  final VoidCallback? onMic;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= kShellRailBreakpoint;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: wide
            ? Row(
                children: [
                  NavigationRail(
                    key: const Key('shell-rail'),
                    backgroundColor: scheme.surface,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onTab,
                    labelType: NavigationRailLabelType.all,
                    // Teal = "where you are" (design.md §5.3); amber is reserved for the mic.
                    indicatorColor: scheme.surfaceContainerHighest,
                    selectedIconTheme: IconThemeData(color: scheme.secondary),
                    selectedLabelTextStyle: AppType.label.copyWith(color: scheme.secondary),
                    destinations: [
                      for (final t in tabs)
                        NavigationRailDestination(
                          icon: Icon(t.icon),
                          label: Text(t.label),
                        ),
                    ],
                  ),
                  Expanded(child: child),
                ],
              )
            : Column(
                children: [
                  _TabRow(
                    tabs: tabs,
                    selectedIndex: selectedIndex,
                    onTab: onTab,
                  ),
                  Expanded(child: child),
                ],
              ),
      ),
      bottomNavigationBar: _BottomBar(
        onHome: onHome,
        onInbox: onInbox,
        onMic: onMic ?? () {},
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    required this.tabs,
    required this.selectedIndex,
    required this.onTab,
  });
  final List<ShellTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      key: const Key('shell-tabs'),
      color: scheme.surface,
      child: SizedBox(
        height: AppSize.button,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Semantics(
                  button: true,
                  selected: i == selectedIndex,
                  child: InkWell(
                    onTap: () => onTab(i),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.s2,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: i == selectedIndex
                                ? scheme.secondary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        tabs[i].label,
                        style: AppType.label.copyWith(
                          color: i == selectedIndex
                              ? scheme.secondary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onHome,
    required this.onInbox,
    required this.onMic,
  });
  final VoidCallback onHome, onInbox, onMic;

  @override
  Widget build(BuildContext context) {
    final mic = Theme.of(context).extension<MicColors>()!;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          key: const Key('shell-bottom-bar'),
          height: AppSize.bottomBar,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Home',
                    onPressed: onHome,
                    iconSize: AppSize.icon,
                    constraints: const BoxConstraints(
                      minWidth: AppSize.minTouch,
                      minHeight: AppSize.minTouch,
                    ),
                    icon: const Icon(LucideIcons.house),
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Record idea',
                child: Material(
                  key: const Key('shell-mic'),
                  color: mic.idle,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onMic,
                    child: SizedBox.square(
                      dimension: AppSize.mic,
                      child: Icon(
                        LucideIcons.mic,
                        size: AppSize.icon,
                        color: mic.onIdle,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Proposals inbox',
                    onPressed: onInbox,
                    iconSize: AppSize.icon,
                    constraints: const BoxConstraints(
                      minWidth: AppSize.minTouch,
                      minHeight: AppSize.minTouch,
                    ),
                    icon: const Icon(LucideIcons.inbox),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
