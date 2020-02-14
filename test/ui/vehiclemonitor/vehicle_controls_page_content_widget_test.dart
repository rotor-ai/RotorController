import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/rotor_command.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_controls_page_content.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';


void main() {

  Stream<BluetoothDeviceState> _buildStreamFromBTDeviceState(BluetoothDeviceState btState){
    var streamController = StreamController<BluetoothDeviceState>();
    streamController.add(btState);
    return streamController.stream;
  }

//
//TODO STU FIX: This should be a unit test, not a widget test
//  testWidgets("should run default command on startup", (WidgetTester tester) async {
//    //ARRANGE
//    var mockFlutterBlue = MockFlutterBlue();
//    var mockDevice = MockBluetoothDevice();
//    StreamController<BluetoothDeviceState> streamController = StreamController<BluetoothDeviceState>();
//    when(mockDevice.state).thenAnswer((_) => Future.value(BluetoothDeviceState.connecting));
//    when(mockDevice.onStateChanged()).thenAnswer((_) => streamController.stream);
//
//    await tester.pumpWidget(MaterialApp(
//      home: Scaffold(
//        body: VehicleControlsPageContent(mockDevice, mockFlutterBlue),
//      )
//    ));
//
//    //ASSERT
//    expect(find.text(RotorCommand().toShorthand()), findsOneWidget);
//
//  });

}