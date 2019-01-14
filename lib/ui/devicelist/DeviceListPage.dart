import 'package:flutter/material.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPageContent.dart';

class DeviceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connect to a Device"),),
      body: DeviceListPageContent(),
    );
  }
}