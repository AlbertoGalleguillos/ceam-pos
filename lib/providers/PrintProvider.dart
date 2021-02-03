import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ceam_pos/models/company.dart';
import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:barcode/barcode.dart';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as DartImage;

class PrintProvider extends ChangeNotifier {
  final LoginProvider loginProvider;

  PrintProvider(this.loginProvider);

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  int total = 0;

  setTotal(String newTotal) {
    total = int.parse(newTotal);
    notifyListeners();
  }

  connect(device) {
    bluetooth.connect(device).catchError((error) {
      print('An error ocurrs when trying to connect bluethoot printer');
    });
    notifyListeners();
  }

  testPrint() {
    //SIZE
    const NORMAL_TEXT = 0;
    const BOLD_SMALL_TEXT = 1;
    const BOLD_MEDIUM_TEXT = 2;
    const BOLD_LARGE_TEXT = 3;
    //ALIGN
    const ESC_ALIGN_LEFT = 0;
    const ESC_ALIGN_CENTER = 1;
    const ESC_ALIGN_RIGHT = 2;
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        Company company = loginProvider.company;

        final barcode = Barcode.pdf417();
        final svg = barcode.toSvg(
          'data',
          width: 200,
          height: 80,
        );

        // Save the image
        // Directory tempDir = await getTemporaryDirectory();
        Directory tempDir = await getApplicationDocumentsDirectory();
        final filename =
            barcode.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
        final filepath = '${tempDir.path}/barcode.png';
        File(filepath).writeAsStringSync(svg);

        final image = DartImage.Image(400, 130);

        // Fill it with a solid color (white)
        DartImage.fill(image, DartImage.getColor(255, 255, 255));

        final xmlTestString = '''<?xml version="1.0"?>
            <RECEPCIONDTE>
      <RUTSENDER>13657077-3</RUTSENDER>
      <RUTCOMPANY>77127713-6</RUTCOMPANY>
      <FILE>archivo</FILE>
      <TIMESTAMP>2021-01-30 23: 38: 46</TIMESTAMP>
      <STATUS>0</STATUS>
      <TRACKID>0107418640</TRACKID>
      </RECEPCIONDTE>''';

        // Draw the barcode
        drawBarcode(image, Barcode.pdf417(), xmlTestString);

        // Save the image
        File(filepath).writeAsBytesSync(DartImage.encodePng(image));

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

  printInvoice({int invoiceNumber}) {
    final factor = 19;
    final taxes = (total * factor / (100 + factor)).round();

    NumberFormat format = NumberFormat('\$ ###,###,###');
    final formattedAmount = format.format(total);
    final formattedTaxes = format.format(taxes);

    //SIZE
    const NORMAL_TEXT = 0;
    const BOLD_SMALL_TEXT = 1;
    const BOLD_MEDIUM_TEXT = 2;
    const BOLD_LARGE_TEXT = 3;
    //ALIGN
    const ESC_ALIGN_LEFT = 0;
    const ESC_ALIGN_CENTER = 1;
    const ESC_ALIGN_RIGHT = 2;
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
            "Fecha Emision 22-01-2021", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TOTAL:", formattedAmount, NORMAL_TEXT);
        bluetooth.printNewLine();
        bluetooth.printCustom('El IVA de esta boleta es $formattedTaxes',
            NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }
}
