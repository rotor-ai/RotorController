import 'package:flutter/material.dart';
import 'package:mobileclient/Strings.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
    _flutterBlue.state?.then((value) => onBTStateChanged(value));
    _flutterBlue.onStateChanged()?.listen((v) => onBTStateChanged(v));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetColumn = <Widget>[];

    Notice headerNotice = buildListHeader(_btState);
    if (!_isBTSupported) {
      widgetColumn.add(Notice(Strings.UI_BT_NOT_AVAILABLE, Colors.red));
    } else if (headerNotice != null) {
      widgetColumn.add(headerNotice);
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
    return ListTile(
      title: Text(_compatibleDevices[index].name),
      subtitle: Text(_compatibleDevices[index].id.id),
    );
  }

  @visibleForTesting
  void onScanResultReceived(ScanResult sr) {
    if (sr.device.name != null && sr.device.name.isNotEmpty) {
      var alreadyExistsInList = (_discoveredDevices.fold(
              0,
              (acc, device) =>
                  acc + ((sr.device.id.id == device.id.id) ? 1 : 0))) >
          0;
      if (!alreadyExistsInList) {
        //This really sucks, but it's the only way I can think of to allow testing this method
        //I have to check if the state is mounted before calling setState
        if (this.mounted) {
          setState(() {
            _discoveredDevices.add(sr.device);
          });
        } else {
          _discoveredDevices.add(sr.device);
        }
      }
    }
  }

  void onBTStateChanged(BluetoothState updatedState) {
    if (mounted) {
      setState(() {
        _btState = updatedState;
      });
    } else {
      _btState = updatedState;
    }
    if (_btState == BluetoothState.on) {
      _flutterBlue.scan()?.listen((result) => onScanResultReceived(result));
    }
  }

  Notice buildListHeader(BluetoothState state) {
    String title = buildTitleFromBluetoothState(state);
    if (title != null) {
      return Notice(title, Colors.orange);
    }
    return null;
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
    if (this.mounted) {
      setState(() {
        _isBTSupported = result;
      });
    }
  }
}
