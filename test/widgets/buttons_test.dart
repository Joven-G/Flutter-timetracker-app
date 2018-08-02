import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/widgets/buttons.dart';
import 'package:flutter/material.dart';

void main() {
  final fixedCallback = () {};
  final String buttonLabel = 'A button';

  Widget wrapButton(Widget widget) {
    return MaterialApp(
        home: widget
    );
  }

  testWidgets('AButton returns a flat button when requested', (WidgetTester tester) async {
    Widget flatButton = wrapButton(
      AButton(
        isRaised: false,
        label: buttonLabel,
        onPressed: fixedCallback
      )
    );
    
    await tester.pumpWidget(flatButton);
    
    expect(find.text(buttonLabel), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is FlatButton && widget.onPressed == fixedCallback
      ),
      findsOneWidget
    );
  });

  testWidgets('AButton returns a raised button when requested', (WidgetTester tester) async {
    Widget raisedButton = wrapButton(
      AButton(
        isRaised: true,
        label: buttonLabel,
        onPressed: fixedCallback
      )
    );

    await tester.pumpWidget(raisedButton);

    expect(find.text(buttonLabel), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is RaisedButton && widget.onPressed == fixedCallback
      ),
      findsOneWidget
    );
  });
}