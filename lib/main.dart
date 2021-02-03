import 'package:ceam_pos/login.dart';
import 'package:ceam_pos/home.dart';
import 'package:ceam_pos/print.dart';
import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:ceam_pos/salesReport.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ChangeNotifierProxyProvider<LoginProvider, PrintProvider>(
        update: (context, login, previousMessages) => PrintProvider(login),
        create: (BuildContext context) => PrintProvider(null),
      ),
    ],
    child: MyApp(),
  ));
}

//TODO:
// ✅ Imprimir con datos de prueba
// ✅ Imprimir con datos de prueba pero que vengan del objeto empresa
// Crear pantalla de configuración de impresora
// Crear calculadora propia, revisar las siguientes implementaciones:
// https://itnext.io/building-a-calculator-app-in-flutter-824254704fe6
// https://medium.com/@ykaito21/how-to-build-a-simple-calculator-app-with-flutter-part-1-e43943d016a8
// ✅ Cambiar los colores por los oficiales
// ✅ Poner los íconos oficiales
// ✅ Terminar el proceso de venta (Efectivo o tarjeta)
//

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          Constants.PRIMARY_COLOR,
          Constants.APP_MATERIAL_COLOR,
        ),
        splashColor: Color(Constants.SECONDARY_COLOR),
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
