import 'package:flutter/material.dart';
import 'package:mobileclient/Strings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/commonwidgets/DeviceRow.dart';
import 'package:mobileclient/ui/commonwidgets/Notice.dart';

class DeviceListPageContent extends StatefulWidget {
  final FlutterBlue _flutterBlueInstance;

  DeviceListPageContent(this._flutterBlueInstance);

  @override
  State<StatefulWidget> createState() {
    return DeviceListPageContentState(_flutterBlueInstance);
  }
}

class DeviceListPageContentState extends State<DeviceListPageContent> {
  //Members
  FlutterBlue _flutterBlue;
  List<BluetoothDevice> _discoveredDevices = [];
  bool _isBTSupported = true;
  BluetoothState _btState = BluetoothState.unknown;

  final BluetoothDevice _simulatorDevice = BluetoothDevice(
      id: DeviceIdentifier("00:00:00:00:00:00"),
      name: Strings.UI_VEHICLE_SIMULATOR,
      type: BluetoothDeviceType.unknown);

  //GETTERS
  List<BluetoothDevice> get discoveredDevices => _discoveredDevices;

  bool get bluetoothIsSupported => _isBTSupported;

  List<BluetoothDevice> get _compatibleDevices {
    List<BluetoothDevice> result = [_simulatorDevice];
    result.addAll(_discoveredDevices);
    return result;
  }

  //Constructor
  DeviceListPageContentState(this._flutterBlue);

  @override
  void initState() {
    super.initState();
    _flutterBlue.isAvailable?.then((value) => onIsAvailableResult(value));
    _flutterBlue.state?.then((v) {
      setState(() {
        updateBluetoothState(v);
      });
    });
    _flutterBlue.onStateChanged()?.listen((v) {
      setState(() {
        updateBluetoothState(v);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetColumn = <Widget>[];

    Notice headerNotice = buildListHeader(_btState);
    if (!_isBTSupported) {
      widgetColumn
          .add(Notice(title: Strings.UI_BT_NOT_AVAILABLE, color: Colors.red));
    } else if (headerNotice != null) {
      widgetColumn.add(headerNotice);
    } else if (_btState == BluetoothState.on) {
      widgetColumn.add(LinearProgressIndicator());
    }
    widgetColumn.add(Expanded(
        child: ListView.builder(
      itemBuilder: (BuildContext c, int i) {
        return _buildRow(c, i);
      },
      itemCount: _compatibleDevices.length,
    )));

    return Column(
      children: widgetColumn,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  //========== Helpers below this line ==========

  Widget _buildRow(BuildContext context, int index) {
    return DeviceRow(
        deviceName: _compatibleDevices[index].name,
        mac: _compatibleDevices[index].id.id);
  }

  Notice buildListHeader(BluetoothState state) {
    String title = buildTitleFromBluetoothState(state);
    if (title != null) {
      return Notice(title: title, color: Colors.orange);
    }
    return null;
  }

  @visibleForTesting
  void onScanResultReceived(ScanResult sr) {
    setState(() {
      _discoveredDevices = updatedDeviceList(_discoveredDevices, sr);
    });
  }

  @visibleForTesting
  void updateBluetoothState(BluetoothState updatedState) {
    _btState = updatedState;

    if (_btState == BluetoothState.on) {
      _flutterBlue.scan()?.listen((result) => onScanResultReceived(result));
    }
  }

  @visibleForTesting
  String buildTitleFromBluetoothState(BluetoothState state) {
    switch (state) {
      case BluetoothState.unavailable:
        return Strings.UI_BT_NOT_AVAILABLE;
        break;
      case BluetoothState.unauthorized:
        return Strings.UI_BT_NOT_AUTHORIZED;
        break;
      case BluetoothState.off:
      case BluetoothState.turningOff:
        return Strings.UI_BT_RADIO_IS_OFF;
      default:
        return null;
        break;
    }
  }

  @visibleForTesting
  void onIsAvailableResult(bool result) {
    setState(() {
      _isBTSupported = result;
    });
  }

  @visibleForTesting
  List<BluetoothDevice> updatedDeviceList(
      List<BluetoothDevice> list, ScanResult sr) {
    List<BluetoothDevice> result = [];
    result.addAll(list);

    bool alreadyContainsThisDevice = result.indexWhere((element) {
          return element.id.id == sr.device.id.id;
        }) !=
        -1;
    if (!alreadyContainsThisDevice) {
      if (sr.device.name != null && sr.device.name.isNotEmpty) {
        result.add(sr.device);
      }
    }

    return result;
  }
}
