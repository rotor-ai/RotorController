import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/Strings.dart';

class RotorUtils {

  static final BluetoothDevice simulatorDevice = BluetoothDevice(
      id: DeviceIdentifier(simulatorId),
      name: Strings.UI_VEHICLE_SIMULATOR,
      type: BluetoothDeviceType.unknown);

  static final String simulatorId = "00:00:00:00:00:00";

}