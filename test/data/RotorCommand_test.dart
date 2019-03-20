import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/RotorCommand.dart';

void main() {
  test("Should construct with default values", () {
    RotorCommand rotorCommand = RotorCommand();

    expect(rotorCommand.throttleVal, 0);
    expect(rotorCommand.headingVal, 0);
    expect(rotorCommand.throttleDir, ThrottleDirection.NEUTRAL);
    expect(rotorCommand.headingDir, HeadingDirection.MIDDLE);
  });

  //This is technically a constructor test... which is kinda stupid...
  test("Should construct with specified values", () {
    RotorCommand rotorCommand = RotorCommand(
        throttleVal: 10,
        headingVal: 20,
        throttleDir: ThrottleDirection.BACKWARD,
        headingDir: HeadingDirection.STARBOARD);


    expect(rotorCommand.throttleVal, 10);
    expect(rotorCommand.headingVal, 20);
    expect(rotorCommand.throttleDir, ThrottleDirection.BACKWARD);
    expect(rotorCommand.headingDir, HeadingDirection.STARBOARD);
  });



}
