import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobileclient/Strings.dart';
import 'package:mobileclient/ui/welcome/WelcomePage.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;

  runApp(RotorApp());
}

// ignore: must_be_immutable
class RotorApp extends StatelessWidget {
  static const int _primaryColorValue = 0xFF59EFDD;
  static const int _secondaryColorValue = 0xFF3383BC;
  static const Color _primaryColor = Color(_primaryColorValue);
  static const Color _secondaryColor = Color(_secondaryColorValue);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var primarySwatch = MaterialColor(_primaryColorValue, <int, Color>{
      50: Color(0xFFDCFBF8),
      100: Color(0xFFA6F5EA),
      200: Color(_primaryColorValue),
      300: Color(0xFF00E5CD),
      400: Color(0xFF00DABE),
      500: Color(0xFF00CFAF),
      600: Color(0xFF00C0A0),
      700: Color(0xFF00AD8D),
      800: Color(0xFF009C7D),
      900: Color(0xFF007E5D),
    });

    var secondarySwatch = MaterialColor(_secondaryColorValue, <int, Color>{
      50: Color(0xFFE2F4FB),
      100: Color(0xFFB6E3F6),
      200: Color(0xFF89D0EF),
      300: Color(0xFF62BEE7),
      400: Color(0xFF4CB0E3),
      500: Color(0xFF3FA3DE),
      600: Color(0xFF3A96D0),
      700: Color(_secondaryColorValue),
      800: Color(0xFF2F72A8),
      900: Color(0xFF255385),
    });

    var _rotorAppTheme = ThemeData(
        brightness: Brightness.light,
        primaryColor: _primaryColor,
        primarySwatch: primarySwatch,
        buttonColor: _secondaryColor,
        highlightColor: _secondaryColor);

    return MaterialApp(
        theme: _rotorAppTheme, home: WelcomePage(), title: Strings.APP_TITLE);
  }
}
