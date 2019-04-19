import 'package:intl/intl.dart';

class RotorCommand {
  int _throttleVal = 2;
  get throttleVal => _throttleVal;

  int _headingVal = 2;
  get headingVal => _headingVal;
  
  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  RotorCommand(
      {int throttleVal = 0,
      int headingVal = 0,
      this.throttleDir = ThrottleDirection.NEUTRAL,
      this.headingDir = HeadingDirection.NEUTRAL}){
    
    this._throttleVal = throttleVal.clamp(0, 100);
    this._headingVal = headingVal.clamp(0, 100);
  }

  String toShorthand() {
    return throttleToShorthand() + ' ' + headingToShorthand();
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
