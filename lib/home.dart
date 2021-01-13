import 'package:ceam_pos/PosDrawer.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as Constants;
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title = Constants.APP_NAME}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: PosDrawer(),
      body: Column(
        children: [
          Container(
            height: 600,
            child: SimpleCalculator(
              hideSurroundingBorder: true,
            ),
          ),
          SizedBox(
            height: 97,
            width: double.infinity,
            child: ElevatedButton(
              child: Text('Generar Boleta'),
              onPressed: () {
                print('Generate invoice');
              },
            ),
          )
        ],
      ),
    );
  }
}
