import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/RotorUtils.dart';
import 'package:mobileclient/data/RotorCommand.dart';
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
  List<String> eventLog = [];
  BluetoothService rotorBTService;
  BluetoothCharacteristic rotorBTCharacteristic;

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

    widget.device.discoverServices().then((result) {
      rotorBTService = result.firstWhere((btService) =>
          btService.uuid.toString() == "10101010-1234-5678-90ab-101010101010");

      if (rotorBTService != null) {
        rotorBTCharacteristic = rotorBTService.characteristics.firstWhere(
            (characteristic) =>
                characteristic.uuid.toString() ==
                "10101010-1234-5678-90ab-202020202020");
      }
    });

    eventLog.add(RotorCommand().toShorthand());
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
          Notice(title: _deviceState.toString(), color: Colors.black),
          Expanded(
              child: Container(
                  color: Colors.black,
                  child: ListView.builder(
                    itemBuilder: (BuildContext bc, int i) {
                      return Text(eventLog[i]);
                    },
                    itemCount: eventLog.length,
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
                    _executeCommand(RotorCommand(throttleVal: 0, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.PORT, headingVal: 50))),
            _buildControlPanelButton(
                "right",
                (pressingDown) =>
                    _executeCommand(RotorCommand(throttleVal: 0, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.STARBOARD, headingVal: 50)))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildControlPanelButton(
                "GO!",
                (pressingDown) =>
                    _executeCommand(RotorCommand(throttleVal: 50, throttleDir: ThrottleDirection.FORWARD, headingDir: HeadingDirection.MIDDLE, headingVal: 0)),
                colorOverride: Colors.green),
            _buildControlPanelButton(
                "STOP!",
                (pressingDown) =>
                    _executeCommand(RotorCommand(throttleVal: 0, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.MIDDLE, headingVal: 0)),
                colorOverride: Colors.red)
          ],
        )
      ],
    ));
  }

  Widget _buildControlPanelButton(String actionTitle, Function highlightAction,
          {Color colorOverride = RotorUtils.ROTOR_TEAL_COLOR}) =>
      Padding(
          child: RaisedButton(
            child: Text(actionTitle),
            onHighlightChanged: highlightAction,
            onPressed: () {},
            color: colorOverride,
          ),
          padding: EdgeInsets.all(4));

  _executeCommand(RotorCommand rc) {
    if (rotorBTCharacteristic != null) {

      this
          .widget
          .device
          .writeCharacteristic(rotorBTCharacteristic, rc.toShorthand().codeUnits);

      setState(() {
        eventLog.add(rc.toShorthand());
      });
    }
  }
}
