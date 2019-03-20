
class RotorCommand {
  final int throttleVal;
  final int headingVal;
  final ThrottleDirection throttleDir;
  final HeadingDirection headingDir;

  RotorCommand({this.throttleVal = 0, this.headingVal = 0, this.throttleDir = ThrottleDirection.NEUTRAL, this.headingDir = HeadingDirection.MIDDLE});

}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, MIDDLE, STARBOARD }