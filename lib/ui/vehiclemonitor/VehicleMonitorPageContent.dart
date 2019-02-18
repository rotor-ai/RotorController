


import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class VehicleMonitorPageContent extends StatefulWidget {

  final BluetoothDevice device;
  VehicleMonitorPageContent({Key key, this.device}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    return VehicleMonitorPageContentState();
  }
}

class VehicleMonitorPageContentState extends State<VehicleMonitorPageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,);
  }

}