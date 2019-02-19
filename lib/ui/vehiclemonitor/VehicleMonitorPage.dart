import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleMonitorPageContent.dart';

class VehicleMonitorPage extends StatelessWidget {
  final BluetoothDevice _device;
  final FlutterBlue _flutterBlue;

  VehicleMonitorPage(this._device, this._flutterBlue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VehicleMonitorPageContent(_device, _flutterBlue),
    );
  }
}
