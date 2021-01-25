import 'package:ceam_pos/PosDrawer.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

class SalesReport extends StatelessWidget {
  static final String route = '/sales-report';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.APP_NAME),
        ),
        drawer: PosDrawer(),
        body: SizedBox.expand(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Monto'), numeric: true),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('01-01-2020')),
                DataCell(Text('\$13.400.-')),
              ]),
              DataRow(cells: [
                DataCell(Text('02-01-2020')),
                DataCell(Text('\$7.400.-')),
              ]),
              DataRow(cells: [
                DataCell(Text('03-01-2020')),
                DataCell(Text('\$45.550.-')),
              ]),
              DataRow(cells: [
                DataCell(
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(Text('\$66.350.-')),
              ]),
            ],
          ),
        ));
  }
}
