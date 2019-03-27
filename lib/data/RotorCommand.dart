import 'package:intl/intl.dart';

class RotorCommand {
  int _throttleVal;
  int _headingVal;

  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  get throttleVal => _throttleVal;

  get headingVal => _headingVal;

  RotorCommand(
      {throttleVal = 0,
      headingVal = 0,
      this.throttleDir = ThrottleDirection.NEUTRAL,
      this.headingDir = HeadingDirection.MIDDLE}) {
    _throttleVal = num.parse(throttleVal.toString()).clamp(0, 100).toInt();
    _headingVal = num.parse(headingVal.toString()).clamp(0, 100).toInt();
  }

  toShorthand() {
    NumberFormat outputFormat = NumberFormat();
    outputFormat.maximumIntegerDigits = 3;
    outputFormat.minimumIntegerDigits = 3;

    return _abbreviateThrottleDir(throttleDir) +
        outputFormat.format(throttleVal) +
        " " +
        _abbreviateHeadingDir(headingDir) +
        outputFormat.format(headingVal);
  }

  String _abbreviateThrottleDir(ThrottleDirection td) {
    switch (td) {
      case ThrottleDirection.FORWARD:
        return 'F';
        break;
      case ThrottleDirection.BACKWARD:
        return 'B';
        break;
      default:
        return 'N';
    }
  }

  String _abbreviateHeadingDir(HeadingDirection hd) {
    switch (hd) {
      case HeadingDirection.PORT:
        return 'L';
        break;
      case HeadingDirection.MIDDLE:
        return 'N';
        break;
      default:
        return 'R';
    }
  }
}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, MIDDLE, STARBOARD }
