import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/pages/home.dart';

void main() {
  testWidgets('Test the Home Page Widget', (WidgetTester tester) async {
    final Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new HomePage())
    );

    await tester.pumpWidget(testWidget);

    expect(find.text('Time Tracker'), findsOneWidget);
  });
}
