import 'package:ceam_pos/login.dart';
import 'package:ceam_pos/home.dart';
import 'package:ceam_pos/print.dart';
import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:ceam_pos/providers/SettingsProvider.dart';
import 'package:ceam_pos/salesReport.dart';
import 'package:ceam_pos/settings.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
      ChangeNotifierProxyProvider<LoginProvider, PrintProvider>(
        update: (context, login, previousMessages) => PrintProvider(login),
        create: (BuildContext context) => PrintProvider(null),
      ),
    ],
    child: MyApp(),
  ));
}

//TODO: v.0.0.1
// ✅ Imprimir con datos de prueba
// ✅ Imprimir con datos de prueba pero que vengan del objeto empresa
// ✅ Crear pantalla de configuración de impresora
// ✅ Crear calculadora propia, revisar las siguientes implementaciones: (Crear, guiño)
// https://itnext.io/building-a-calculator-app-in-flutter-824254704fe6
// https://medium.com/@ykaito21/how-to-build-a-simple-calculator-app-with-flutter-part-1-e43943d016a8
// ✅ Cambiar los colores por los oficiales
// ✅ Poner los íconos oficiales
// ✅  Terminar el proceso de venta (Efectivo o tarjeta)

//TODO v.0.0.2

// ✅ Agregar Logo en Pantalla de inicio
// ✅ Agregar Logo en Menú lateral
// - Que los pagos con débito no generen boleta, solo la venta
// ✅ Agregar Configuración para que pueda elegir entre un solo botón de impresión o dos (débito y factura)
// ✅ La opción de solo un botón es la que viene por defecto.
// ✅ Agregar ícono en los botones de forma de pago.
// - Agregar subtotal en la calculadora.
// - Hacer que el botón "<-" borre un solo caracter.
// - Hacer que los botones de operadores generen un subtotal al ser presionados.
// ✅ Agregar instructivo en la configuración de la impresora. En la sección de configuración de impresora.
// - Hacer funcionar el botón para reimprimir boletas
// ✅ Dejar el componente de AppBar en todas las pantallas

// Bugs conocidos
// No existe un mensaje de error al fallar la conexión a la impresora.
// ✅ Corregir navegación, se quedan abiertas las pantallas y es raro el historial.
// Poner el mismo color de fondo en todas partes
// ✅ Hacer que el botón de "Impresión de prueba" dependa de la conexión general de la impresora
// ✅ Hacer que el elemento seleccionado de bluethoth y su conexión se ven reflejados en la pantalla de configuración
// Solucionar error "Stream has already been listened to." (Al volver a cargal el home)
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
        Settings.route: (context) => Settings(),
      },
    );
  }
}
