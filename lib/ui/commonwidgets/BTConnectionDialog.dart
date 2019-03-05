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
  Function _dismissDialog;

  BTConnectionDialogState(this._device, this._flutterBlue);

  @override
  void initState() {
    super.initState();
    _flutterBlue.connect(
        _device, autoConnect: false, timeout: Duration(seconds: 15))?.listen((
        onData) {
      if (onData == BluetoothDeviceState.connected) {
        _dismissDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dismissDialog = () {
      Navigator.pop(context); //I think this is a closure???
      Navigator.of(context).push(MaterialPageRoute(builder: (bc) => VehicleMonitorPage(_device, _flutterBlue)));
    };

    return AlertDialog(
        title: Text("Connecting..."),
        content: Container(
            child: Row(children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                  padding: EdgeInsets.only(left: 8), child: Text("please wait"))
            ])));
    }
}

