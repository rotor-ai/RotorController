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
}

enum ThrottleDirection { FORWARD, NEUTRAL, BACKWARD }
enum HeadingDirection { PORT, NEUTRAL, STARBOARD }
