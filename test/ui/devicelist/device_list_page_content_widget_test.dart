import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/strings.dart';
import 'package:mobileclient/ui/commonwidgets/notice.dart';
import 'package:mobileclient/ui/devicelist/device_list_page_content.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';

void main() {
  //finders
  final btNotAvailableFinder =
      find.widgetWithText(Notice, Strings.UI_BT_NOT_AVAILABLE);
  final anyNoticeFinder =
      find.byWidgetPredicate((w) => w.runtimeType == Notice);
  final btRadioOffFinder =
      find.widgetWithText(Notice, Strings.UI_BT_RADIO_IS_OFF);
  final btUnauthorizedFinder =
      find.widgetWithText(Notice, Strings.UI_BT_NOT_AUTHORIZED);

  Stream<BluetoothState> _buildStreamFromBTState(BluetoothState btState){
    var streamController = StreamController<BluetoothState>();
    streamController.add(btState);
    return streamController.stream;
  }

  testWidgets('Should show Notice when bt is not available for this device',
      (WidgetTester tester) async {
    //ARRANGE
        var mockFlutterBlue = MockFlutterBlue();
        when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(false));

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

  testWidgets('Should not show any Notice when bt is on and available for this device',
          (WidgetTester tester) async {
        var mockFlutterBlue = MockFlutterBlue();
        when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
        when(mockFlutterBlue.state).thenAnswer((invocation) => _buildStreamFromBTState(BluetoothState.on));

        var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: deviceListPageContent,
            )));
        await tester.pump();

        expect(anyNoticeFinder, findsNothing);
      });

  testWidgets('Should show Notice when bt is off', (WidgetTester tester) async {
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((invocation) => _buildStreamFromBTState(BluetoothState.off));

    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pump();

    expect(btRadioOffFinder, findsOneWidget);
  });

  testWidgets('Should show Notice when bt permissions are not authorized',
      (WidgetTester tester) async {
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state)
        .thenAnswer((_) => _buildStreamFromBTState(BluetoothState.unauthorized));

    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pump();

    expect(btUnauthorizedFinder, findsOneWidget);
  });

  testWidgets('Should reflect most recent BT State',
      (WidgetTester tester) async {
    var streamController = StreamController<BluetoothState>();
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state)
        .thenAnswer((_) => streamController.stream);

    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    streamController.add(BluetoothState.on);
    streamController.add(BluetoothState.off);
    await tester.pump();

    expect(streamController.hasListener, true);
    expect(btRadioOffFinder, findsOneWidget);
  });

  //TODO STU: is 'changes' the correct word here? Looks like you are constructing the widget with the first state value being TRUE
  testWidgets('Should start scanning when bt state changes to on', (WidgetTester tester) async {

    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((invocation) => _buildStreamFromBTState(BluetoothState.on));

    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: deviceListPageContent,
        )));
    await tester.pump();

    verify(mockFlutterBlue.scan());
  });

  testWidgets('Should not start scanning when bt state changes to anything other than BluetoothState.on.', (WidgetTester tester) async {

    for(BluetoothState bt in BluetoothState.values) {
      if (bt != BluetoothState.on){
        var mockFlutterBlue = MockFlutterBlue();
        when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
        when(mockFlutterBlue.state).thenAnswer((invocation) => _buildStreamFromBTState(bt));

        var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: deviceListPageContent,
            )));
        await tester.pump();

        verifyNever(mockFlutterBlue.scan());
      }
    }

  });

  testWidgets('Should show real device on list', (WidgetTester tester) async {
    var device = MockBluetoothDevice();
    when(device.name).thenReturn("someDeviceName");
    when(device.id).thenReturn(DeviceIdentifier("12:34:56:78:90:12"));
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((invocation) => _buildStreamFromBTState(BluetoothState.on));
    when(mockFlutterBlue.scan()).thenAnswer(
        (_) => Stream.fromFuture(Future.value(ScanResult(device: device))));

    var deviceListPageContent = DeviceListPageContent(mockFlutterBlue);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: deviceListPageContent,
    )));
    await tester.pump();

    expect(find.widgetWithText(ListTile, "someDeviceName"), findsOneWidget);
  });

//TODO STU FIX THIS!!
//  testWidgets('Should clear discovered list when bt state changes to not be ON', (WidgetTester tester) async {
//    //ARRANGE
//    var mockFlutterBlue = MockFlutterBlue();
//
//    var device = MockBluetoothDevice();
//    when(device.name).thenReturn("Stus awesome car");
//    when(device.id).thenReturn(DeviceIdentifier("12:34:56:78:90:12"));
//
//    var streamController = StreamController<BluetoothState>();
//    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
//    when(mockFlutterBlue.state).thenAnswer((_) => new Future.value(BluetoothState.on));
//    when(mockFlutterBlue.onStateChanged()).thenAnswer((_) => streamController.stream);
//    when(mockFlutterBlue.scan()).thenAnswer(
//            (_) => Stream.fromFuture(Future.value(ScanResult(device: device))));
//
//    //ACT
//    await tester.pumpWidget(MaterialApp(
//        home: Scaffold(
//          body: DeviceListPageContent(mockFlutterBlue),
//        )));
//    await tester.pump();
//
//    //ASSERT
//    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsOneWidget);
//
//    //ACT
//    streamController.add(BluetoothState.off);
//    await tester.pump();
//
//    //ASSERT
//    expect(find.widgetWithText(ListTile, "Stus awesome car"), findsNothing);
//
//  });

  testWidgets('Should show activity spinner when scanning', (WidgetTester tester) async {
    //ARRANGE
    var stateStreamController = StreamController<BluetoothState>();
    stateStreamController.add(BluetoothState.off);
    var mockFlutterBlue = MockFlutterBlue();
    when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
    when(mockFlutterBlue.state).thenAnswer((_) => stateStreamController.stream);

    //ACT
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DeviceListPageContent(mockFlutterBlue),
        )));

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsNothing);

    //ACT
    stateStreamController.add(BluetoothState.on);
    await tester.pump();

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsOneWidget);

    //ACT
    stateStreamController.add(BluetoothState.off);
    await tester.pump();

    //ASSERT
    expect(find.byWidgetPredicate((w) => w is ProgressIndicator), findsNothing);

  });


}
