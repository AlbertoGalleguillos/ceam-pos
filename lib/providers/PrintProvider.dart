import 'dart:convert';
import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/models/Invoice.dart';
import 'package:ceam_pos/models/company.dart';
import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:barcode/barcode.dart';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as DartImage;
import 'package:shared_preferences/shared_preferences.dart';

class PrintProvider extends ChangeNotifier {
  static const LAST_INVOICE_KEY = 'LAST_INVOICE_KEY';
  final LoginProvider loginProvider;

  PrintProvider(this.loginProvider) {
    getLastInvoice();
  }

  //SIZE
  static const NORMAL_TEXT = 0;
  static const BOLD_SMALL_TEXT = 1;
  static const BOLD_MEDIUM_TEXT = 2;
  static const BOLD_LARGE_TEXT = 3;

  //ALIGN
  static const ESC_ALIGN_LEFT = 0;
  static const ESC_ALIGN_CENTER = 1;
  static const ESC_ALIGN_RIGHT = 2;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  int total = 0;
  bool isConnected = false;
  Invoice lastInvoice;
  SharedPreferences preferences;

  getLastInvoice() async {
    preferences = await SharedPreferences.getInstance();
    final jsonInvoice = preferences.getString(LAST_INVOICE_KEY) ?? '';

    if (jsonInvoice.isNotEmpty) {
      lastInvoice = Invoice.fromJson(json.decode(jsonInvoice));
      notifyListeners();
    }
  }

  saveLastInvoice(int number, PaymentType paymentType, String sign) {
    final currentDate = DateTime.now();

    Invoice invoice = Invoice()
      ..number = number
      ..paymentType = paymentType
      ..date = DateFormat('dd-MM-yyyy').format(currentDate)
      ..amount = total
      ..sign = sign;

    print('saving Invoice');
    preferences.setString(LAST_INVOICE_KEY, json.encode(invoice.toJson()));
    lastInvoice = invoice;
    notifyListeners();
  }

  bool isValidAmount() {
    return total > 0;
  }

  setTotal(String newTotal) {
    total = int.parse(newTotal);
    notifyListeners();
  }

  setConnectionStatus(bool value) {
    isConnected = value;
    notifyListeners();
  }

  connect(device) async {
    await bluetooth.connect(device).catchError((error) {
      throw ('Ocurrió un error al tratar de conectarse a la impresora bluethoot. Verifique que la impresora este encendida');
    });
    notifyListeners();
  }

  testPrint() {
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        Company company = loginProvider.company;

        final xmlTestString = '''<?xml version="1.0"?>
            <RECEPCIONDTE>
      <RUTSENDER>13657077-3</RUTSENDER>
      <RUTCOMPANY>77127713-6</RUTCOMPANY>
      <FILE>archivo</FILE>
      <TIMESTAMP>2021-01-30 23: 38: 46</TIMESTAMP>
      <STATUS>0</STATUS>
      <TRACKID>0107418640</TRACKID>
      </RECEPCIONDTE>''';

        final filepath = await createSignImage(xmlTestString);

        final lineSize = 32;
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'R.U.T.: ${company.rut}', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'Boleta electronica', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('No. 466', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('S.I.I. Santiago', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printCustom(company.name, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.sector, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.address, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(
            "Fecha Emision 22-01-2021", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TOTAL:", "\$ 30.000", NORMAL_TEXT);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            'El IVA de esta boleta es \$ 4.790', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printImage(filepath);
        bluetooth.printNewLine();
        bluetooth.printCustom('Timbre S.I.I.', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            'Impresion de prueba', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'No valido como boleta', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }

  printInvoice({int invoiceNumber, String sign}) async {
    final factor = 19;
    final taxes = (total * factor / (100 + factor)).round();

    NumberFormat format = NumberFormat('\$###,###,###');
    final formattedAmount = format.format(total);
    final formattedTaxes = format.format(taxes);

    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

    final filepath = await createSignImage(sign);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        Company company = loginProvider.company;

        final lineSize = 32;
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'R.U.T.: ${company.rut}', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'Boleta electronica', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'No. $invoiceNumber', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('S.I.I. Santiago', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printCustom(company.name, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.sector, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.address, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(
            "Fecha Emision $formattedDate", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TOTAL:", formattedAmount, NORMAL_TEXT);
        bluetooth.printNewLine();
        bluetooth.printCustom('El IVA de esta boleta es $formattedTaxes',
            NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printImage(filepath);
        bluetooth.printNewLine();
        bluetooth.printCustom('Timbre S.I.I.', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }

  printLastInvoice() async {
    final factor = 19;
    final taxes = (lastInvoice.amount * factor / (100 + factor)).round();

    NumberFormat format = NumberFormat('\$###,###,###');
    final formattedAmount = format.format(lastInvoice.amount);
    final formattedTaxes = format.format(taxes);

    final filepath = await createSignImage(lastInvoice.sign);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        Company company = loginProvider.company;

        final lineSize = 32;
        bluetooth.printCustom(
            'Esta es una copia', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'R.U.T.: ${company.rut}', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'Boleta electronica', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom(
            'No. ${lastInvoice.number}', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('S.I.I. Santiago', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printCustom(company.name, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.sector, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(company.address, NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom(
            "Fecha Emision ${lastInvoice.date}", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TOTAL:", formattedAmount, NORMAL_TEXT);
        bluetooth.printNewLine();
        bluetooth.printCustom('El IVA de esta boleta es $formattedTaxes',
            NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printImage(filepath);
        bluetooth.printNewLine();
        bluetooth.printCustom('Timbre S.I.I.', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();

      }
    });
  }

  Future<String> createSignImage(String sign) async {
    final barcode = Barcode.pdf417();
    final svg = barcode.toSvg(
      'data',
      width: 200,
      height: 80,
    );

    // Save the image
    Directory tempDir = await getApplicationDocumentsDirectory();
    final filename = barcode.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
    final filepath = '${tempDir.path}/barcode.png';
    File(filepath).writeAsStringSync(svg);

    final image = DartImage.Image(400, 130);

    // Fill it with a solid color (white)
    DartImage.fill(image, DartImage.getColor(255, 255, 255));

    // Draw the barcode
    print('sign $sign');
    drawBarcode(image, Barcode.pdf417(), sign);

    // Save the image
    File(filepath).writeAsBytesSync(DartImage.encodePng(image));

    return filepath;
  }
}
