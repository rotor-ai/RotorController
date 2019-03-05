import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/commonwidgets/Notice.dart';

class VehicleControlsPageContent extends StatefulWidget {
  final BluetoothDevice device;
  final FlutterBlue flutterBlue;

  VehicleControlsPageContent(this.device, this.flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return VehicleControlsPageContentState();
  }
}

class VehicleControlsPageContentState extends State<VehicleControlsPageContent> {
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState> _fbconnection;
  List<BluetoothService> services = [];

  @override
  void initState() {
    super.initState();
  }

  void _initiateConnection() {
    this
        .widget
        .flutterBlue
        .connect(this.widget.device,
            autoConnect: false, timeout: Duration(seconds: 15))
        .listen(null,
            onError: (e) => Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("onError: " + e.toString()))),
            onDone: () => Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("onDone"))));

    this.widget.device.onStateChanged().listen((newState) {
      setState(() {
        _deviceState = newState;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(_deviceState.toString()),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: FlatButton(
                  child: Text("Connect"),
                  onPressed: () => _initiateConnection()))
        ]);
  }
}
