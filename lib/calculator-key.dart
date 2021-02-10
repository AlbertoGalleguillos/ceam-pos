import 'package:flutter/material.dart';
import 'package:ceam_pos/key-controller.dart';
import 'package:ceam_pos/key-symbol.dart';
import 'package:ceam_pos/constants.dart' as Constants;

abstract class Keys {
  static const KeySymbol clear = const KeySymbol('C');
  static const KeySymbol backspace = const KeySymbol('backspace');
  static const KeySymbol sign = const KeySymbol('±');
  static const KeySymbol percent = const KeySymbol('%');
  static const KeySymbol divide = const KeySymbol('÷');
  static const KeySymbol multiply = const KeySymbol('x');
  static const KeySymbol subtract = const KeySymbol('-');
  static const KeySymbol add = const KeySymbol('+');
  static const KeySymbol equals = const KeySymbol('=');
  static const KeySymbol decimal = const KeySymbol('.');

  static const KeySymbol doubleZero = const KeySymbol('00');
  static const KeySymbol zero = const KeySymbol('0');
  static const KeySymbol one = const KeySymbol('1');
  static const KeySymbol two = const KeySymbol('2');
  static const KeySymbol three = const KeySymbol('3');
  static const KeySymbol four = const KeySymbol('4');
  static const KeySymbol five = const KeySymbol('5');
  static const KeySymbol six = const KeySymbol('6');
  static const KeySymbol seven = const KeySymbol('7');
  static const KeySymbol eight = const KeySymbol('8');
  static const KeySymbol nine = const KeySymbol('9');
}

class CalculatorKey extends StatelessWidget {
  CalculatorKey({this.symbol, this.onPressed});

  final KeySymbol symbol;
  final VoidCallback onPressed;

  Color get color {
    switch (symbol.type) {
      case KeyType.FUNCTION:
      case KeyType.OPERATOR:
        return Color(Constants.PRIMARY_COLOR);

      case KeyType.INTEGER:
      default:
        return Color.fromARGB(255, 128, 128, 128);
    }
  }

  static dynamic _fire(CalculatorKey key) => KeyController.fire(KeyEvent(key));

  @override
  Widget build(BuildContext context) {
    const Color keysColor = Colors.white;
    double size = MediaQuery.of(context).size.width / 4;
    TextStyle style =
        Theme.of(context).textTheme.headline4.copyWith(color: keysColor);

    return Container(
      width: getSpan(symbol) * size,
      padding: EdgeInsets.all(2),
      height: size,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: color,
        elevation: 4,
        child: symbol == Keys.backspace
            ? Icon(Icons.backspace_outlined, color: keysColor)
            : Text(symbol.value, style: style),
        onPressed: onPressed,
      ),
    );
  }

  int getSpan(KeySymbol keySymbol) {
    const CLEAR_SIZE = 3;
    const ZERO_SIZE = 2;
    const DEFAULT_SIZE = 1;

    switch (keySymbol) {
      case Keys.clear:
        return CLEAR_SIZE;
      case Keys.zero:
        return ZERO_SIZE;
      default:
        return DEFAULT_SIZE;
    }
  }
}
