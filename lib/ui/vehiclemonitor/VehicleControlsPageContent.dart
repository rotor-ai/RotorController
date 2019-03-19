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

class VehicleControlsPageContentState
    extends State<VehicleControlsPageContent> {
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;
  List<BluetoothService> services = [];
  StreamSubscription<BluetoothDeviceState> btDeviceStateSub;

  @override
  void initState() {
    super.initState();
    widget.device.state.then((v) {
      setState(() {
        _deviceState = v;
      });
    });

    btDeviceStateSub = widget.device.onStateChanged()?.listen((updatedState) {
      setState(() {
        _deviceState = updatedState;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    btDeviceStateSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_deviceState.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    child: RaisedButton(
                      child: Text("<-"),
                    ),
                    padding: EdgeInsets.all(4),
                  ),
                  Padding(child: RaisedButton(child: Text("->")), padding: EdgeInsets.all(4),)
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(child:RaisedButton(
                    child: Text("acc")), padding: EdgeInsets.all(4)),
                  Padding(child: RaisedButton(child: Text("brake")), padding: EdgeInsets.all(4)),
                ],
              )
            ],
          )
        ]);
  }
}
