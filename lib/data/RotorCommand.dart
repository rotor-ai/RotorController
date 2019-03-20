import 'package:intl/intl.dart';
import 'dart:math';

class RotorCommand {
  get throttleVal => _throttleVal;

  get headingVal => _headingVal;

  int _throttleVal;
  int _headingVal;
  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  RotorCommand(
      {throttleVal = 0,
      headingVal = 0,
      this.throttleDir = ThrottleDirection.NEUTRAL,
      this.headingDir = HeadingDirection.MIDDLE}) {
    _throttleVal = num.parse(throttleVal.toString()).clamp(0, 100).toInt();
    _headingVal = num.parse(headingVal.toString()).clamp(0, 100).toInt();
  }

  toShorthand() {
    String throttleDirSymbol;
    switch (throttleDir) {
      case ThrottleDirection.FORWARD:
        throttleDirSymbol = 'F';
        break;
      case ThrottleDirection.BACKWARD:
        throttleDirSymbol = 'B';
        break;
      default:
        throttleDirSymbol = 'N';
    }

    String headingDirSymbol;
    switch (headingDir) {
      case HeadingDirection.PORT:
        headingDirSymbol = 'L';
        break;
      case HeadingDirection.MIDDLE:
        headingDirSymbol = 'N';
        break;
      default:
        headingDirSymbol = 'R';
    }

    NumberFormat outputFormat = NumberFormat();
    outputFormat.maximumIntegerDigits = 3;
    outputFormat.minimumIntegerDigits = 3;

    return throttleDirSymbol +
        outputFormat.format(throttleVal) +
        " " +
        headingDirSymbol +
        outputFormat.format(headingVal);
  }
}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, MIDDLE, STARBOARD }
