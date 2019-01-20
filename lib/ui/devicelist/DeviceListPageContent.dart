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

  FlutterBlue _flutterBlue;
  List<BluetoothDevice> _discoveredDevices;
  bool _bluetoothIsSupported = true;

  List<BluetoothDevice> get _compatibleDevices    => _discoveredDevices;
  List<BluetoothDevice> get discoveredDevices     => _discoveredDevices;
  bool                  get bluetoothIsSupported  => _bluetoothIsSupported;

  DeviceListPageContentState(this._flutterBlue) {
    _discoveredDevices = [];
    _flutterBlue.isAvailable?.then((value) => onIsAvailableResult(value));
    _flutterBlue.scan()?.listen((result) => onScanResultReceived(result));
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
          itemCount: _discoveredDevices.length,)
    ));

    return Column(children: widgetColumn);
  }

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(title: Text(_discoveredDevices[index].name), subtitle: Text(_discoveredDevices[index].id.id),);
  }

  void onScanResultReceived(ScanResult sr) {
    _discoveredDevices.add(sr.device);
  }

  @visibleForTesting
  void onIsAvailableResult(bool result) {
    if (this.mounted) {
      setState(() {
        _bluetoothIsSupported = result;
      });
    }
  }

}