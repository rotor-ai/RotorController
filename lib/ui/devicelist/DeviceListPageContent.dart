import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobileclient/RotorStrings.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceListPageContent extends StatefulWidget {

  final FlutterBlue _flutterBlueInstance;

  DeviceListPageContent(this._flutterBlueInstance);

  @override
  State<StatefulWidget> createState() {
    return DeviceListPageContentState(_flutterBlueInstance);
  }
}

class DeviceListPageContentState extends State<DeviceListPageContent> {

  List<GenericBTDevice> _devices = [];
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _bluetoothIsSupported = true;

  DeviceListPageContentState(this._flutterBlue){

    _flutterBlue.isAvailable.then((bool value) {
      setState(() {
        _bluetoothIsSupported = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetColumn = <Widget>[];

    if (!_bluetoothIsSupported){
      widgetColumn.add(Container(child: Text(RotorStrings.UI_BT_NOT_AVAILABLE, textScaleFactor: 1.25,), color: Colors.red),);
    }
    widgetColumn.add(Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext c, int i) { return _buildRow(c, i); },
          itemCount: _devices.length,)
    ));

    return Column(children: widgetColumn);
  }

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(title: Text(_devices[index].name), subtitle: Text(_devices[index].address),);
  }
}