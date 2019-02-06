import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/Strings.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

import '../../mocks/RotorMocks.dart';

void main() {
  MockBluetoothDevice _buildMockDevice(String name, String id) {
    var device = MockBluetoothDevice();
    when(device.name).thenReturn(name);
    when(device.id).thenReturn(DeviceIdentifier(id));
    return device;
  }

  test("Should call scan on initState", () {
    var mockFlutterBlue = MockFlutterBlue();
    var state = DeviceListPageContentState(mockFlutterBlue);

    verifyNever(mockFlutterBlue.scan());

    state.initState();

    verify(mockFlutterBlue.scan());
  });

  test("Should collect relevant info from FlutterBlue.Scan()", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();

    var mockBTDeviceAlpha =
        _buildMockDevice("DeviceAlpha", "00:00:00:00:00:00");
    var mockBTDeviceBravo =
        _buildMockDevice("DeviceBravo", "11:11:11:11:11:11");

    //ACT
    var state = DeviceListPageContentState(mockFlutterBlue);

    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceAlpha, advertisementData: null, rssi: 1));

    //ASSERT
    expect(state.discoveredDevices.length, 1);
    expect(state.discoveredDevices[0].name, "DeviceAlpha");
    expect(state.discoveredDevices[0].id.id, "00:00:00:00:00:00");

    //ACT AGAIN
    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceBravo, advertisementData: null, rssi: 1));

    //ASSERT AGAIN
    expect(state.discoveredDevices.length, 2);
    expect(state.discoveredDevices[0].name, "DeviceAlpha");
    expect(state.discoveredDevices[0].id.id, "00:00:00:00:00:00");
    expect(state.discoveredDevices[1].name, "DeviceBravo");
    expect(state.discoveredDevices[1].id.id, "11:11:11:11:11:11");
  });

  test("Should not save devices without a name", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var mockBTDeviceAlpha = _buildMockDevice("", "00:00:00:00:00:00");
    var mockBTDeviceBravo = _buildMockDevice(null, "11:11:11:11:11:11");

    //ACT
    var state = DeviceListPageContentState(mockFlutterBlue);
    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceAlpha, advertisementData: null, rssi: 1));
    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceBravo, advertisementData: null, rssi: 1));

    //ASSERT
    expect(state.discoveredDevices.length, 0);
  });

  test("Should not save devices with the same MAC", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var mockBTDeviceAlpha =
        _buildMockDevice("DeviceAlpha", "00:00:00:00:00:00");
    var mockBTDeviceBravo =
        _buildMockDevice("DeviceBravo", "00:00:00:00:00:00");

    //ACT
    var state = DeviceListPageContentState(mockFlutterBlue);
    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceAlpha, advertisementData: null, rssi: 1));
    state.onScanResultReceived(ScanResult(
        device: mockBTDeviceBravo, advertisementData: null, rssi: 1));

    //ASSERT
    expect(state.discoveredDevices.length, 1);
    expect(state.discoveredDevices[0].name, "DeviceAlpha");
    expect(state.discoveredDevices[0].id.id, "00:00:00:00:00:00");
  });

  test("Should return appropriate title based on BT state", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var state = DeviceListPageContentState(mockFlutterBlue);

    //ASSERT

    expect(state.buildTitleFromBluetoothState(BluetoothState.unknown), isNull);
    expect(state.buildTitleFromBluetoothState(BluetoothState.unavailable), Strings.UI_BT_NOT_AVAILABLE);
    expect(state.buildTitleFromBluetoothState(BluetoothState.unauthorized), Strings.UI_BT_NOT_AUTHORIZED);
    expect(state.buildTitleFromBluetoothState(BluetoothState.turningOn), isNull);
    expect(state.buildTitleFromBluetoothState(BluetoothState.on), isNull);
    expect(state.buildTitleFromBluetoothState(BluetoothState.turningOff), Strings.UI_BT_RADIO_IS_OFF);
    expect(state.buildTitleFromBluetoothState(BluetoothState.off), Strings.UI_BT_RADIO_IS_OFF);

  });

  test("Should not return notice for null title", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var state = DeviceListPageContentState(mockFlutterBlue);

    //ASSERT
    expect(state.buildListHeader(BluetoothState.unknown), isNull);
    expect(state.buildListHeader(BluetoothState.unavailable), isNotNull);

  });


}
