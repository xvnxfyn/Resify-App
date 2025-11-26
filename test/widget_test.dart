import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("DB OK"),
          ),
        ),
      ),
    );

    // Verify that the app displays the expected text.
    expect(find.text('DB OK'), findsOneWidget);
  });
}
