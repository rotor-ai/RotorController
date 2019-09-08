import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/strings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/commonwidgets/bt_connection_dialog.dart';
import 'package:mobileclient/ui/commonwidgets/device_row.dart';
import 'package:mobileclient/ui/commonwidgets/notice.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_monitor_page.dart';

class DeviceListPageContent extends StatefulWidget {
  final FlutterBlue _flutterBlueInstance;
  DeviceListPageContent(this._flutterBlueInstance);//Constructor

  @override
  State<StatefulWidget> createState() {
    return DeviceListPageContentState(_flutterBlueInstance);
  }
}

class DeviceListPageContentState extends State<DeviceListPageContent> {
  //Members
  List<BluetoothDevice> _discoveredDevices = [];
  bool _isBluetoothAvailableForThisDevice = true;
  FlutterBlue _flutterBlue;
  BluetoothState _btState = BluetoothState.unknown;
  StreamSubscription<ScanResult> _btScanSubscription;

  //GETTERS
  List<BluetoothDevice> get discoveredDevices => _discoveredDevices;

  List<BluetoothDevice> get _compatibleDevices {
    List<BluetoothDevice> result = [];
    result.addAll(_discoveredDevices);
    return result;
  }

  //Constructor
  DeviceListPageContentState(this._flutterBlue);

  @override
  void initState() {
    super.initState();
    _flutterBlue.isAvailable?.then((value) => _onIsAvailableResult(value));
    _flutterBlue.state?.listen((btState) => updateBluetoothState(btState));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetColumn = <Widget>[];

    var header = _buildListHeader();
    if (header != null){
      widgetColumn.add(header);
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


  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  } //========== Helpers below this line ==========

  Widget _buildRow(BuildContext context, int index) {
    return DeviceRow(
      deviceName: _compatibleDevices[index].name,
      mac: _compatibleDevices[index].id.id,
      onTap: () {
        _stopScanning();

        var deviceToConnectTo = _compatibleDevices[index];

        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (buildContext) =>
                BTConnectionDialog(deviceToConnectTo, _flutterBlue));

      },
    );
  }

  Notice _buildListHeader() {
    if (!_isBluetoothAvailableForThisDevice){
      return Notice(title: Strings.UI_BT_NOT_AVAILABLE, color: Colors.orange);
    }
    var noticeTitle = buildTitleFromBluetoothState(_btState);
    if (noticeTitle != null) {
      return Notice(title: noticeTitle, color: Colors.orange);
    }
    return null;
  }

  void _stopScanning() {
    _btScanSubscription?.cancel()?.then((v) {
      if (mounted) {
        setState(() {
          _btScanSubscription = null;
        });
      }
    });
  }

  @visibleForTesting
  void onScanResultReceived(ScanResult sr) {
    setState(() {
      _discoveredDevices = updatedDeviceList(_discoveredDevices, sr);
    });
  }

  void updateBluetoothState(BluetoothState updatedState) {
    setState( (){ _btState = updatedState; });

    if (updatedState == BluetoothState.on) {
      _flutterBlue.scan().listen((scanResult) => onScanResultReceived(scanResult));
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

  void _onIsAvailableResult(bool result) {
    setState(() {
      _isBluetoothAvailableForThisDevice = result;
    });
  }

  //A pure function that builds a new device list, when provided a scan result
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
