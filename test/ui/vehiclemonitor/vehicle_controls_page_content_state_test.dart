

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
      testObj.onDeviceConnected = expectAsync1<void, VehicleControlsPageContentState>((VehicleControlsPageContentState state) => expect(testObj, same(state)), count:1);

      testObj.initState();

      streamController.add(BluetoothDeviceState.connected);
    });

    test("Should call onServicesRecieved when device responds with services", () async {
      var someServices = new List<BluetoothService>();
      when(mockDevice.discoverServices()).thenAnswer((_) => new Future.value(someServices));
      testObj.onServicesReceived = expectAsync2<void, VehicleControlsPageContentState, List<BluetoothService>>(
        (VehicleControlsPageContentState capturedState, List<BluetoothService> capturedServices) {
          expect(capturedState,     same(testObj));
          expect(capturedServices,  same(someServices));
        }, count:1);

      testObj.onDeviceConnected(testObj);
    });

    test ("Should save reference to Rotor GATT service when onServicesReceived is called", () {
      var doSaveThisService     = new MockBluetoothService();
      var dontSaveThisService   = new MockBluetoothService();
      when(doSaveThisService.uuid)    .thenReturn(new Guid(RotorUtils.GATT_SERVICE_UUID));
      when(dontSaveThisService.uuid)  .thenReturn(new Guid("00000000-0000-0000-0000-000000000000"));
      var someServices          = [dontSaveThisService, doSaveThisService];
      
      testObj.onServicesReceived(testObj, someServices);

      expect(testObj.rotorBTService, same(doSaveThisService));
    });

    test ("Should not assign Rotor GATT service if no matching services were received", () {
      var dontSaveThisService       = new MockBluetoothService();
      when(dontSaveThisService.uuid)    .thenReturn(new Guid("00000000-0000-0000-0000-000000000000"));
      var someServices              = [dontSaveThisService];

      testObj.onServicesReceived(testObj, someServices);

      expect(testObj.rotorBTService, null);
    });

    test ("Should not assign Rotor GATT service if null or empty service list is received", () {
      
      testObj.onServicesReceived(testObj, new List<BluetoothService>());
      expect(testObj.rotorBTService, null);

      testObj.onServicesReceived(testObj, null);
      expect(testObj.rotorBTService, null);
    });

  });

}