import 'package:flutter/material.dart';
import 'package:mobileclient/ui/welcome/WelcomePageContent.dart';

class WelcomePage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomePageState();
  }

  
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WelcomePageContent());
  }
}