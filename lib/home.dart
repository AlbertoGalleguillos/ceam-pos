import 'package:ceam_pos/PosAppBar.dart';
import 'package:ceam_pos/PosDrawer.dart';
import 'package:ceam_pos/calculator.dart';
import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:ceam_pos/providers/SettingsProvider.dart';
import 'package:ceam_pos/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static final String route = '/home';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  bool isPrinterConnected = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double buttonHeight = 100;
    final double appBarHeight = 111;
    final double calculatorHeight = height - buttonHeight - appBarHeight;

    checkBlutethotisConected();

    final isDebitEnable = Provider.of<SettingsProvider>(context).isDebitEnable;
    final buttonWidth = isDebitEnable
        ? MediaQuery.of(context).size.width / 2 - 16
        : MediaQuery.of(context).size.width / 1 - 16;

    bool isValidAmount = Provider.of<PrintProvider>(context).isValidAmount();
    bool canPrint = isPrinterConnected && isValidAmount;

    return Scaffold(
      // backgroundColor: Color(Constants.SECONDARY_COLOR),
      backgroundColor: Color.fromARGB(196, 32, 64, 96),
      appBar: posAppBar(),
      drawer: PosDrawer(),
      body: Column(
        children: [
          Container(
            height: calculatorHeight,
            child: Calculator(), // Calculator
          ),
          SizedBox(
            height: buttonHeight,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isDebitEnable)
                    SizedBox(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.credit_card),
                        label: Text('Débito'),
                        onPressed: canPrint
                            ? () => makeSale(PaymentType.debit, context)
                            : null,
                      ),
                    ),
                  SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.attach_money),
                      label: Text('Efectivo'),
                      onPressed: canPrint
                          ? () => makeSale(PaymentType.cash, context)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkBlutethotisConected() async {
    final provider = Provider.of<PrintProvider>(context);
    final isConnected = await provider.bluetooth.isConnected;
    setState(() => isPrinterConnected = isConnected);
    provider.setConnectionStatus(isConnected);
  }
}

// Make sales
void makeSale(PaymentType paymentType, BuildContext context) async {
  final invoiceNumber = await createSale(paymentType);
  createInvoice(paymentType, invoiceNumber);

  if (paymentType == PaymentType.cash) {
    // The getSign service take too long to finish
    await Future.delayed(Duration(milliseconds: 500));
    final sign = await getSign(invoiceNumber);
    printInvoice(invoiceNumber, sign, context);
    saveLastInvoice(paymentType, invoiceNumber, sign, context);
  } else {
    // print('Show invoice');
    saveLastInvoice(paymentType, invoiceNumber, '', context);
    showInvoiceDialog(context);
  }
}

Future<void> showInvoiceDialog(BuildContext context) async {
  final lastInvoice =
      Provider.of<PrintProvider>(context, listen: false).lastInvoice;

  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Boleta registrada'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Se ha generado su boleta N. ${lastInvoice.number} correctamente\n'),
              Text('Forma de pago: ${lastInvoice.paymentType.description}'),
              Text('Fecha: ${lastInvoice.date}'),
              Text('Monto: ${lastInvoice.amount}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void printInvoice(int invoiceNumber, String sign, BuildContext context) {
  PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
  provider.printInvoice(invoiceNumber: invoiceNumber, sign: sign);
}

void saveLastInvoice(
  PaymentType paymentType,
  int number,
  String sign,
  BuildContext context,
) {
  PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
  provider.saveLastInvoice(number, paymentType, sign);
}
