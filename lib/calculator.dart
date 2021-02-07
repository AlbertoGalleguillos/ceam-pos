import 'package:ceam_pos/display.dart';
import 'package:flutter/material.dart';
import 'package:ceam_pos/key-controller.dart';
import 'package:ceam_pos/key-pad.dart';
import 'package:ceam_pos/processor.dart';

class Calculator extends StatefulWidget {

  Calculator({ Key key }) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String _output;

  @override
  void initState() {
    super.initState();

    KeyController.listen((event) => Processor.process(event));
    Processor.listen((data) => setState(() { _output = data; }));
    Processor.refresh();
  }

  @override
  void dispose() {

    KeyController.dispose();
    Processor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size screen = MediaQuery.of(context).size;

    double buttonSize = screen.width / 4;
    double displayHeight = screen.height - (buttonSize * 5) - (buttonSize) - 128;
    // print('buttonSize: $buttonSize');
    // print('displayHeight: $displayHeight');

    return Scaffold(
      backgroundColor: Color.fromARGB(196, 32, 64, 96),
      body: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Display(value: _output, height: displayHeight),
            KeyPad()
          ]
      ),
    );
  }
}