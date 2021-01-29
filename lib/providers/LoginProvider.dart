import 'dart:convert';

import 'package:ceam_pos/models/company.dart';
import 'package:flutter/widgets.dart';

class LoginProvider extends ChangeNotifier {
  Company company;

  setCompany(json) {
    company = Company.fromJson(jsonDecode(json));
    notifyListeners();
  }
}