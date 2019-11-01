

import 'package:flutter_blue/flutter_blue.dart';

class VehicleConnectionInfo {
  
  BluetoothDevice device;
  FlutterBlue flutterBlue;

  VehicleConnectionInfo();
  VehicleConnectionInfo.using(this.device, this.flutterBlue);

}