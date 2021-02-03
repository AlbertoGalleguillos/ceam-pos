import 'package:ceam_pos/home.dart';
import 'package:ceam_pos/print.dart';
import 'package:ceam_pos/salesReport.dart';
import 'package:flutter/material.dart';

import 'package:ceam_pos/constants.dart' as Constants;

class PosDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: const Center(
              child: const Text(
                Constants.APP_NAME,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(Constants.PRIMARY_COLOR),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text(Constants.MENU_GENERATE_INVOICE),
            onTap: () {
              Navigator.of(context).pushNamed(Home.route);
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
              unAvailableSection(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.print),
            title: Text(Constants.MENU_PRINTER_SETTINGS),
            onTap: () {
              Navigator.of(context).pushNamed(PrinterApp.route);
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

  void unAvailableSection(BuildContext context) {
    final String notAvailable = 'Función no disponible...';
    final snackBar = SnackBar(
      content: Text(notAvailable),
      action: SnackBarAction(
        label: 'Todavía !',
        onPressed: () {},
      ),
    );
    // TODO: change deprecated methods https://flutter.dev/docs/release/breaking-changes/scaffold-messenger
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
}
