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
  testWidgets('Verify User can Login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    //  (Logo image/text, 3 TextFormFields and a LoginButton)
    // Verify Logo exists.
    expect(find.text('CEAM POS'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Rut'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify are in calculator screen.
    // expect(find.text('CEAM POS'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify exist 5 elements in Login screen (Logo image/text, 3 TextFormFields and a LoginButton)
    // Verify Logo exists.
    expect(find.text('CEAM POS'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Rut'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
