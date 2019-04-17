import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/rotor_command.dart';

void main() {
  test("Should construct with default values", () {
    //ARRANGE
    var rotorCommand = RotorCommand();

    //ACT & ASSERT
    expect(rotorCommand.throttleVal, 0);
    expect(rotorCommand.headingVal, 0);
    expect(rotorCommand.throttleDir, ThrottleDirection.NEUTRAL);
    expect(rotorCommand.headingDir, HeadingDirection.NEUTRAL);
  });

  test("Should construct with specified values", () {
    //ARRANGE
    var rotorCommand = RotorCommand(
        throttleVal: 10,
        headingVal: 20,
        throttleDir: ThrottleDirection.BACKWARD,
        headingDir: HeadingDirection.STARBOARD);

    //ACT & ASSERT
    expect(rotorCommand.throttleVal, 10);
    expect(rotorCommand.headingVal, 20);
    expect(rotorCommand.throttleDir, ThrottleDirection.BACKWARD);
    expect(rotorCommand.headingDir, HeadingDirection.STARBOARD);
  });

  test("Should produce correct shorthand for throttle direction", () {
    
    expect(RotorCommand(throttleDir: ThrottleDirection.FORWARD).throttleToShorthand(), 'F000');
    expect(RotorCommand(throttleDir: ThrottleDirection.NEUTRAL).throttleToShorthand(), 'N000');
    expect(RotorCommand(throttleDir: ThrottleDirection.BACKWARD).throttleToShorthand(), 'B000');

  });

  test("Should produce correct shorthand for throttle value", () {

    expect(RotorCommand(throttleVal: 0).throttleToShorthand(), 'N000');
    expect(RotorCommand(throttleVal: 1).throttleToShorthand(), 'N001');
    expect(RotorCommand(throttleVal: 12).throttleToShorthand(), 'N012');
    expect(RotorCommand(throttleVal: 100).throttleToShorthand(), 'N100');

  });

  test("Should produce correct shorthand for heading direction", () {

    expect(RotorCommand(headingDir: HeadingDirection.PORT).headingToShorthand(), 'L000');
    expect(RotorCommand(headingDir: HeadingDirection.NEUTRAL).headingToShorthand(), 'N000');
    expect(RotorCommand(headingDir: HeadingDirection.STARBOARD).headingToShorthand(), 'R000');

  });

  test("Should produce correct shorthand for heading value", () {

    expect(RotorCommand(headingVal: 0).headingToShorthand(), 'N000');
    expect(RotorCommand(headingVal: 1).headingToShorthand(), 'N001');
    expect(RotorCommand(headingVal: 12).headingToShorthand(), 'N012');
    expect(RotorCommand(headingVal: 100).headingToShorthand(), 'N100');

  });

}
