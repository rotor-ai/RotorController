//========== Mock definitions ==========

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mockito/mockito.dart';

class MockFlutterBlue extends Mock implements FlutterBlue {}

class MockBluetoothDevice extends Mock implements BluetoothDevice {}

MockBluetoothDevice buildMockDevice(String name, String id) {
  var device = MockBluetoothDevice();
  when(device.name).thenReturn(name);
  when(device.id).thenReturn(DeviceIdentifier(id));
  return device;
}