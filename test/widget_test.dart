import 'package:flutter_test/flutter_test.dart';
import 'package:travel_sarthi/main.dart';

void main() {
  testWidgets('Travel Sarthi smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelSarthiApp());
    expect(find.text('Travel Sarthi'), findsOneWidget);
  });
}
