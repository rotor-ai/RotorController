import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/vehicle_connection_info.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_monitor_page.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {

  group('Get state values from route', () {

    MockBluetoothDevice mockBluetoothDevice;
    MockFlutterBlue mockFlutterBlue;
    MockRouteSettings mockRouteSettings;
    MockModalRoute mockRoute;
    VehicleConnectionInfo connectionInfo;

    void _beforeEveryTest() {
      mockBluetoothDevice = MockBluetoothDevice();
      mockFlutterBlue = MockFlutterBlue();
      mockRouteSettings = MockRouteSettings();
      mockRoute = MockModalRoute();
      connectionInfo = VehicleConnectionInfo.using(mockBluetoothDevice, mockFlutterBlue);
    }

    test('Should not override state members if route does not have arguments', () {
      _beforeEveryTest();
      when(mockRoute.settings).thenReturn(mockRouteSettings);
      when(mockRouteSettings.arguments).thenReturn(null);
      var mockBluetoothDevice2 = MockBluetoothDevice();
      var mockFlutterBlue2 = MockFlutterBlue();
      var testObj = VehicleMonitorPageState.using(mockBluetoothDevice2, mockFlutterBlue2);

      testObj.captureArgs(mockRoute);

      expect(testObj.device, same(mockBluetoothDevice2));
      expect(testObj.flutterBlue, same(mockFlutterBlue2));
    });
    test ('Should assign state members from route if available', () {
      _beforeEveryTest();
      when(mockRoute.settings).thenReturn(mockRouteSettings);
      when(mockRouteSettings.arguments).thenReturn(connectionInfo);
      var testObj = VehicleMonitorPageState();

      testObj.captureArgs(mockRoute);
      
      expect(testObj.device, same(mockBluetoothDevice));
      expect(testObj.flutterBlue, same(mockFlutterBlue));
    });

  });

}

class MockModalRoute extends Mock implements ModalRoute {}

class MockRouteSettings extends Mock implements RouteSettings {}
