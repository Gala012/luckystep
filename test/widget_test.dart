import 'package:flutter_test/flutter_test.dart';
import 'package:lucky_star_pedometer/main.dart';

void main() {
  testWidgets('Guide page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(firstLaunch: true));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to this pedometer'), findsOneWidget);
  });
}
