import 'package:flutter/widgets.dart';
import 'package:lynch/core/widgets/app_shell_placeholder.dart';

class VoidScreen extends StatelessWidget {
  const VoidScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Infinite Void');
}
