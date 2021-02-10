import 'dart:convert';

import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/constants.dart' as Constants;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<int> createSale(PaymentType paymentType) async {
  String createSaleUrl = '${Constants.BASE_URL}/creaVenta/';

  final mapBody = <String, String>{
    'idEmpresa': "a31f3cdf-01ee-11eb-8ea0-d71e11fcbec0",
    // TODO: Change to idEmpresa
    'total': "7000",
    // TODO: Change to total
    'glosa': Constants.DEFAULT_SALE_TEXT,
    'metodoPago': paymentType.description,
  };

  final http.Response response = await http.post(
    createSaleUrl,
    body: jsonEncode(mapBody),
  );

  if (kDebugMode) {
    print('createSale');
    print(mapBody);
    print(response.statusCode);
    print(response.body);
  }

  if (response.statusCode == 200) {
    return int.parse(jsonDecode(response.body)['folio']);
  }

  throw 'Hubo un error creando la venta';
}

void createInvoice(PaymentType paymentType, int invoiceNumber) async {
  String createSaleUrl = '${Constants.BASE_URL}/generaBoleta/';

  final mapBody = <String, String>{
    // Needed for endpoint
    'rutReceptor': "",
    // TODO: Change to idEmpresa
    'idEmpresa': "a31f3cdf-01ee-11eb-8ea0-d71e11fcbec0",
    // TODO: Change to total
    'total': "7000",
    'glosa': Constants.DEFAULT_SALE_TEXT,
    'metodoPago': paymentType.description,
    "folio": invoiceNumber.toString(),
  };

  final http.Response response = await http.post(
    createSaleUrl,
    body: jsonEncode(mapBody),
  );

  if (kDebugMode) {
    print('createInvoice');
    print(mapBody);
    print(response.statusCode);
    print(response.body);
  }

  if (response.statusCode != 200) {
    throw 'Hubo un error creando la boleta';
  }
}

Future<String> getSign(int invoiceNumber) async {
  String getSignUrl = '${Constants.BASE_URL}/retornaXMLcb/';

  final mapBody = <String, String>{
    "folio": invoiceNumber.toString(),
  };

  final http.Response response = await http.post(
    getSignUrl,
    body: jsonEncode(mapBody),
  );

  if (kDebugMode) {
    print('getSign');
    print(mapBody);
    print(response.statusCode);
    print(response.body);
  }

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['xml'];
  }

  throw 'Hubo un error recuperando la firma';
}
