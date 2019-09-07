import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/strings.dart';
import 'package:mockito/mockito.dart';
import 'package:mobileclient/ui/devicelist/device_list_page_content.dart';

import '../../mocks/rotor_mocks.dart';

void main() {

  test("Should not save devices without a name", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var scanResultA = ScanResult(device: buildMockDevice("", "00:00:00:00:00:00"), advertisementData: null, rssi: 0);
    var scanResultB = ScanResult(device: buildMockDevice(null, "11:11:11:11:11:11"), advertisementData: null, rssi: 0);

    //ACT
    var state = DeviceListPageContentState(mockFlutterBlue);
    List<BluetoothDevice> initList = [];
    List<BluetoothDevice> updatedDiscoveryList = state.updatedDeviceList(initList, scanResultA);
    updatedDiscoveryList = state.updatedDeviceList(updatedDiscoveryList, scanResultB);

    //ASSERT
    expect(initList.length, 0);
    expect(updatedDiscoveryList.length, 0);
  });

  test("Should not save devices with the same MAC", () {
    //ARRANGE
    var mockFlutterBlue = MockFlutterBlue();
    var scanResultA =
        ScanResult(device: buildMockDevice("DeviceAlpha", "00:00:00:00:00:00"), advertisementData: null, rssi: 1);
    var scanResultB =
        ScanResult(device: buildMockDevice("DeviceBravo", "00:00:00:00:00:00"), advertisementData: null, rssi: 1);

    //ACT
    var state = DeviceListPageContentState(mockFlutterBlue);
    List<BluetoothDevice> initialList = [];
    List<BluetoothDevice> updatedDeviceList = state.updatedDeviceList(initialList, scanResultA);
    updatedDeviceList = state.updatedDeviceList(updatedDeviceList, scanResultB);

    //ASSERT
    expect(initialList.length, 0);//ensure that updatedDeviceList is a pure function; that it doesn't change the parameter it's given
    expect(updatedDeviceList.length, 1);
    expect(updatedDeviceList[0].name, "DeviceAlpha");
    expect(updatedDeviceList[0].id.id, "00:00:00:00:00:00");
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

}
