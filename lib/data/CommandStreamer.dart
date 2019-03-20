
import 'dart:async';

import 'package:mobileclient/data/RotorCommand.dart';

class CommandStreamer {
  StreamController<RotorCommand> streamController = StreamController<RotorCommand>();

  get stream => streamController.stream;

  CommandStreamer(){
    streamController.add(RotorCommand());
  }

}