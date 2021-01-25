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
            child: Center(
              child: Text(
                Constants.APP_NAME,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.point_of_sale),
            title: Text('Generar Boleta'),
            onTap: () {
              Navigator.of(context).pushNamed(Home.route);
              // unAvailableSection(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Informe de Ventas'),
            onTap: () {
              Navigator.of(context).pushNamed(SalesReport.route);
              // unAvailableSection(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.cached),
            title: Text('Reimprimir última boleta'),
            onTap: () {
              unAvailableSection(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.print),
            title: Text('Impresión de prueba'),
            onTap: () {
              Navigator.of(context).pushNamed(PrinterApp.route);
              // unAvailableSection(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
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
