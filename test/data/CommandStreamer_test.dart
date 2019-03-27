import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/CommandStreamer.dart';
import 'package:mobileclient/data/RotorCommand.dart';

void main() {
  RotorCommand _arbitraryCommandA = RotorCommand(
      throttleVal: 1,
      throttleDir: ThrottleDirection.FORWARD,
      headingVal: 2,
      headingDir: HeadingDirection.PORT);

  RotorCommand _arbitraryCommandB = RotorCommand(
      throttleVal: 10,
      throttleDir: ThrottleDirection.BACKWARD,
      headingVal: 20,
      headingDir: HeadingDirection.STARBOARD);

  test("Should initialize with default command in the stream", () async {
    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    expect(cmdStream, isInstanceOf<Stream<RotorCommand>>());
    await cmdStream.first.then((firstItem) {
      expect(firstItem, isNotNull);
    });
  });

  test("Should not send command without calling execute", () async {
    //ARRANGE
    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    //ACT
    commandStreamer.stageCommand(_arbitraryCommandA);

    //ASSERT
    commandStreamer.closeStream();
    await cmdStream.length.then((i) {
      expect(i, 1);
    });
  });

  test("Should not send command if nothing is staged", () async {
    //ARRANGE
    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    //ACT
    commandStreamer.execute();

    //ASSERT
    commandStreamer.closeStream();
    await cmdStream.length.then((i) {
      expect(i, 1);
    });
  });

  test("Should send command after command is staged and execute is called",
      () async {
    //ARRANGE
    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    //ACT
    commandStreamer.stageCommand(_arbitraryCommandA);
    commandStreamer.execute();

    //ASSERT
    await expectLater(
        cmdStream,
        emitsInOrder([
          RotorCommandMatcher("N000 N000"),
          RotorCommandMatcher(_arbitraryCommandA.toShorthand())
        ]));
  });

  test("Should send two commands", () async {
    //ARRANGE
    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    //ACT
    commandStreamer.stageCommand(_arbitraryCommandA);
    commandStreamer.execute();
    commandStreamer.stageCommand(_arbitraryCommandB);
    commandStreamer.execute();

    //ASSERT
    await expectLater(
        cmdStream,
        emitsInOrder([
          RotorCommandMatcher("N000 N000"),
          RotorCommandMatcher(_arbitraryCommandA.toShorthand()),
          RotorCommandMatcher(_arbitraryCommandB.toShorthand())
        ]));
  });
}

class RotorCommandMatcher extends CustomMatcher {
  RotorCommandMatcher(matcher)
      : super("matches expected shorthand", "toShorthand", matcher);

  @override
  Object featureValueOf(actual) => actual.toShorthand();
}
