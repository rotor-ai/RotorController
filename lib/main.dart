import 'package:flutter/material.dart';
import 'package:mobileclient/ui/welcome/WelcomePage.dart';
import 'package:flutter/rendering.dart';

void main(){
  debugPaintSizeEnabled         = false;
  debugPaintBaselinesEnabled    = false;
  debugPaintLayerBordersEnabled = false;
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: WelcomePage()
    );
  }
}