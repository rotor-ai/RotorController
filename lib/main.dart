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

  var _rotorAppTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blue.shade500,
    accentColor: Colors.blue.shade300
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: _rotorAppTheme,
      home: WelcomePage()
    );
  }
}