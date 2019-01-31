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
  List<BluetoothDevice> _discoveredDevices = [];
  bool _bluetoothIsSupported = true;
  final BluetoothDevice _simulatorDevice = BluetoothDevice(
      id: DeviceIdentifier("00:00:00:00:00:00"),
      name: "Vehicle Simulator",
      type: BluetoothDeviceType.unknown);

  //Getters
  List<BluetoothDevice> get discoveredDevices => _discoveredDevices;

  bool get bluetoothIsSupported => _bluetoothIsSupported;

  List<BluetoothDevice> get _compatibleDevices {
    List<BluetoothDevice> result = [_simulatorDevice];
    result.addAll(_discoveredDevices);
    return result;
  }

  //Constructor
  DeviceListPageContentState(this._flutterBlue) {}

  @override
  void initState() {
    super.initState();
    _flutterBlue.isAvailable?.then((value) => onIsAvailableResult(value));
    _flutterBlue.scan()?.listen((result) => onScanResultReceived(result));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetColumn = <Widget>[];

    if (!_bluetoothIsSupported) {
      widgetColumn.add(
        Container(
            child: Text(
              RotorStrings.UI_BT_NOT_AVAILABLE,
              textScaleFactor: 1.25,
            ),
            color: Colors.red),
      );
    } else {
      widgetColumn.add(Padding(
        child: Center(
            child: Row(
          children: <Widget>[
            FittedBox(
                child: Text(
              "Searching...",
              textScaleFactor: 1.25,
            )),
            CircularProgressIndicator()
          ],
        )),
        padding: EdgeInsets.all(4),
      ));
    }
    widgetColumn.add(Expanded(
        child: ListView.builder(
      itemBuilder: (BuildContext c, int i) {
        return _buildRow(c, i);
      },
      itemCount: _compatibleDevices.length,
    )));

    return Column(children: widgetColumn);
  }

  //========== Helpers below this line ==========

  Widget _buildRow(BuildContext context, int index) {
    return ListTile(
      title: Text(_compatibleDevices[index].name),
      subtitle: Text(_compatibleDevices[index].id.id),
    );
  }

  @visibleForTesting
  void onScanResultReceived(ScanResult sr) {
    if (sr.device.name != null && sr.device.name.isNotEmpty) {
      var alreadyExistsInList = (_discoveredDevices.fold(
              0,
              (acc, device) =>
                  acc + ((sr.device.id.id == device.id.id) ? 1 : 0))) >
          0;
      if (!alreadyExistsInList) {
        //This really sucks, but it's the only way I can think of to allow testing this method
        //I have to check if the state is mounted before calling setState
        if (this.mounted) {
          setState(() {
            _discoveredDevices.add(sr.device);
          });
        } else {
          _discoveredDevices.add(sr.device);
        }
      }
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
