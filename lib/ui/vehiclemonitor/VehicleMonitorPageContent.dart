import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/commonwidgets/Notice.dart';

class VehicleMonitorPageContent extends StatefulWidget {
  final BluetoothDevice device;
  final FlutterBlue flutterBlue;

  VehicleMonitorPageContent(this.device, this.flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return VehicleMonitorPageContentState();
  }
}

class VehicleMonitorPageContentState extends State<VehicleMonitorPageContent> {
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState> _fbconnection;
  List<BluetoothService> services = [];

  @override
  void initState() {
    super.initState();

//    this.widget.device.discoverServices().then((s) {
//      setState(() {
//        services = s;
//      });
//    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(this.widget.device.name),
      Text("MAC: " + this.widget.device.id.id),
      Text(_deviceState.toString()),
      Text("services: " + services.toString()),
      MaterialButton(
          child: Text("Connect"),
          onPressed: () {
            debugPrint("Setting up fb connection...");
            this.widget.flutterBlue.connect(this.widget.device, autoConnect: false, timeout: Duration(seconds: 15)).listen(null,
                onError: (e) => Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("onError: " + e.toString()))),
                onDone: () => Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("onDone"))));


            this.widget.device.onStateChanged().listen((newState) {
              setState(() {
                _deviceState = newState;
              });
            });
          })
    ]);
  }
}
