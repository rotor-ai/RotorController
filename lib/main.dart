import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobileclient/Strings.dart';
import 'package:mobileclient/ui/welcome/WelcomePage.dart';
import 'package:mobileclient/RotorUtils.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;

  runApp(RotorApp());
}

// ignore: must_be_immutable
class RotorApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tealSwatch = MaterialColor(RotorUtils.ROTOR_TEAL_VALUE, <int, Color>{
      50: Color(0xFFDCFBF8),
      100: Color(0xFFA6F5EA),
      200: RotorUtils.ROTOR_TEAL_COLOR,
      300: Color(0xFF00E5CD),
      400: Color(0xFF00DABE),
      500: Color(0xFF00CFAF),
      600: Color(0xFF00C0A0),
      700: Color(0xFF00AD8D),
      800: Color(0xFF009C7D),
      900: Color(0xFF007E5D),
    });

    var blueSwatch = MaterialColor(RotorUtils.ROTOR_BLUE_VALUE, <int, Color>{
      50: Color(0xFFE2F4FB),
      100: Color(0xFFB6E3F6),
      200: Color(0xFF89D0EF),
      300: Color(0xFF62BEE7),
      400: Color(0xFF4CB0E3),
      500: Color(0xFF3FA3DE),
      600: Color(0xFF3A96D0),
      700: RotorUtils.ROTOR_BLUE_COLOR,
      800: Color(0xFF2F72A8),
      900: Color(0xFF255385),
    });

    var _rotorAppTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: RotorUtils.ROTOR_BLUE_COLOR,
        primarySwatch: blueSwatch,
        buttonColor: RotorUtils.ROTOR_TEAL_COLOR,
        highlightColor: RotorUtils.ROTOR_TEAL_COLOR);

    return MaterialApp(
        theme: _rotorAppTheme, home: WelcomePage(), title: Strings.APP_TITLE);
  }
}
