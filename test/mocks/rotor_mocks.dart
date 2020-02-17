//========== Mock definitions ==========

import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mockito/mockito.dart';

const ONCE = 1;
const NEVER = 0;

class MockFlutterBlue extends Mock implements FlutterBlue {}

class MockBluetoothDevice extends Mock implements BluetoothDevice {}

class MockBluetoothDeviceStateStream extends Mock implements Stream<BluetoothDeviceState> {}

class MockBluetoothService extends Mock implements BluetoothService {}

class MockBluetoothCharacteristic extends Mock implements BluetoothCharacteristic {}

class MockBuildContext extends Mock implements BuildContext {}

MockBluetoothDevice buildMockDevice(String name, String id) {
  var device = MockBluetoothDevice();
  when(device.name).thenReturn(name);
  when(device.id).thenReturn(DeviceIdentifier(id));
  return device;
}