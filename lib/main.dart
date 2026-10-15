import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: LynchApp()));

class LynchApp extends StatelessWidget {
  const LynchApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Lynch',
        home: Scaffold(body: Center(child: Text('Lynch'))),
      );
}
