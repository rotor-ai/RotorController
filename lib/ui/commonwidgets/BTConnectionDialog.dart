import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleMonitorPage.dart';

class BTConnectionDialog extends StatefulWidget {
  BluetoothDevice _device;
  FlutterBlue _flutterBlue;

  BTConnectionDialog(this._device, this._flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return BTConnectionDialogState(_device, _flutterBlue);
  }
}

class BTConnectionDialogState extends State<BTConnectionDialog> {
  BluetoothDevice _device;
  FlutterBlue _flutterBlue;

  BTConnectionDialogState(this._device, this._flutterBlue);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _device.state.then((currentDeviceState) {
      if (currentDeviceState != BluetoothDeviceState.connected) {
        _flutterBlue.connect(_device,
            timeout: Duration(seconds: 15), autoConnect: false);
      }
    });

    return AlertDialog(
        title: Text("Connecting..."),
        content: Container(
            child: Row(children: <Widget>[
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(left: 8), child: Text("please wait"))
        ])));
  }
}
