class RotorCommand {
  int throttleVal = 0;
  int headingVal = 0;
  ThrottleDirection throttleDir = ThrottleDirection.NEUTRAL;
  HeadingDirection headingDir = HeadingDirection.NEUTRAL;

  String toShorthand() {
    return ' ';
  }
}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, NEUTRAL, STARBOARD }
