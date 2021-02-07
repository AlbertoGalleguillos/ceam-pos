import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String IS_DEBIT_AVAILABLE_KEY = 'IS_DEBIT_AVAILABLE_KEY';
  static const bool IS_DEBIT_AVAILABLE_DEFAULT_VALUE = false;

  bool isDebitEnable = IS_DEBIT_AVAILABLE_DEFAULT_VALUE;
  SharedPreferences prefs;

  SettingsProvider() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    isDebitEnable = prefs.getBool(IS_DEBIT_AVAILABLE_KEY) ??
        IS_DEBIT_AVAILABLE_DEFAULT_VALUE;
    notifyListeners();
  }

  setIsDebitEnable(bool value) {
    prefs.setBool(IS_DEBIT_AVAILABLE_KEY, value);
    isDebitEnable = value;
    notifyListeners();
  }
}
