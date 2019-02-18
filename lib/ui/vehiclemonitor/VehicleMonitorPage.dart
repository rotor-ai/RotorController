import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleMonitorPageContent.dart';

class VehicleMonitorPage extends StatelessWidget {
  final BluetoothDevice device;

  VehicleMonitorPage({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.id.id),
      ),
      body: VehicleMonitorPageContent(device: device,),
    );
  }
}
