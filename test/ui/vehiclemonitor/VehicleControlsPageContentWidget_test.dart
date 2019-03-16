import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleControlsPageContent.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/RotorMocks.dart';


void main() {


  testWidgets("should display connection state", (WidgetTester tester) async {

    var mockFlutterBlue = MockFlutterBlue();
    var mockDevice = MockBluetoothDevice();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.connected));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VehicleControlsPageContent(mockDevice, mockFlutterBlue),
        )));
    await tester.pump();

    expect(find.text(BluetoothDeviceState.connected.toString()), findsOneWidget);

  });


  testWidgets("should display connecting state", (WidgetTester tester) async {

    var mockFlutterBlue = MockFlutterBlue();
    var mockDevice = MockBluetoothDevice();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.connecting));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VehicleControlsPageContent(mockDevice, mockFlutterBlue),
        )));
    await tester.pump();

    expect(find.text(BluetoothDeviceState.connecting.toString()), findsOneWidget);

  });
}