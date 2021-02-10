import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final String value;
  final double height;

  Display({Key key, this.value, this.height}) : super(key: key);

  String get _output => value.toString();

  double get _margin => (height / 10);

  final LinearGradient _gradient =
      const LinearGradient(colors: [Colors.black26, Colors.black45]);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .headline3
        .copyWith(color: Colors.white, fontWeight: FontWeight.w200);

    return Container(
      constraints: BoxConstraints.expand(height: height),
      child: Container(
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints.expand(height: height - (_margin)),
        decoration: BoxDecoration(gradient: _gradient),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Text(
            _output,
            style: style,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}
