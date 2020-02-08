

import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_controls_page_content.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {


  MockBluetoothDevice mockDevice;
  MockFlutterBlue mockFlutterBlue;
  VehicleControlsPageContentState testObj;

  setUp(() {
    mockDevice = new MockBluetoothDevice();
    mockFlutterBlue = new MockFlutterBlue();
    testObj = new VehicleControlsPageContentState(mockDevice, mockFlutterBlue);
  });

  group("initState", () {

    test ("Should not call onDeviceConnected if device is not connected", () async {
      var streamController = StreamController<BluetoothDeviceState>();
      streamController.add(BluetoothDeviceState.disconnected);
      when(mockDevice.state).thenAnswer((_) => streamController.stream);
      testObj.onDeviceConnected = expectAsync1<void, VehicleControlsPageContentState>(testObj.onDeviceConnected, count:0);

      testObj.initState();

      streamController.add(BluetoothDeviceState.connecting);
      streamController.add(BluetoothDeviceState.disconnecting);
    });

    test("Should call onDeviceConnected when device is connected", () async {
      var streamController = StreamController<BluetoothDeviceState>();
      streamController.add(BluetoothDeviceState.disconnected);
      when(mockDevice.state).thenAnswer((_) => streamController.stream);
      testObj.onDeviceConnected = expectAsync1<void, VehicleControlsPageContentState>(testObj.onDeviceConnected, count:1);

      testObj.initState();

      streamController.add(BluetoothDeviceState.connected);
    });

    test ("Should not assign Rotor GATT service if no services exist", () {
      List<BluetoothService> services = new List();
      when(mockDevice.discoverServices()).thenAnswer((_) => new Future.value(services));

      testObj.initState();

      expect(testObj.getRotorBTDeviceService(), isNull);
    });

    test ("Should save reference to Rotor GATT service", () async {
      var someOtherBTService = MockBluetoothService();
      var rotorBTService = MockBluetoothService();
      when(someOtherBTService.uuid)       .thenReturn(new Guid("00000000-1234-5678-90ab-000000000000"));
      when(rotorBTService.uuid)           .thenReturn(new Guid(RotorUtils.GATT_SERVICE_UUID));
      when(mockDevice.discoverServices()) .thenAnswer((_) => new Future.value([someOtherBTService, rotorBTService]));

      testObj.initState();
      await untilCalled(rotorBTService.uuid);

      expect(testObj.getRotorBTDeviceService(), rotorBTService);
    });

  });

}