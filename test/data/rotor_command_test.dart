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
}
