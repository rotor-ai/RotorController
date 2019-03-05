import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/Strings.dart';

class RotorUtils {

  static final BluetoothDevice simulatorDevice = BluetoothDevice(
      id: DeviceIdentifier("00:00:00:00:00:00"),
      name: Strings.UI_VEHICLE_SIMULATOR,
      type: BluetoothDeviceType.unknown);

}