import 'package:flutter/material.dart';
import 'package:mobileclient/ui/devicelist/DeviceListPage.dart';
import 'package:mobileclient/Strings.dart';

class WelcomePageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageContentState();
  }
}

class WelcomePageContentState extends State<WelcomePageContent> {
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
          child: Text(Strings.UI_CONNECT_TO_VEHICLE_BTN),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext c) {
              return DeviceListPage();
            }));
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
