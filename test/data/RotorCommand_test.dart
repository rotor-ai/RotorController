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

  test("Should produce correct abbreviation for throttle direction", () {

    expect(RotorCommand(throttleDir: ThrottleDirection.FORWARD).toShorthand(), "F000 N000");
    expect(RotorCommand(throttleDir: ThrottleDirection.NEUTRAL).toShorthand(), "N000 N000");
    expect(RotorCommand(throttleDir: ThrottleDirection.BACKWARD).toShorthand(), "B000 N000");
  });

  test("Should produce correct value for throttle", () {

    expect(RotorCommand(throttleVal: 1).toShorthand(), "N001 N000");
    expect(RotorCommand(throttleVal: 12).toShorthand(), "N012 N000");
    expect(RotorCommand(throttleVal: 123).toShorthand(), "N123 N000");
  });

  test("Should produce correct abbreviation for heading direction", () {

    expect(RotorCommand(headingDir: HeadingDirection.PORT).toShorthand(), "N000 L000");
    expect(RotorCommand(headingDir: HeadingDirection.MIDDLE).toShorthand(), "N000 N000");
    expect(RotorCommand(headingDir: HeadingDirection.STARBOARD).toShorthand(), "N000 R000");

  });

  test("Should produce correct value for heading", () {

    expect(RotorCommand(headingVal: 1).toShorthand(), "N000 N001");
    expect(RotorCommand(headingVal: 12).toShorthand(), "N000 N012");
    expect(RotorCommand(headingVal: 123).toShorthand(), "N000 N123");
  });


}
