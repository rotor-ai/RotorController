import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/vehiclemonitor/subpage_controls.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/rotor_mocks.dart';


void main() {

  testWidgets('should construct page', (WidgetTester wt) async {
    var flutterBlue = FlutterBlue.instance;
    var mockDevice = MockBluetoothDevice();
    when(mockDevice.state).thenAnswer((_) => new StreamController<BluetoothDeviceState>().stream);
    await wt.pumpWidget(MaterialApp(home: SubpageControls(mockDevice, flutterBlue)));
  });

}