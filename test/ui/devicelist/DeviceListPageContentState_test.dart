import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

void main() {

    MockBluetoothDevice _buildMockDevice(String name, String id) {
      var device = MockBluetoothDevice();
      when(device.name).thenReturn(name);
      when(device.id).thenReturn(DeviceIdentifier(id));
      return device;
    }

    test("Should call scan on state construction", () {
      var mockFlutterBlue = MockFlutterBlue();
      var state = DeviceListPageContentState(mockFlutterBlue);

      verify(mockFlutterBlue.scan());
    });

    test("Should collect relevant info from FlutterBlue.Scan()", () {
      //ARRANGE
      var mockFlutterBlue = MockFlutterBlue();

      var mockBTDeviceAlpha = _buildMockDevice("DeviceAlpha", "00:00:00:00:00:00");
      var mockBTDeviceBravo = _buildMockDevice("DeviceBravo", "11:11:11:11:11:11");

      //ACT
      var state = DeviceListPageContentState(mockFlutterBlue);

      state.onScanResultReceived(ScanResult(device: mockBTDeviceAlpha, advertisementData: null, rssi: 1));

      //ASSERT
      expect(state.discoveredDevices.length, 1);
      expect(state.discoveredDevices[0].name, "DeviceAlpha");
      expect(state.discoveredDevices[0].id.id, "00:00:00:00:00:00");

      //ACT AGAIN
      state.onScanResultReceived(ScanResult(device: mockBTDeviceBravo, advertisementData: null, rssi: 1));

      //ASSERT AGAIN
      expect(state.discoveredDevices.length, 2);
      expect(state.discoveredDevices[0].name, "DeviceAlpha");
      expect(state.discoveredDevices[0].id.id, "00:00:00:00:00:00");
      expect(state.discoveredDevices[1].name, "DeviceBravo");
      expect(state.discoveredDevices[1].id.id, "11:11:11:11:11:11");
    });

}

//========== Mock definitions ==========

class MockFlutterBlue       extends Mock implements FlutterBlue       {}
class MockBluetoothDevice   extends Mock implements BluetoothDevice   {}