import 'package:flutter/material.dart';

class WelcomePageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageContentState();
  }
}

class WelcomePageContentState extends State<WelcomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Center(child: 
        Column(children: <Widget>[
            Padding(child: Text("rotor.ai", textScaleFactor: 3.0,), padding: EdgeInsets.only(top: 0.0, bottom: 16.0), ),
            RaisedButton(child: Text("Connect to Vehicle"), onPressed: () {
              Scaffold.of(this.context).showSnackBar(SnackBar(content: Text("HI")));
            },)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
    );
  }
  
}