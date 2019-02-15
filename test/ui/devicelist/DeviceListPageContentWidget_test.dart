import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/Strings.dart';
import 'package:mobileclient/ui/commonwidgets/Notice.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/RotorMocks.dart';

void main() {
  //finders
  final btNotAvailableFinder =
      find.widgetWithText(Notice, Strings.UI_BT_NOT_AVAILABLE);
  final btRadioOffFinder =
      find.widgetWithText(Notice, Strings.UI_BT_RADIO_IS_OFF);
  final btUnauthorizedFinder =
      find.widgetWithText(Notice, Strings.UI_BT_NOT_AUTHORIZED);

  testWidgets('Should show notice when bt is not available',
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
    await tester.pump();

    //ASSERT
    expect(btNotAvailableFinder, findsOneWidget);
  });

  testWidgets('Should show notice when bt is off', (WidgetTester tester) async {
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
    await tester.pump();

    //ASSERT
    expect(btRadioOffFinder, findsOneWidget);
  });

  testWidgets('Should show notice when bt permissions are not authorized',
      (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state)
        .thenAnswer((_) => new Future.value(BluetoothState.unauthorized));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pump();

    //ASSERT
    expect(btUnauthorizedFinder, findsOneWidget);
  });

  testWidgets('Should show notice when bt changes state',
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

    //ACT Send out a state change
    streamController.add(BluetoothState.off);

    await tester.pump();

    //ASSERT
    expect(streamController.hasListener, true);
    expect(btRadioOffFinder, findsOneWidget);
  });

  testWidgets('Should not show notice when bt is available',
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
    await tester.pump();

    //ASSERT
    expect(btNotAvailableFinder, findsNothing);
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

    //ASSERT
    expect(find.widgetWithText(ListTile, Strings.UI_VEHICLE_SIMULATOR), findsOneWidget);
  });

  testWidgets('Should show real device on list', (WidgetTester tester) async {
    //ARRANGE
    var device = MockBluetoothDevice();
    when(device.name).thenReturn("Stus awesome car");
    when(device.id).thenReturn(DeviceIdentifier("12:34:56:78:90:12"));

    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((_) => new Future.value(BluetoothState.on));
    when(mockFlutterBlue.scan()).thenAnswer(
        (_) => Stream.fromFuture(Future.value(ScanResult(device: device))));

    //ACT
    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pump();

    //ASSERT
    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsOneWidget);
  });

  testWidgets('Should clear discovered list when bt state changes to not be ON', (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();

    var device = MockBluetoothDevice();
    when(device.name).thenReturn("Stus awesome car");
    when(device.id).thenReturn(DeviceIdentifier("12:34:56:78:90:12"));

    var streamController = StreamController<BluetoothState>();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((_) => new Future.value(BluetoothState.on));
    when(mockFlutterBlue.onStateChanged()).thenAnswer((_) => streamController.stream);
    when(mockFlutterBlue.scan()).thenAnswer(
            (_) => Stream.fromFuture(Future.value(ScanResult(device: device))));

    //ACT
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DeviceListPageContent(mockFlutterBlue),
        )));
    await tester.pump();

    //ASSERT
    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsOneWidget);

    //ACT
    streamController.add(BluetoothState.off);
    await tester.pump();

    //ASSERT
    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsNothing);

  });

  testWidgets('Should show activity spinner when scanning', (WidgetTester tester) async {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var streamController = StreamController<BluetoothState>();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((_) => new Future.value(BluetoothState.off));
    when(mockFlutterBlue.onStateChanged()).thenAnswer((_) => streamController.stream);

    //ACT
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DeviceListPageContent(mockFlutterBlue),
        )));

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsNothing);

    //ACT
    streamController.add(BluetoothState.on);
    await tester.pump();

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsOneWidget);

    //ACT
    streamController.add(BluetoothState.off);
    await tester.pump();

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsNothing);

  });

  
}
