import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/RotorCommand.dart';

void main() {

  test("Should construct with default values", () {

    RotorCommand rotorCommand = RotorCommand();

    expect(rotorCommand.throttleMag, 0);
    expect(rotorCommand.headingMag, 0);
    expect(rotorCommand.longitudinalDir, LongitudinalDirection.NEUTRAL);
    expect(rotorCommand.transverseDir, TransverseDirection.MIDDLE);
  });

}