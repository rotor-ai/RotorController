import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/data/vehicle_connection_info.dart';
import 'package:mobileclient/ui/vehiclemonitor/controls_subpage.dart';
import 'package:mobileclient/ui/vehiclemonitor/info_subpage.dart';
import 'package:mobileclient/ui/vehiclemonitor/metrics_subpage.dart';

class MonitorPage extends StatefulWidget {

  BluetoothDevice _bluetoothDevice;
  FlutterBlue _flutterBlue;

  MonitorPage(this._bluetoothDevice, this._flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return MonitorPageState.using(this._bluetoothDevice, this._flutterBlue);
  }
}

class MonitorPageState extends State<MonitorPage> {
  int _currentPage = 1;
  
  BluetoothDevice _device;
  BluetoothDevice get device => _device;
  FlutterBlue _flutterBlue;
  FlutterBlue get flutterBlue => _flutterBlue;

  MonitorPageState();
  MonitorPageState.using(this._device, this._flutterBlue);

  ControlsSubpage vehicleControlsPageContent;

  @override
  void initState() {
    super.initState();
    vehicleControlsPageContent = ControlsSubpage(this._device, this._flutterBlue);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: _buildMonitorPage(_currentPage),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).highlightColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), title: Text("Metrics")),
          BottomNavigationBarItem(
              icon: Icon(Icons.gamepad), title: Text("Controls")),
          BottomNavigationBarItem(icon: Icon(Icons.info), title: Text("Info")),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        currentIndex: _currentPage,
      ),
    );
  }

  Widget _buildMonitorPage(int index) {
    switch(index){
      case 0:
        return MetricsSubpage();
        break;
      case 1:
        return vehicleControlsPageContent;
        break;
      case 2:
        return InfoSubpage();
        break;
    }
  }
}
