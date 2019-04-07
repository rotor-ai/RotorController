import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleControlsPageContent.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleInfoPageContent.dart';
import 'package:mobileclient/ui/vehiclemonitor/VehicleMetricsPageContent.dart';

class VehicleMonitorPage extends StatefulWidget {
  final BluetoothDevice _device;
  final FlutterBlue _flutterBlue;

  VehicleMonitorPage(this._device, this._flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return VehicleMonitorPageState();
  }
}

class VehicleMonitorPageState extends State<VehicleMonitorPage> {
  int _currentPage = 1;
  
  VehicleControlsPageContent vehicleControlsPageContent;

  @override
  void initState() {
    super.initState();
    vehicleControlsPageContent = VehicleControlsPageContent(this.widget._device, this.widget._flutterBlue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget._device.name),
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
