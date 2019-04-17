import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/strings.dart';

class RotorUtils {

  static const int ROTOR_TEAL_VALUE = 0xFF59EFDD;
  static const int ROTOR_BLUE_VALUE = 0xFF3383BC;
  static const Color ROTOR_TEAL_COLOR = Color(ROTOR_TEAL_VALUE);
  static const Color ROTOR_BLUE_COLOR = Color(ROTOR_BLUE_VALUE);
  static const String GATT_SERVICE_UUID = "10101010-1234-5678-90ab-101010101010";
  static const String GATT_CHARACTERISTIC_UUID = "10101010-1234-5678-90ab-202020202020";

  static final BluetoothDevice simulatorDevice = BluetoothDevice(
      id: DeviceIdentifier(simulatorId),
      name: Strings.UI_VEHICLE_SIMULATOR,
      type: BluetoothDeviceType.unknown);

  static final String simulatorId = "00:00:00:00:00:00";

}