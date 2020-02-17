import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/rotor_command.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_controls_page_content.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {


  MockBluetoothDevice mockDevice;
  VehicleControlsPageContentState testObj;

  setUp(() {
    mockDevice = new MockBluetoothDevice();
    testObj = new VehicleControlsPageContentState(mockDevice);
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

  test("Should write command to characteristic", () {

    var randomCharacteristic = new MockBluetoothCharacteristic();
    when(randomCharacteristic.uuid).thenReturn(new Guid("00000000-0000-0000-0000-000000000000"));
    var rotorCharacteristic = new MockBluetoothCharacteristic();
    when(rotorCharacteristic.uuid).thenReturn(new Guid(RotorUtils.GATT_CHARACTERISTIC_UUID));
    var rotorService = new MockBluetoothService();
    when(rotorService.characteristics).thenReturn([randomCharacteristic, rotorCharacteristic]);
    var someCommand = RotorCommand(
      throttleDir: ThrottleDirection.FORWARD,
      throttleVal: 12,
      headingDir: HeadingDirection.PORT,
      headingVal: 34
    );
    testObj.rotorBTService = rotorService;//seed a new service to our test obj
    
    testObj.executeCommand(someCommand);
    
    expect(verify(rotorCharacteristic.write(captureAny, withoutResponse: captureAnyNamed("withoutResponse"))).captured, ["F012 L034".codeUnits, true]);
  });

  test("Should not try to write if no matching caracteristics exist", () {
    var randomCharacteristic = new MockBluetoothCharacteristic();
    when(randomCharacteristic.uuid).thenReturn(new Guid("00000000-0000-0000-0000-000000000000"));
    var rotorService = new MockBluetoothService();
    when(rotorService.characteristics).thenReturn([randomCharacteristic]);
    testObj.rotorBTService = rotorService;

    testObj.executeCommand(new RotorCommand());
  });

}