
class RotorCommand {
  get throttleMag => 0;
  get headingMag => 0;
  get longitudinalDir => LongitudinalDirection.NEUTRAL;
  get transverseDir => TransverseDirection.MIDDLE;

}

enum LongitudinalDirection { FORWARD, NEUTRAL, BACKWARD }
enum TransverseDirection { PORT, MIDDLE, STARBOARD }