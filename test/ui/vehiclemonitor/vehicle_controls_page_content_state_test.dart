

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_controls_page_content.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {

  var mockDevice = MockBluetoothDevice();
  var mockFlutterBlue = MockFlutterBlue();

  group("initState", () {
    
    test ("Should attempt to collect device GATT service info", () {
      when(mockDevice.discoverServices()).thenAnswer((_) => new Future.value(null));
      var testObj = new VehicleControlsPageContentState(mockDevice, mockFlutterBlue);

      testObj.initState();

      verify(mockDevice.discoverServices()).called(ONCE);
    });

    test ("Should not assign Rotor GATT service if no services exist", () {
      List<BluetoothService> services = new List();
      when(mockDevice.discoverServices()).thenAnswer((_) => new Future.value(services));
      var testObj = new VehicleControlsPageContentState(mockDevice, mockFlutterBlue);

      testObj.initState();

      expect(testObj.getRotorBTDeviceService(), isNull);
    });

    test ("Should save reference to Rotor GATT service", () async {
      var someOtherBTService = MockBluetoothService();
      var rotorBTService = MockBluetoothService();
      when(someOtherBTService.uuid)       .thenReturn(new Guid("00000000-1234-5678-90ab-000000000000"));
      when(rotorBTService.uuid)           .thenReturn(new Guid(RotorUtils.GATT_SERVICE_UUID));
      when(mockDevice.discoverServices()) .thenAnswer((_) => new Future.value([someOtherBTService, rotorBTService]));
      var testObj = new VehicleControlsPageContentState(mockDevice, mockFlutterBlue);

      testObj.initState();
      await untilCalled(rotorBTService.uuid);

      expect(testObj.getRotorBTDeviceService(), rotorBTService);
    });

  });

}