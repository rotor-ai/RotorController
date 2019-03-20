

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/data/CommandStreamer.dart';
import 'package:mobileclient/data/RotorCommand.dart';

void main() {

  test("Should initialize with default command in the stream", () async {

    CommandStreamer commandStreamer = CommandStreamer();
    Stream<RotorCommand> cmdStream = commandStreamer.stream;

    expect(cmdStream, isInstanceOf<Stream<RotorCommand>>());
    await cmdStream.first.then((firstItem) {
      expect(firstItem, isNotNull);
    });

  });
}