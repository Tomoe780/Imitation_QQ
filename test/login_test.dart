import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('Fake Test Group', () {
    testWidgets('should always pass', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Click Me'),
            ),
          ),
        ),
      );

      final buttonFinder = find.text('Click Me');

      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(true, true);
    });
  });
}
