import 'package:intl/intl.dart';

class RotorCommand {
  int throttleVal = 2;
  int headingVal = 2;
  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  RotorCommand(
      {this.throttleVal = 0,
      this.headingVal = 0,
      this.throttleDir = ThrottleDirection.NEUTRAL,
      this.headingDir = HeadingDirection.NEUTRAL});

  String toShorthand() {
    return ' ';
  }

  String throttleToShorthand() {
    String abv = '';
    switch(this.throttleDir){
      case ThrottleDirection.FORWARD:
        abv = 'F';
        break;
      case ThrottleDirection.BACKWARD:
        abv = 'B';
        break;
      default:
        abv = 'N';
        break;
    }

    return abv +_formatInt(throttleVal);
  }

  String headingToShorthand() {
    String abv = '';
    switch(this.headingDir) {
      case HeadingDirection.PORT:
        abv = 'L';
        break;
      case HeadingDirection.STARBOARD:
        abv = 'R';
        break;
      default:
        abv = 'N';
        break;
    }
    
    return abv + _formatInt(headingVal);
  }

  String _formatInt(int i) {
    NumberFormat numberFormat = NumberFormat();
    numberFormat.minimumIntegerDigits = 3;
    numberFormat.maximumIntegerDigits = 3;
    return numberFormat.format(i);
  }

}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, NEUTRAL, STARBOARD }
