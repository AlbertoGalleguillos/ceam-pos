import 'package:ceam_pos/PosDrawer.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

class Home extends StatefulWidget {
  Home({Key key, this.title = Constants.APP_NAME}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: PosDrawer(),
      body: Center(
        child: Text('Here goes calculator'),
      ),
    );
  }
}
