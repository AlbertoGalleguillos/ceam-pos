import 'package:flutter/widgets.dart';
import 'package:ceam_pos/calculator-key.dart';

class KeyPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            CalculatorKey(symbol: Keys.clear),
            CalculatorKey(symbol: Keys.backspace),
          ],
        ),
        Row(
          children: <Widget>[
            CalculatorKey(symbol: Keys.seven),
            CalculatorKey(symbol: Keys.eight),
            CalculatorKey(symbol: Keys.nine),
            CalculatorKey(symbol: Keys.multiply),
          ],
        ),
        Row(
          children: <Widget>[
            CalculatorKey(symbol: Keys.four),
            CalculatorKey(symbol: Keys.five),
            CalculatorKey(symbol: Keys.six),
            CalculatorKey(symbol: Keys.subtract),
          ],
        ),
        Row(
          children: <Widget>[
            CalculatorKey(symbol: Keys.one),
            CalculatorKey(symbol: Keys.two),
            CalculatorKey(symbol: Keys.three),
            CalculatorKey(symbol: Keys.add),
          ],
        ),
        Row(
          children: <Widget>[
            CalculatorKey(symbol: Keys.zero),
            CalculatorKey(symbol: Keys.doubleZero),
            CalculatorKey(symbol: Keys.equals),
          ],
        ),
      ],
    );
  }
}