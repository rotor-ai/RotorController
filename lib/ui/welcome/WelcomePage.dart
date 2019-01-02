import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {


    var _scan = _flutterBlue.scan().listen((result) {
      print("lol we found something");
    });

    return Scaffold(
        appBar: AppBar(title: Text("Connect to a device")),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {return _buildDeviceTile("Something");}, 
          itemCount: 1,)
      );
  }

  Widget _buildDeviceTile(String title) {
    return ListTile(title: Text(title),);
  }

}