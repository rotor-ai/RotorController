import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/ui/commonwidgets/Notice.dart';

class VehicleMonitorPageContent extends StatefulWidget {
  final BluetoothDevice device;
  final FlutterBlue flutterBlue;

  VehicleMonitorPageContent(this.device, this.flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return VehicleMonitorPageContentState();
  }
}

class VehicleMonitorPageContentState extends State<VehicleMonitorPageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Notice(
          title: "Status",
          color: Colors.green,
        ),
        Container(
          padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Text(
                "0 Mph",
                textScaleFactor: 2,
              )),
            ),
            Expanded(
                child: Center(
                    child: Text(
              "0% Acc",
              textScaleFactor: 2,
            )))
          ],
        ))
      ],
    );
  }
}
