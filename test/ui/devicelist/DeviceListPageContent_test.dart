
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {
  testWidgets('Should show no bluetooth warning', (WidgetTester tester) async {

    var deviceListPageContent = DeviceListPageContent();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: deviceListPageContent,)));

    //test something about the ui

  });
}
