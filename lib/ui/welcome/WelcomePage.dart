import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        alignment: Alignment.center,
        child: Text("Connect to a vehicle", textScaleFactor: 1.75,))
      
    ]);
  }
}