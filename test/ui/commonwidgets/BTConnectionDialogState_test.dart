import 'dart:async';

import 'package:mobileclient/ui/commonwidgets/BTConnectionDialog.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mocks/RotorMocks.dart';

void main() {
  test("Should attempt connection upon building", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var mockDevice = buildMockDevice("ungabunga", "00:11:22:33:44:55");
    var state = BTConnectionDialogState(mockDevice, mockFlutterBlue);

    //ACT
    state.initState();

    //ASSERT
    verify(mockFlutterBlue.connect(mockDevice,
        autoConnect: false, timeout: Duration(seconds: 15)));
  });
}
