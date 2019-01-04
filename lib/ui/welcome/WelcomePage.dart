import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState([
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Other Device", "01:02:03:04:05:06", "4a14c657-e073-4432-a633-487233362fb2"),
    ]);
  }
}

class WelcomePageState extends State<WelcomePage> {

  //FlutterBlue _flutterBlue = FlutterBlue.instance;

  var _devices = <GenericBTDevice>[];

  WelcomePageState(List<GenericBTDevice> initialDevices){
    _devices.addAll(initialDevices);
  }

  @override
  Widget build(BuildContext context) {

    // var _scan = _flutterBlue.scan().listen((result) {
    //   print("lol we found something");
    // });

    return Scaffold(
        appBar: AppBar(title: Text("Connect to a device")),
        body: ListView.builder(
          itemBuilder: (BuildContext c, int i) { return buildRow(c, i); },
          itemCount: _devices.length,)
      );
  }
  
  Widget buildRow(BuildContext context, int index) {
    return ListTile(title: Text(_devices[index].name), subtitle: Text(_devices[index].address),);
  }
}