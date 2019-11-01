import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/vehicle_connection_info.dart';

import '../mocks/rotor_mocks.dart';

void main() {
  test('should construct', () {
    var testObj = VehicleConnectionInfo();

    expect(testObj.device, isNull);
    expect(testObj.flutterBlue, isNull);
  });

  test('should construct with values', () {
    var mockBluetoothDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    var testObj = VehicleConnectionInfo.using(mockBluetoothDevice, mockFlutterBlue);

    expect(testObj.device, same(mockBluetoothDevice));
    expect(testObj.flutterBlue, same(mockFlutterBlue));
  });
}