import 'package:flutter/material.dart';

class DeviceRow extends StatelessWidget {

  final String deviceName;
  final String mac;
  final int signalStrength;

  DeviceRow({Key key, this.deviceName, this.mac, this.signalStrength})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(deviceName),
      subtitle: Text(mac),
    );
  }
}
