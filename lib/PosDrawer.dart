import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/home.dart';
import 'package:ceam_pos/models/Invoice.dart';
import 'package:ceam_pos/print.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:ceam_pos/settings.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;
import 'package:provider/provider.dart';

class PosDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Center(
              child: Image.asset(Constants.CEAM_LOGO_PATH),
            ),
            decoration: const BoxDecoration(
              color: Color(Constants.PRIMARY_COLOR),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text(Constants.MENU_GENERATE_INVOICE),
            onTap: () {
              Navigator.of(context).popAndPushNamed(Home.route);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.account_balance),
          //   title: Text(Constants.MENU_SALES_REPORT),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(SalesReport.route);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.cached),
            title: const Text(Constants.MENU_REPRINT),
            onTap: () {
              printLastInvoice(context);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text(Constants.MENU_PRINTER_SETTINGS),
            onTap: () {
              Navigator.of(context).popAndPushNamed(PrinterApp.route);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(Constants.MENU_OTHER_SETTINGS),
            onTap: () {
              Navigator.of(context).popAndPushNamed(Settings.route);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(Constants.MENU_LOGOUT),
            onTap: () {
              // TODO: clear user data, when gets
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void printLastInvoice(BuildContext context) {
    PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
    Invoice lastInvoice = provider.lastInvoice;

    if (lastInvoice == null) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(Constants.NOT_INVOICE_AVAILABLE)),
      );
      Navigator.pop(context);
      return;
    }

    if (lastInvoice.paymentType == PaymentType.debit) {
      showLastInvoiceDialog(context);
    }

    if (lastInvoice.paymentType == PaymentType.cash) {
      provider.printLastInvoice();
    }

  }

  Future<void> showLastInvoiceDialog(BuildContext context) async {
    final lastInvoice =
        Provider.of<PrintProvider>(context, listen: false).lastInvoice;

    Navigator.pop(context);

    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Boleta registrada'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('La última boleta generada correctamente es la N. ${lastInvoice.number}\n'),
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
}
