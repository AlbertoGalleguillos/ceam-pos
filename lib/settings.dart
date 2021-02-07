import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ceam_pos/PosAppBar.dart';
import 'package:ceam_pos/PosDrawer.dart';
import 'package:ceam_pos/providers/SettingsProvider.dart';
import 'package:ceam_pos/constants.dart' as Constants;

class Settings extends StatelessWidget {
  static final String route = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: posAppBar(),
      drawer: PosDrawer(),
      body: ListView(
        children: <Widget>[
          SwitchDebit(),
        ],
      ),
    );
  }
}

class SwitchDebit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

    return Card(
      child: SwitchListTile(
        // secondary: const Icon(Icons.credit_card),
        title: const Text(Constants.SETTINGS_DEBIT_BUTTON_TITLE),
        subtitle: const Text(Constants.SETTINGS_DEBIT_BUTTON_SUBTITLE),
        isThreeLine: true,
        value: provider.isDebitEnable,
        onChanged: (bool value) {
          provider.setIsDebitEnable(value);
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                provider.isDebitEnable
                    ? Constants.SETTINGS_DEBIT_BUTTON_ENABLED
                    : Constants.SETTINGS_DEBIT_BUTTON_DISABLED,
              ),
            ),
          );
        },
      ),
    );
  }
}
