import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/data/vehicle_connection_info.dart';
import 'package:mobileclient/strings.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_monitor_page.dart';

class BTConnectionDialog extends StatelessWidget {
  BluetoothDevice _device;
  FlutterBlue _flutterBlue;

  BTConnectionDialog(this._device, this._flutterBlue);

  @override
  Widget build(BuildContext context) {

    _device.state.listen((deviceState) {
      
      if (deviceState != BluetoothDeviceState.connected && deviceState != BluetoothDeviceState.connecting) {
           _device.connect(timeout: Duration(seconds: 30), autoConnect: false);
           Navigator.popAndPushNamed(context, 'VehicleMonitor', arguments: VehicleConnectionInfo.using(_device, _flutterBlue));
      }

    });
    return AlertDialog(
        title: Text(Strings.UI_VEHICLE_CONNECTING),
        content: Container(
            child: Row(children: <Widget>[
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(left: 8), child: Text("please wait"))
        ])));
  }
}
