import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobileclient/rotor_utils.dart';
import 'package:mobileclient/data/rotor_command.dart';

class VehicleControlsPageContent extends StatefulWidget {
  final BluetoothDevice device;
  final FlutterBlue flutterBlue;

  VehicleControlsPageContent(this.device, this.flutterBlue);

  @override
  State<StatefulWidget> createState() {
    return VehicleControlsPageContentState(this.device);
  }
}

class VehicleControlsPageContentState extends State<VehicleControlsPageContent> {
  BluetoothDevice _device;
  List<String> eventLog = [];
  BluetoothService rotorBTService;

  BluetoothDevice get device => this._device;

  VehicleControlsPageContentState(this._device);

  @override
  void initState() {
    super.initState();

    this._device.state.listen((newDeviceState) {
      if (newDeviceState == BluetoothDeviceState.connected){
        this.onDeviceConnected(this);
      }
    });
  }

  Function onDeviceConnected = (VehicleControlsPageContentState state) {
    state
      .device
      .discoverServices()
      .then((availableService) => state.onServicesReceived(state, availableService));
  };

  Function onServicesReceived = (VehicleControlsPageContentState state, List<BluetoothService> availableServices) {
    state.rotorBTService = availableServices?.firstWhere((item) => item.uuid.toString() == RotorUtils.GATT_SERVICE_UUID, orElse: () => null);
  };

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.black,
                  child: ListView.builder(
                    itemBuilder: (BuildContext bc, int i) {
                      return Text(eventLog[i]);
                    },
                    itemCount: eventLog.length,
                  ))),
          _buildControlPanel()
        ]);
  }

  Widget _buildControlPanel() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildControlPanelButton(
                "left",
                (pressingDown) =>
                    executeCommand(RotorCommand(throttleVal: 20, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.PORT, headingVal: 50))),
            _buildControlPanelButton(
                "right",
                (pressingDown) =>
                    executeCommand(RotorCommand(throttleVal: 20, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.STARBOARD, headingVal: 50)))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildControlPanelButton(
                "GO!",
                (pressingDown) =>
                    executeCommand(RotorCommand(throttleVal: 20, throttleDir: ThrottleDirection.FORWARD, headingDir: HeadingDirection.NEUTRAL, headingVal: 0)),
                colorOverride: Colors.green),
            _buildControlPanelButton(
                "STOP!",
                (pressingDown) =>
                    executeCommand(RotorCommand(throttleVal: 0, throttleDir: ThrottleDirection.NEUTRAL, headingDir: HeadingDirection.NEUTRAL, headingVal: 0)),
                colorOverride: Colors.red)
          ],
        )
      ],
    ));
  }

  Widget _buildControlPanelButton(String actionTitle, Function highlightAction,
          {Color colorOverride = RotorUtils.ROTOR_TEAL_COLOR}) =>
      Padding(
          child: RaisedButton(
            child: Text(actionTitle),
            onHighlightChanged: highlightAction,
            onPressed: () {},
            color: colorOverride,
          ),
          padding: EdgeInsets.all(4));

  @visibleForTesting
  executeCommand(RotorCommand rc) async {

    await this
      .rotorBTService
      .characteristics
      .firstWhere((c) => c.uuid.toString() == RotorUtils.GATT_CHARACTERISTIC_UUID, orElse: () => null)
      ?.write(rc.toShorthand().codeUnits, withoutResponse: true);

//      setState(() {
//        eventLog.add(rc.toShorthand());
//      });

  }

}
