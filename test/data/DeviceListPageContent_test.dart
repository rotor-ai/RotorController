import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {

    var _sampleDevice = GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2");

    test("Should show one device", () {
      var state = DeviceListPageContentState([_sampleDevice]);
    });

}
