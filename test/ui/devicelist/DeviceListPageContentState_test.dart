import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/data/GenericBTDevice.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {

    var _sampleDevice = GenericBTDevice("Some Device", "00:00:00:00:00:00", "4a14c657-e073-4432-a633-487233362fb2");

    test("State should call scan on setup", () {
      var mockFlutterBlue = MockFlutterBlue();
      var isAvailableFuture = Future.value(true);
      when(mockFlutterBlue.isAvailable).thenAnswer((_) => isAvailableFuture);//stubbing this out
      var state = DeviceListPageContentState(mockFlutterBlue);

      verify(mockFlutterBlue.scan());
    });
}

//========== Mock definitions ==========

class MockFlutterBlue extends Mock implements FlutterBlue {}