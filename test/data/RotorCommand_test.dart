import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/RotorCommand.dart';

void main() {
  test("Should construct with default values", () {
    RotorCommand rotorCommand = RotorCommand();

    expect(rotorCommand.throttle, 0);
    expect(rotorCommand.heading, 0);
    expect(rotorCommand.longitudinalDir, LongitudinalDirection.NEUTRAL);
    expect(rotorCommand.transverseDir, TransverseDirection.MIDDLE);
  });

  //This is technically a constructor test... which is kinda stupid...
  test("Should construct with specified values", () {
    RotorCommand rotorCommand = RotorCommand(
        throttle: 10,
        heading: 20,
        longitudinalDir: LongitudinalDirection.BACKWARD,
        transverseDir: TransverseDirection.STARBOARD);


    expect(rotorCommand.throttle, 10);
    expect(rotorCommand.heading, 20);
    expect(rotorCommand.longitudinalDir, LongitudinalDirection.BACKWARD);
    expect(rotorCommand.transverseDir, TransverseDirection.STARBOARD);
  });



}
