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

  //Members
  FlutterBlue _flutterBlue;
  List<BluetoothDevice> _discoveredDevices;
  bool _bluetoothIsSupported = true;
  final BluetoothDevice _simulatorDevice = BluetoothDevice(id: DeviceIdentifier("00:00:00:00:00:00"), name: "Vehicle Simulator", type: BluetoothDeviceType.unknown);

  //Getters
  List<BluetoothDevice> get discoveredDevices     => _discoveredDevices;
  bool                  get bluetoothIsSupported  => _bluetoothIsSupported;
  List<BluetoothDevice> get _compatibleDevices {
    List<BluetoothDevice> result = [_simulatorDevice];
    result.addAll(_discoveredDevices);
    return result;
  }

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
          itemCount: _compatibleDevices.length,)
    ));

    return Column(children: widgetColumn);
  }

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(title: Text(_compatibleDevices[index].name), subtitle: Text(_compatibleDevices[index].id.id),);
  }

  @visibleForTesting
  void onScanResultReceived(ScanResult sr) {
    if (sr.device.name != null && sr.device.name.isNotEmpty){
      _discoveredDevices.add(sr.device);
    }
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