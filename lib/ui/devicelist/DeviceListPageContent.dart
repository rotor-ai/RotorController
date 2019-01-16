import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceListPageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeviceListPageContentState([
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),
      GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2"),

      GenericBTDevice("Some Other Device", "01:02:03:04:05:06", "4a14c657-e073-4432-a633-487233362fb2")
    ]);
  }
}

class DeviceListPageContentState extends State<DeviceListPageContent> {

  final List<GenericBTDevice> _devices;
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _bluetoothIsSupported = true;

  DeviceListPageContentState(this._devices){
    _flutterBlue.isAvailable.then(
        (bool value) {
          setState(() {
            _bluetoothIsSupported = false;
          });
          debugPrint("Bluetooth status: " + (value ? "true" : "false"));
        });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetColumn = <Widget>[];

//    if (!_bluetoothIsSupported){
//      widgetColumn.add(Container(child: Text("Bluetooth not available :(", textScaleFactor: 1.25,), color: Colors.red),);
//    }
    widgetColumn.add(Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext c, int i) { return buildRow(c, i); },
          itemCount: _devices.length,)
    ));

    return
        Column(children: widgetColumn);
  }

  Widget buildRow(BuildContext context, int index) {
    return ListTile(title: Text(_devices[index].name), subtitle: Text(_devices[index].address),);
  }
}