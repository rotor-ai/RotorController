import 'package:flutter/material.dart';

import '../../strings.dart';

class SubpageAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 16, bottom: 16), child: 
          Column(children: <Widget>[
            Text(Strings.APP_TITLE,style: TextStyle(fontSize: 30),),
            Text("Open Source Autonomous Driving Project")
          ])
        ),
        Expanded(child:DependencyListView())
    ]);
  }
}

class DependencyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (c, i) => ListTile(
              title: Text("yeet"),
            ));
  }
}
