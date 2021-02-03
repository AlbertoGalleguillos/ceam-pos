// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ceam_pos/main.dart';

void main() {
  testWidgets('Render Login', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('CEAM POS'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Verify that all fields are valid', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Usuario'), findsOneWidget);

    // await tester.enterText(find.by, 'ellanca');
    // await tester.enterText(find.text('Rut'), '25107882-3');
    // await tester.enterText(find.text('Contraseña'), '43734373');
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.text('Login'));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
