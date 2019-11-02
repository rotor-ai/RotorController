import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/strings.dart';
import 'package:mobileclient/ui/devicelist/device_list_page_content.dart';

class DeviceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.UI_CONNECT_TO_VEHICLE),
      ),
      body: DeviceListPageContent(FlutterBlue.instance),
    );
  }
}
