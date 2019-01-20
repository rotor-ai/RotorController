import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {

    test("Should call scan on state construction", () {
      var mockFlutterBlue = MockFlutterBlue();
      when(mockFlutterBlue.isAvailable).thenAnswer((_) => Future.value());//stubbing this out
      var state = DeviceListPageContentState(mockFlutterBlue);

      verify(mockFlutterBlue.scan());
    });

//    test("Should collect relevant info from FlutterBlue.Scan", () {
//      var mockFlutterBlue = MockFlutterBlue();
//      when(mockFlutterBlue.isAvailable).thenAnswer((_) => Future.value());//stubbing this out
//
//      var mockBTDeviceAlpha = MockBluetoothDevice();
//      when(mockBTDeviceAlpha.name).thenReturn("");
//      when(mockBTDeviceAlpha.id).thenReturn(DeviceIdentifier("00:00:00:00:00:00"));
//      when(mockBTDeviceAlpha.services)
//
//      var state = DeviceListPageContentState(mockFlutterBlue);
//
//      state.onScanResultReceived(ScanResult());
//
//      var expectedDevices = [
//        GenericBTDevice("DeviceAlpha",    "00:00:00:00:00:00", "some_random_uuid_a"),
//        GenericBTDevice("DeviceBravo",    "11:11:11:11:11:11", "some_random_uuid_b"),
//      ];
//
//    });
}

//========== Mock definitions ==========

class MockFlutterBlue       extends Mock implements FlutterBlue       {}
class MockBluetoothDevice   extends Mock implements BluetoothDevice   {}