
class RotorCommand {
  final int throttle;
  final int heading;
  final LongitudinalDirection longitudinalDir;
  final TransverseDirection transverseDir;

  RotorCommand({this.throttle = 0, this.heading = 0, this.longitudinalDir = LongitudinalDirection.NEUTRAL, this.transverseDir = TransverseDirection.MIDDLE});

}

enum LongitudinalDirection { FORWARD, NEUTRAL, BACKWARD }
enum TransverseDirection { PORT, MIDDLE, STARBOARD }