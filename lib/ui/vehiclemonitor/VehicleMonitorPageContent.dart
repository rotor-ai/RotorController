import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Loading..."),);
  }

}