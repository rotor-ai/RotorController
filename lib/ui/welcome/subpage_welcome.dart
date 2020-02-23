import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        ConstrainedBox(constraints: BoxConstraints(maxHeight: 80), child: SvgPicture.asset('resources/images/logo-words-dark.svg')),
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
