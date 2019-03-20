
import 'package:intl/intl.dart';

class RotorCommand {
  final int throttleVal;
  final int headingVal;
  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  RotorCommand({this.throttleVal = 0, this.headingVal = 0, this.throttleDir = ThrottleDirection.NEUTRAL, this.headingDir = HeadingDirection.MIDDLE});

  toShorthand() {
    String throttleDirSymbol;
    switch(throttleDir){
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
    switch(headingDir){
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

    return throttleDirSymbol + outputFormat.format(throttleVal) + " " + headingDirSymbol + outputFormat.format(headingVal);
  }

}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, MIDDLE, STARBOARD }