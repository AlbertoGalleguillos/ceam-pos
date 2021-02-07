import 'package:flutter/material.dart';

// URL's
const String BASE_URL = 'https://ceamspa.cl/pos/services/app/v1';
const String CEAM_LOGO_PATH = 'assets/images/logo-ceam.png';


// Strings
const String APP_NAME = 'CEAM POS';
const String DEFAULT_SALE_TEXT = 'VENTA ABARROTES';
const String LOGIN_ACTION_TEXT = 'Iniciar sesión';
const String MENU_GENERATE_INVOICE = 'Generar Boleta';
const String MENU_SALES_REPORT = 'Informe de Ventas';
const String MENU_REPRINT = 'Reimprimir última boleta';
const String MENU_PRINTER_SETTINGS = 'Configurar impresora';
const String MENU_OTHER_SETTINGS = 'Otras configuraciones';
const String MENU_LOGOUT = 'Cerrar sesión';
const String PAYMENT_TYPE_DEBIT = 'Tarjeta Debito';
const String PAYMENT_TYPE_CASH = 'Efectivo';
const String PAYMENT_TYPE_CREDIT = 'Tarjeta Credito';
const String PRINTER_CONNECTED = 'Su impresora está conectada';
const String PRINTER_DISCONNECTED = 'Su impresora no está conectada';
const String SETTINGS_DEBIT_BUTTON_ENABLED = 'Botón activado correctamente';
const String SETTINGS_DEBIT_BUTTON_DISABLED = 'Botón desactivado correctamente';
const String SETTINGS_DEBIT_BUTTON_TITLE = 'Botón tarjeta débito';
const String SETTINGS_DEBIT_BUTTON_SUBTITLE = 'Active o desactive el botón de tarjeta de débito';


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
