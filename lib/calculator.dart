import 'package:ceam_pos/calculator-key.dart';
import 'package:ceam_pos/display.dart';
import 'package:ceam_pos/key-symbol.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const OUTPUT_DEFAULT_VALUE = '0';
  static const RESULT_DEFAULT_VALUE = '';

  String _output = OUTPUT_DEFAULT_VALUE;
  String _result = RESULT_DEFAULT_VALUE;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    double buttonSize = screen.width / 4;
    double displayHeight =
        screen.height - (buttonSize * 5) - (buttonSize) - 128;
    displayHeight = displayHeight / 2;

    return Scaffold(
      backgroundColor: Color.fromARGB(196, 32, 64, 96),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Display(value: _output, height: displayHeight),
          Display(value: _result, height: displayHeight),
          Column(
            children: [
              Row(
                children: <Widget>[
                  CalculatorKey(
                    symbol: Keys.clear,
                    onPressed: () => onPressed(Keys.clear),
                  ),
                  CalculatorKey(
                    symbol: Keys.backspace,
                    onPressed: () => onPressed(Keys.backspace),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorKey(
                    symbol: Keys.seven,
                    onPressed: () => onPressed(Keys.seven),
                  ),
                  CalculatorKey(
                    symbol: Keys.eight,
                    onPressed: () => onPressed(Keys.eight),
                  ),
                  CalculatorKey(
                    symbol: Keys.nine,
                    onPressed: () => onPressed(Keys.nine),
                  ),
                  CalculatorKey(
                    symbol: Keys.multiply,
                    onPressed: () => onPressed(Keys.multiply),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorKey(
                    symbol: Keys.four,
                    onPressed: () => onPressed(Keys.four),
                  ),
                  CalculatorKey(
                    symbol: Keys.five,
                    onPressed: () => onPressed(Keys.five),
                  ),
                  CalculatorKey(
                    symbol: Keys.six,
                    onPressed: () => onPressed(Keys.six),
                  ),
                  CalculatorKey(
                    symbol: Keys.subtract,
                    onPressed: () => onPressed(Keys.subtract),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorKey(
                    symbol: Keys.one,
                    onPressed: () => onPressed(Keys.one),
                  ),
                  CalculatorKey(
                    symbol: Keys.two,
                    onPressed: () => onPressed(Keys.two),
                  ),
                  CalculatorKey(
                    symbol: Keys.three,
                    onPressed: () => onPressed(Keys.three),
                  ),
                  CalculatorKey(
                    symbol: Keys.add,
                    onPressed: () => onPressed(Keys.add),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorKey(
                    symbol: Keys.zero,
                    onPressed: () => onPressed(Keys.zero),
                  ),
                  CalculatorKey(
                    symbol: Keys.doubleZero,
                    onPressed: () => onPressed(Keys.doubleZero),
                  ),
                  CalculatorKey(
                    symbol: Keys.equals,
                    onPressed: () => onPressed(Keys.equals),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onPressed(KeySymbol symbol) {
    switch (symbol) {
      case Keys.clear:
        reset();
        break;
      case Keys.backspace:
        backspace();
        break;
      case Keys.equals:
        setTotal();
        break;
      default:
        addValue(symbol);
    }
  }

  void addValue(KeySymbol symbol) {
    commitTotal(OUTPUT_DEFAULT_VALUE);

    final pattern = RegExp(r'\+|-|x');
    bool hasOperator = _output.contains(pattern);

    if (_output.isNotEmpty && !hasOperator && int.tryParse(_output) == 0) {
      setState(() => _output = symbol.value);
      return;
    }

    setState(() => _output += symbol.value);
    checkDoubleOperator(symbol);
    checkSubTotal();
  }

  void checkDoubleOperator(KeySymbol symbol) {
    final pattern = RegExp(r'[\+|\-|x]{2}$');
    bool hasDoubleOperator = _output.contains(pattern);

    if (hasDoubleOperator) {
      _output = _output.substring(0, _output.length - 2);
      setState(() => _output += symbol.value);
    }
  }

  void checkSubTotal() {
    final hasOperatorAndEndWithNumberPattern = RegExp(r'(\+|-|x).*\d$');
    bool hasOperatorAndEndWithNumber =
        _output.contains(hasOperatorAndEndWithNumberPattern);

    if (hasOperatorAndEndWithNumber) {
      getTotal();
    } else {
      setState(() => _result = RESULT_DEFAULT_VALUE);
    }
  }

  void backspace() {
    commitTotal(OUTPUT_DEFAULT_VALUE);

    if (_output.length > 0) {
      setState(() {
        _output = _output.substring(0, _output.length - 1);
      });
    } else {
      setState(() => _output = OUTPUT_DEFAULT_VALUE);
    }

    checkSubTotal();
  }

  void getTotal() {
    Expression expression = Parser().parse(_output.replaceAll('x', '*'));
    final result = expression.evaluate(EvaluationType.REAL, null);
    setState(() => _result = result.round().toString());
  }

  void setTotal() {
    if (_result.isNotEmpty) {
      setState(() {
        _output = _result;
        _result = RESULT_DEFAULT_VALUE;
      });
    }
    commitTotal(_output);
  }

  void reset() {
    commitTotal(OUTPUT_DEFAULT_VALUE);

    setState(() {
      _output = OUTPUT_DEFAULT_VALUE;
      _result = RESULT_DEFAULT_VALUE;
    });
  }

  void commitTotal(String amount) {
    PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
    provider.setTotal(amount);
  }
}
