import 'package:flutter_test/flutter_test.dart';
import 'package:last_moment/app.dart';

void main() {
  testWidgets('App loads auth gate', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
