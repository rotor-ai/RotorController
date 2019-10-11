import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_monitor_page.dart';

class BTConnectionDialog extends StatelessWidget {
  BluetoothDevice _device;
  FlutterBlue _flutterBlue;

  BTConnectionDialog(this._device, this._flutterBlue);

  void _pushToVehicleMonitor(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (bc) => VehicleMonitorPage(_device, _flutterBlue)));
  }

  @override
  Widget build(BuildContext context) {
    //TODO STU FIX THIS (OLD CODE)
//    _device.state.then((currentDeviceState) {
//      if (currentDeviceState != BluetoothDeviceState.connected &&
//          currentDeviceState != BluetoothDeviceState.connecting) {
//        _flutterBlue
//            .connect(_device,
//                timeout: Duration(seconds: 10), autoConnect: false)
//            ?.listen((btDeviceState) {
//          if (btDeviceState == BluetoothDeviceState.connected) {
//            _pushToVehicleMonitor(context);
//          }
//        });
//      }
//    });

    _device.state.listen((deviceState) {
      
      if (deviceState!=BluetoothDeviceState.connected) {
           _device.connect(timeout: Duration(seconds: 30), autoConnect: false); 
      }

    });
    return AlertDialog(
        title: Text("Connecting..."),
        content: Container(
            child: Row(children: <Widget>[
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(left: 8), child: Text("please wait"))
        ])));
  }
}
