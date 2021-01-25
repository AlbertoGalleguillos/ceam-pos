import 'package:ceam_pos/login.dart';
import 'package:ceam_pos/home.dart';
import 'package:ceam_pos/print.dart';
import 'package:ceam_pos/salesReport.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

//TODO:
// Imprimir con datos de prueba
// Imprimir con datos de prueba pero que vengan del objeto empresa
// Crear pantalla de configuración de impresora
// Crear calculadora propia, reviar las siguientes implementaciones:
// https://itnext.io/building-a-calculator-app-in-flutter-824254704fe6
// https://medium.com/@ykaito21/how-to-build-a-simple-calculator-app-with-flutter-part-1-e43943d016a8
// Cambiar los colores por los oficiales
// Poner los íconos oficiales
// Terminar el proceso de venta (Efectivo o tarjeta)


class MyApp extends StatelessWidget {
  final String title = Constants.APP_NAME;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        Login.route: (context) => Login(),
        Home.route: (context) => Home(),
        PrinterApp.route: (context) => PrinterApp(),
        SalesReport.route: (context) => SalesReport(),
      },
    );
  }
}
