import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/commonwidgets/bt_connection_dialog.dart';

import '../../mocks/rotor_mocks.dart';

void main() {

  testWidgets('Should attempt connection on build', (WidgetTester tester) async {
    var mockDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.disconnected));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

    verify(mockFlutterBlue.connect(mockDevice,timeout: anyNamed('timeout'), autoConnect: false));

  });

  testWidgets('Should not attempt connection on build if device is connected', (WidgetTester tester) async {
    var mockDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.connected));

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

    verifyNever(mockFlutterBlue.connect(any, timeout: anyNamed('timeout'), autoConnect: anyNamed('autoConnect')));

  });

  testWidgets('Should not attempt connection on build if device is connecting', (WidgetTester tester) async {
    var mockDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.connecting));

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

    verifyNever(mockFlutterBlue.connect(any, timeout: anyNamed('timeout'), autoConnect: anyNamed('autoConnect')));

  });

  testWidgets('Should use listen callback', (WidgetTester tester) async {
    var mockDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    var mockBTDeviceStateStream = MockBluetoothDeviceStateStream();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.disconnected));
    when(mockFlutterBlue.connect(mockDevice, timeout: anyNamed('timeout'), autoConnect: false)).thenAnswer((_) => mockBTDeviceStateStream);


    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue))));

    verify(mockBTDeviceStateStream.listen(any));

  });


  //RIP THIS TEST
  // I can't seem to get navigation listeners to work
  testWidgets('Should dismiss dialog if connection fails',
      (WidgetTester tester) async {
    var mockDevice = MockBluetoothDevice();
    var mockFlutterBlue = MockFlutterBlue();
    var mockNavigator = MockNavigator();
    var streamController = StreamController<BluetoothDeviceState>();
    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.disconnected));
    when(mockFlutterBlue.connect(mockDevice, timeout: anyNamed('timeout'), autoConnect: false)).thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: BTConnectionDialog(mockDevice, mockFlutterBlue)), navigatorObservers: [mockNavigator],));
    await tester.pump();

    var wasPopped = false;
    Route pushedRoute = verify(mockNavigator.didPush(captureAny, any)).captured.single;
    pushedRoute.popped.then((b) => wasPopped = b);

    streamController.add(BluetoothDeviceState.connected);
    await tester.pump();

    verify(mockFlutterBlue.connect(mockDevice,timeout: anyNamed('timeout'), autoConnect: false));

    expect(pushedRoute, isNotNull);
    expect(wasPopped, true);
  }, skip: true);
}


class MockNavigator extends Mock implements NavigatorObserver {}
