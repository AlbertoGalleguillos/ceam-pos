import 'dart:convert';

import 'package:ceam_pos/PosDrawer.dart';
import 'package:ceam_pos/customCalculator.dart';
import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart' as Constants;
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static final String route = '/home';

  Home({Key key, this.title = Constants.APP_NAME}) : super(key: key);

  final String title;

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

    return Scaffold(
      backgroundColor: Color(Constants.SECONDARY_COLOR),
      appBar: AppBar(
        title: Text(Constants.APP_NAME),
        actions: [
          IconButton(
              icon: isPrinterConnected
                  ? Icon(Icons.print)
                  : Icon(Icons.print_disabled),
              onPressed: () {
                print('Su impresora está conectada $isPrinterConnected');
              }),
        ],
      ),
      drawer: PosDrawer(),
      body: Column(
        children: [
          Container(
            height: calculatorHeight,
            child: HomePage(), // Calculator
          ),
          SizedBox(
            height: buttonHeight,
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: buttonHeight,
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      child: ElevatedButton(
                        child: Text('Débito'),
                        onPressed: isPrinterConnected
                            ? () => makeSale(PaymentType.debit, context)
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: buttonHeight,
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      child: ElevatedButton(
                        child: Text('Efectivo'),
                        onPressed: isPrinterConnected
                            ? () => makeSale(PaymentType.cash, context)
                            : null,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  checkBlutethotisConected() async {
    final bluetooth = Provider.of<PrintProvider>(context).bluetooth;
    final isConnected = await bluetooth.isConnected;
    // if (isPrinterConnected != isConnected) {
    setState(() => isPrinterConnected = isConnected);
    // }
    // print('Bluethoot: isConnected $isPrinterConnected');
  }
}

// Make sales
void makeSale(PaymentType paymentType, BuildContext context) async {
  final invoiceNumber = await createSale(paymentType);
  print('Generating sale for folio: $invoiceNumber');
  createInvoice(paymentType, invoiceNumber);
  printInvoice(invoiceNumber, context);
}

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

void printInvoice(int invoiceNumber, BuildContext context) {
  PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
  provider.printInvoice(invoiceNumber: invoiceNumber);
}
