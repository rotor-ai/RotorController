import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/RotorStrings.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/RotorMocks.dart';

void main() {
  //finders
  final btWarningFinder = find.text(RotorStrings.UI_BT_NOT_AVAILABLE);
  final btRadioOffFinder = find.text(RotorStrings.UI_BT_RADIO_IS_OFF);

  testWidgets('Should show bluetooth unsupported when bt is not available',
      (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable)
        .thenAnswer((_) => new Future.value(false));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ASSERT
    expect(btWarningFinder, findsOneWidget);
  });

  testWidgets('Should show bluetooth warning when bt is off',
      (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state)
        .thenAnswer((_) => new Future.value(BluetoothState.off));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ASSERT
    expect(btRadioOffFinder, findsOneWidget);
  });

  testWidgets('Should show bluetooth warning when bt changes state',
      (WidgetTester tester) async {
    //ARRANGE
    var streamController = StreamController<BluetoothState>();
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state)
        .thenAnswer((_) => new Future.value(BluetoothState.on));
    when(mockFlutterBlue.onStateChanged())
        .thenAnswer((_) => streamController.stream);

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ACT Send out a state change
    streamController.add(BluetoothState.off);

    await tester.pumpAndSettle();

    //ASSERT
    expect(streamController.hasListener, true);
    expect(btRadioOffFinder, findsOneWidget);
  });

  testWidgets('Should not show bluetooth warning when bt is available',
      (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ASSERT
    expect(btWarningFinder, findsNothing);
  });

  testWidgets('Should show simulator on list', (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ASSERT
    expect(find.widgetWithText(ListTile, "Vehicle Simulator"), findsOneWidget);
  });

  testWidgets('Should show real device on list', (WidgetTester tester) async {
    //ARRANGE
    var device = MockBluetoothDevice();
    when(device.name).thenReturn("Stus awesome car");
    when(device.id).thenReturn(DeviceIdentifier("12:34:56:78:90:12"));

    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.scan()).thenAnswer(
        (_) => Stream.fromFuture(Future.value(ScanResult(device: device))));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pumpAndSettle();

    //ASSERT
    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsOneWidget);
  });
}
