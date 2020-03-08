import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../strings.dart';

class SubpageAbout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubpageAboutState(PackageInfo.fromPlatform());
  }
}

class SubpageAboutState extends State<SubpageAbout> {

  Future<PackageInfo> packageInfoPromise;
  PackageInfo packageInfo;

  SubpageAboutState(this.packageInfoPromise);


  @override
  void initState() {
    packageInfoPromise.then((v) => changeState(this, () => {packageInfo = v}));
  }

  Function changeState = (SubpageAboutState state, Function f) {
    state.setState(() {
      f();
    });
  };

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Column(children: <Widget>[
            Text(Strings.APP_TITLE, style: TextStyle(fontSize: 30)),
            Text(Strings.TAG_LINE),
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child:Text('version:${this.packageInfo.version} (build ${this.packageInfo.buildNumber})', textAlign: TextAlign.center,)
            )
          ])),
      Expanded(child: DependencyListView())
    ]);
  }
}

class DependencyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (c, i) => ListTile(
              title: Text("yeet"),
            ));
  }
}
