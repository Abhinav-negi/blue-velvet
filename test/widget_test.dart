import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/main.dart';

void main() {
  testWidgets('app starts on Home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LynchApp()));
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsOneWidget);
  });
}
