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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Notice(title: _deviceState.toString(), color: Colors.orange),
          Expanded(child:Container(
              color: Colors.black,
              child: ListView.builder(
            itemBuilder: (BuildContext bc, int i) {
              return Text("hi");
            },
            itemCount: 5,
          ))),
          _buildControlPanel()
        ]);
  }

  Widget _buildControlPanel() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildControlPanelButton(
                "left",
                (pressingDown) =>
                    debugPrint("Left " + pressingDown.toString())),
            _buildControlPanelButton(
                "right",
                (pressingDown) =>
                    debugPrint("Right " + pressingDown.toString()))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildControlPanelButton("GO!",
                (pressingDown) => debugPrint("GO! " + pressingDown.toString())),
            _buildControlPanelButton(
                "STOP!",
                (pressingDown) =>
                    debugPrint("STOP! " + pressingDown.toString()))
          ],
        )
      ],
    ));
  }

  Widget _buildControlPanelButton(
          String actionTitle, Function highlightAction) =>
      Padding(
          child: RaisedButton(
            child: Text(actionTitle),
            onHighlightChanged: highlightAction,
            onPressed: () {},
          ),
          padding: EdgeInsets.all(4));
}
