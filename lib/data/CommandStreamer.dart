import 'dart:async';

import 'package:mobileclient/data/RotorCommand.dart';

class CommandStreamer {
  StreamController<RotorCommand> _streamController =
      StreamController<RotorCommand>();
  RotorCommand _stagedCommand = null;

  get stream => _streamController.stream;

  CommandStreamer() {
    _streamController.add(RotorCommand());
  }

  void stageCommand(RotorCommand rotorCommand) {

    _stagedCommand = rotorCommand;
  }

  void execute() {
    if (_stagedCommand != null) {
      _streamController.add(_stagedCommand);
      _stagedCommand = null;
    }
  }

  void closeStream() {
    _streamController.close();
  }
}
