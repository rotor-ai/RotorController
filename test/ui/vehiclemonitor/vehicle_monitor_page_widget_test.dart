import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_monitor_page.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/rotor_mocks.dart';

void main() {

  testWidgets('Should build widget from route with arguments', (WidgetTester wt) async {

    var flutterBlue = FlutterBlue.instance;
    var mockDevice = MockBluetoothDevice();
    when(mockDevice.state).thenAnswer((_) => new StreamController<BluetoothDeviceState>().stream );
    var testObj = VehicleMonitorPage(mockDevice, flutterBlue);
    await wt.pumpWidget(MaterialApp(home: testObj));

    //no assertions. just make sure we didn't throw any errors

  });

}