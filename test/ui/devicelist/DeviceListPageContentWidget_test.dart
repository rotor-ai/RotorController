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

  testWidgets('Should show bluetooth warning when bt is not available',
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