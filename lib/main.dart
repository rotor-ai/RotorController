import 'package:flutter/material.dart';
import 'package:mobileclient/ui/welcome/WelcomePage.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = true;
  debugPaintLayerBordersEnabled = true;

  runApp(RotorApp());
}

// ignore: must_be_immutable
class RotorApp extends StatelessWidget {
  var _rotorAppTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.blue.shade500, accentColor: Colors.blue.shade300);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: _rotorAppTheme, home: WelcomePage());
  }
}
