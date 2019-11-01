import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/data/vehicle_connection_info.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_controls_page_content.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_info_page_content.dart';
import 'package:mobileclient/ui/vehiclemonitor/vehicle_metrics_page_content.dart';

class VehicleMonitorPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return VehicleMonitorPageState();
  }
}

class VehicleMonitorPageState extends State<VehicleMonitorPage> {
  int _currentPage = 1;
  
  BluetoothDevice _device;
  BluetoothDevice get device => _device;
  FlutterBlue _flutterBlue;
  FlutterBlue get flutterBlue => _flutterBlue;

  VehicleMonitorPageState();
  VehicleMonitorPageState.using(this._device, this._flutterBlue);

  VehicleControlsPageContent vehicleControlsPageContent;


  void captureArgs(ModalRoute modalRoute) {
    VehicleConnectionInfo info = modalRoute.settings?.arguments;
    if (info != null){
      _device = info.device;
      _flutterBlue = info.flutterBlue;
    }
  }

  @override
  void initState() {
    super.initState();
    vehicleControlsPageContent = VehicleControlsPageContent(null, null);
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
        return VehicleMetricsPageContent();
        break;
      case 1:
        return vehicleControlsPageContent;
        break;
      case 2:
        return VehicleInfoPageContent();
        break;
    }
  }
}
