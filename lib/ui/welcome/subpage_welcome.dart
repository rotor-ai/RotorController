import 'package:flutter/material.dart';
import 'package:mobileclient/ui/devicelist/page_device_list.dart';
import 'package:mobileclient/strings.dart';

class SubpageWelcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubpageWelcomeState();
  }
}

class SubpageWelcomeState extends State<SubpageWelcome> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Padding(
          child: Text(
            Strings.APP_TITLE,
            textScaleFactor: 3.0,
          ),
          padding: EdgeInsets.only(top: 0.0, bottom: 16.0),
        ),
        RaisedButton(
          child: Text(Strings.UI_CONNECT_TO_VEHICLE),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext c) {
              return PageDeviceList();
            }));
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
