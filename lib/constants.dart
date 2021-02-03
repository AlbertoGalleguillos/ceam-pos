import 'package:flutter/material.dart';

// Services
const String BASE_URL = 'https://ceamspa.cl/pos/services/app/v1';

// Strings
const String APP_NAME = 'CEAS POS';
const String DEFAULT_SALE_TEXT = 'VENTA ABARROTES';
const String MENU_GENERATE_INVOICE = 'Generar Boleta';
const String MENU_SALES_REPORT = 'Informe de Ventas';
const String MENU_REPRINT = 'Reimprimir última boleta';
const String MENU_PRINTER_SETTINGS = 'Configurar impresora';
const String MENU_LOGOUT = 'Cerrar sesión';
const String PAYMENT_TYPE_DEBIT = 'Tarjeta Debito';
const String PAYMENT_TYPE_CASH = 'Efectivo';
const String PAYMENT_TYPE_CREDIT = 'Tarjeta Credito';

// Colors
const int PRIMARY_COLOR = 0xff20248c;
const int SECONDARY_COLOR = 0xff98d7cd;
const Map<int, Color> APP_MATERIAL_COLOR = {
  50: Color.fromRGBO(32, 36, 140, .1),
  100: Color.fromRGBO(32, 36, 140, .2),
  200: Color.fromRGBO(32, 36, 140, .3),
  300: Color.fromRGBO(32, 36, 140, .4),
  400: Color.fromRGBO(32, 36, 140, .5),
  500: Color.fromRGBO(32, 36, 140, .6),
  600: Color.fromRGBO(32, 36, 140, .7),
  700: Color.fromRGBO(32, 36, 140, .8),
  800: Color.fromRGBO(32, 36, 140, .9),
  900: Color.fromRGBO(32, 36, 140, 1),
};
