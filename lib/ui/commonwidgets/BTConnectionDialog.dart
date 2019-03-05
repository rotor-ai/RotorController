import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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

  @visibleForTesting
  void popNav() {

  }

  @override
  void initState() {
    super.initState();
    _flutterBlue.connect(_device, autoConnect: false, timeout: Duration(seconds: 15));
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Connecting..."),
        content: Container(
            child: Row(children: <Widget>[
              CircularProgressIndicator(),
              Padding(padding:EdgeInsets.only(left: 8) ,child: Text("please wait"))
            ])));
  }
}
