import 'package:flutter/material.dart';

class DeviceRow extends StatelessWidget {

  final String deviceName;
  final String mac;
  final int signalStrength;
  final Function onTap;

  DeviceRow({Key key, this.deviceName, this.mac, this.signalStrength, this.onTap})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(deviceName),
      subtitle: Text(mac),
      onTap: onTap,
    );
  }
}
