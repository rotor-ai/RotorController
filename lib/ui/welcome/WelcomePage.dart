import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:ListView.builder(itemBuilder: (BuildContext context, int index) {
        ListTile(title: Text("Some device"),);
      },
      itemCount: 1,
      )
    );
  }
}