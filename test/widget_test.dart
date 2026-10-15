import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LynchApp()));
    expect(find.text('Lynch'), findsOneWidget);
  });
}
