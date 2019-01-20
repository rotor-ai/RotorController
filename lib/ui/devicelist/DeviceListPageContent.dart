import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobileclient/RotorStrings.dart';
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

  List<BluetoothDevice> _devices = [BluetoothDevice(id: DeviceIdentifier("00:00:00:00:00:00"), name: "Vehicle Simulator", type: BluetoothDeviceType.unknown)];
  List<BluetoothDevice> get devices => _devices;

  FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _bluetoothIsSupported = true;
  bool get bluetoothIsSupported => _bluetoothIsSupported;

  DeviceListPageContentState(this._flutterBlue){

    _flutterBlue.isAvailable.then((bool value) {
      if (this.mounted) {//this check allows us to unit test the state
        onIsAvailableResult(value);
      }
    });

    _flutterBlue.scan();
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
    return ListTile(title: Text(_devices[index].name), subtitle: Text(_devices[index].id.id),);
  }

  void onScanResultReceived(ScanResult sr) {

  }

  @visibleForTesting
  void onIsAvailableResult(bool result) {
    setState(() {
      _bluetoothIsSupported = result;
    });
  }

}