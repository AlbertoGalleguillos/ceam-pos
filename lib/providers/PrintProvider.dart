import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ceam_pos/models/company.dart';
import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PrintProvider extends ChangeNotifier {
  final LoginProvider loginProvider;

  PrintProvider(this.loginProvider);

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

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
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        Company company = loginProvider.company;

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
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }

  printInvoice({int invoiceNumber, int amount = 30000}) {
    final factor = 19;
    final taxes = (amount * factor / (100 + factor)).round();

    NumberFormat format = NumberFormat('\$ ###,###,###');
    final formattedAmount = format.format(amount);
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
        bluetooth.printCustom('El IVA de esta boleta es $formattedTaxes', NORMAL_TEXT,
            ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }
}
