import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart' as Constants;

AppBar posAppBar() {
  return AppBar(
    title: Text(Constants.APP_NAME),
    actions: [
      PrinterIcon(),
    ],
  );
}

class PrinterIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<PrintProvider>(context).isConnected;

    return IconButton(
      icon: isConnected
          ? Icon(Icons.print, color: Colors.green)
          : Icon(Icons.print_disabled, color: Colors.red),
      onPressed: () {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(isConnected
                ? Constants.PRINTER_CONNECTED
                : Constants.PRINTER_DISCONNECTED),
          ),
        );
      },
    );
  }
}
