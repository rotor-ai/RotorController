import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {

    var _sampleDevice = GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2");

    test("Should test something about the state??? idk", () {
      var mockFlutterBlue = MockFlutterBlue();
      when(mockFlutterBlue.isAvailable).thenAnswer((_) => new Future.value(true));
      var state = DeviceListPageContentState(mockFlutterBlue);

    });
}


//========== Mock definitions ==========

class MockFlutterBlue extends Mock implements FlutterBlue {}