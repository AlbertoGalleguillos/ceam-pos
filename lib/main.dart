import 'package:ceam_pos/login.dart';
import 'package:ceam_pos/home.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = Constants.APP_NAME;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Login(),
      //MyHomePage(title: title)
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Login(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Home(),
      },
    );
  }
}
