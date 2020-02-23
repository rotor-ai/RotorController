import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/rotor_command.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/ui/vehiclemonitor/controls_subpage.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {


  MockBluetoothDevice mockDevice;
  ControlsSubpageState testObj;

  setUp(() {
    mockDevice = new MockBluetoothDevice();
    testObj = new ControlsSubpageState(mockDevice);
  });

  group("initState", () {

    test ("Should not call onDeviceConnected if device is not connected", () async {
      var streamController = StreamController<BluetoothDeviceState>();
      streamController.add(BluetoothDeviceState.disconnected);
      when(mockDevice.state).thenAnswer((_) => streamController.stream);
      testObj.onDeviceConnected = expectAsync1<void, ControlsSubpageState>(testObj.onDeviceConnected, count:0);

      testObj.initState();

      streamController.add(BluetoothDeviceState.connecting);
      streamController.add(BluetoothDeviceState.disconnecting);
    });

    test("Should call onDeviceConnected when device is connected", () async {
      var streamController = StreamController<BluetoothDeviceState>();
      streamController.add(BluetoothDeviceState.disconnected);
      when(mockDevice.state).thenAnswer((_) => streamController.stream);
      testObj.onDeviceConnected = expectAsync1<void, ControlsSubpageState>((ControlsSubpageState state) => expect(testObj, same(state)), count:1);

      testObj.initState();

      streamController.add(BluetoothDeviceState.connected);
    });

    test("Should call onServicesRecieved when device responds with services", () async {
      var someServices = new List<BluetoothService>();
      when(mockDevice.discoverServices()).thenAnswer((_) => new Future.value(someServices));
      testObj.onServicesReceived = expectAsync2<void, ControlsSubpageState, List<BluetoothService>>(
        (ControlsSubpageState capturedState, List<BluetoothService> capturedServices) {
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

  group("write command characteristic", ()
  {

    BluetoothCharacteristic randomCharacteristic;
    BluetoothCharacteristic rotorCharacteristic;
    BluetoothService rotorService;
    RotorCommand someCommand;
    int changeStateCalled;
    ControlsSubpageState capturedState;
    Function capturedSetStateFunction;

    setUp(() {
      randomCharacteristic = new MockBluetoothCharacteristic();
      rotorCharacteristic = new MockBluetoothCharacteristic();
      rotorService = new MockBluetoothService();

      when(randomCharacteristic.uuid).thenReturn(
          new Guid("00000000-0000-0000-0000-000000000000"));
      when(rotorCharacteristic.uuid).thenReturn(
          new Guid(RotorUtils.GATT_CHARACTERISTIC_UUID));

      changeStateCalled = 0;
      capturedState = null;
      testObj.changeState = (ControlsSubpageState s, Function f) {
        capturedState = s;
        capturedSetStateFunction = f;
        changeStateCalled++;
        capturedSetStateFunction();
      };//changeState() is a proxy method for setState(), that can be faked for testing.
      // This allows us to test methods that would normally call setState(),
      // since flutter will throw an exception if a method under unit test calls setState().

      someCommand = RotorCommand(
          throttleDir: ThrottleDirection.FORWARD,
          throttleVal: 12,
          headingDir: HeadingDirection.PORT,
          headingVal: 34
      );
    });

    test("Should write command to characteristic", () async {
      when(rotorService.characteristics).thenReturn([randomCharacteristic, rotorCharacteristic]);
      testObj.rotorBTService = rotorService; //seed a new service to our test obj

      await testObj.executeCommand(someCommand);

      expect(verify(rotorCharacteristic.write(
          captureAny, withoutResponse: captureAnyNamed("withoutResponse")))
          .captured, ["F012 L034".codeUnits, true]);
      expect(changeStateCalled, 1);
      expect(capturedState, testObj);
      expect(capturedSetStateFunction, isA<Function>());
      expect(testObj.eventLog.last, someCommand.toShorthand());
    });

    test("Should not try to write if no matching characteristics exist", () async {

      when(rotorService.characteristics).thenReturn([randomCharacteristic]);
      testObj.rotorBTService = rotorService;

      await testObj.executeCommand(new RotorCommand());

      //TODO: Ideally we would assert that changeState() was never called, but atm,
      // we aren't verifying if the command was received by the vehicle or not
    });

  });

}