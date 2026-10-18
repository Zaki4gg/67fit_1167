import 'package:flutter_test/flutter_test.dart';

import 'package:fit67/main.dart';

void main() {
  testWidgets('App menampilkan bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const Fit67App());

    // Bottom nav menyediakan 4 tab: Home, Wardrobe, Styling, Planner.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Wardrobe'), findsOneWidget);

    // Tab Wardrobe: header koleksi terlihat.
    await tester.tap(find.text('Wardrobe'));
    await tester.pumpAndSettle();
    expect(find.text('Your Collection'), findsOneWidget);
  });
}
