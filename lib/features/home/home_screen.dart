import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lynch/core/widgets/app_shell_placeholder.dart';

/// Placeholder: the project list and Infinite Void entry come with the Home task.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: PlaceholderScreen(
        title: 'Projects',
        children: [
          TextButton(
            onPressed: () => context.goNamed(
              'overview',
              pathParameters: {'projectId': 'new'},
            ),
            child: const Text('Open a project'),
          ),
          TextButton(
            onPressed: () => context.goNamed('void'),
            child: const Text('Infinite Void'),
          ),
        ],
      ),
    ),
  );
}
