import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:ceam_pos/constants.dart' as Constants;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '';

// Array of button
  final List<String> buttons = [
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    'Sup',
    '0',
    '00',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  // Clear Button
                  // if (index == 15) {
                  //   return MyButton(
                  //     buttontapped: () {
                  //       setState(() {
                  //         userInput = '';
                  //         answer = '0';
                  //       });
                  //     },
                  //     buttonText: buttons[index],
                  //     color: Colors.blue[50],
                  //     textColor: Colors.black,
                  //   );
                  // }

                  // Delete Button
                  if (index == 12) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userInput =
                              userInput.substring(0, userInput.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Color(Constants.SECONDARY_COLOR),
                      textColor: Colors.black,
                    );
                  }

                  // Equal_to Button
                  else if (index == 15) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: Color(Constants.PRIMARY_COLOR),
                      textColor: Colors.white,
                    );
                  }

                  // other buttons
                  else {
                    return MyButton(
                      buttonTapped: () {
                        if (hasOperator(userInput) &&
                            isOperator(buttons[index])) {
                          equalPressed();
                          userInput = answer + buttons[index];
                        } else {
                          userInput += buttons[index];
                        }
                        setState(() {});
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Color(Constants.PRIMARY_COLOR)
                          : Colors.white,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.black,
                    );
                  }
                }), // GridView.builder
          ),
        ),
      ],
    );
  }

  bool hasOperator(String string) {
    return string.contains(RegExp(r'/|x|-|\+'));
  }

  bool isOperator(String x) {
    const operators = ['/', 'x', '/', '+', '=', '-'];
    return operators.contains(x);
  }

// function to calculate the input operation
  void equalPressed() {
    String finalUserInput = userInput.replaceAll('x', '*');

    Expression exp = Parser().parse(finalUserInput);
    double eval = exp.evaluate(EvaluationType.REAL, ContextModel());
    answer = eval.round().toString();

    PrintProvider provider = Provider.of<PrintProvider>(context, listen: false);
    provider.setTotal(answer);
  }
}
