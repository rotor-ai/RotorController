import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/commonwidgets/bt_connection_dialog.dart';

import '../../mocks/rotor_mocks.dart';

void main() {

  var mockDevice = MockBluetoothDevice();
  var mockFlutterBlue = MockFlutterBlue();

 testWidgets('Should attempt connection on build', (WidgetTester tester) async {
  var sb = StreamController<BluetoothDeviceState>();
  sb.add(BluetoothDeviceState.disconnected);
  when(mockDevice.state).thenAnswer((_) => sb.stream);

  await tester.pumpWidget(MaterialApp(
    routes: {'VehicleMonitor': (context) => null},
    home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

  verify(mockDevice.connect(timeout: Duration(seconds: 30), autoConnect: false));

 });
 testWidgets('Should not attempt connection on build if device is already connected', (WidgetTester tester) async {
  var sb = StreamController<BluetoothDeviceState>();
  sb.add(BluetoothDeviceState.connected);
  when(mockDevice.state).thenAnswer((_) => sb.stream);

  await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

  verifyNever(mockDevice.connect(timeout: anyNamed('timeout'), autoConnect: anyNamed('autoConnect')));
 });

 testWidgets('Should not attempt connection on build if device is connecting', (WidgetTester tester) async {
  var sb = StreamController<BluetoothDeviceState>();
  sb.add(BluetoothDeviceState.connecting);
  when(mockDevice.state).thenAnswer((_) => sb.stream);

   await tester.pumpWidget(MaterialApp(
       home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

   verifyNever(mockDevice.connect(timeout: anyNamed('timeout'), autoConnect: anyNamed('autoConnect')));

 });

 testWidgets('Should pop navigation after connection is complete', (WidgetTester tester) async {
  var sc = StreamController<BluetoothDeviceState>();
  sc.add(BluetoothDeviceState.disconnected);
  when(mockDevice.state).thenAnswer((_) => sc.stream);
  //TODO use NavigationObserver to track push/pop

  //ACT
  var testObj = MaterialApp(home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue)));
  await tester.pumpWidget(testObj);

  //ASSERT
  verify(mockDevice.connect(timeout: anyNamed('timeout'), autoConnect: anyNamed('autoConnect')));

  //ACT
  sc.add(BluetoothDeviceState.connected);

  //ASSERT

 }, skip: 'TODO STU come back if time allows' != null);

}
