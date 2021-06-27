import 'dart:async';

import 'package:VennUI/components/ActionButton.dart';
import 'package:VennUI/components/Grid.dart';
import 'package:VennUI/grpc/control.dart';
import 'package:VennUI/grpc/v1/ui.pb.dart' as proto;
import 'package:flutter/material.dart';

class ControlService {
  // _updates is used to tell the provider which widget needs to be updated
  StreamController<int> _updates = StreamController<int>();
  Stream<int> get updateStream => _updates.stream;

  // config is constant information about each button
  List<proto.ControlConfig> config = [];

  // metricChip is the list of metricChip widget
  List<ButtonData> _buttonsData = [];

  List<Tile> tiles = [];

  ControlGrpcAPI? _controlAPI;

  ControlService(ControlGrpcAPI s) {
    _controlAPI = s;
    _updates = StreamController();
  }

  Future<void> initiate() async {
    // Get the config from the server
    var c = await _controlAPI!.readConfig();
    config = c.configs;

    // Create the list of button data
    for (var c in config) {
      _buttonsData.add(ButtonData(c));
    }

    // Listen for new control event from the backend
    _controlAPI!.getEventStream().listen((event) {
      processNewEvent(event);
    });
  }

  List<Tile> getTiles() {
    List<ActionButton> buttons = [];
    int i = 0;
    for (ButtonData d in _buttonsData) {
      if (d.type == proto.ControlConfig_ControlType.ICON_BUTTON) {
        buttons.add(ActionButton.icon(
            d.title, d.iconType, buttonType.ICON_BUTTON, i, 0));
      } else if (d.type ==
          proto.ControlConfig_ControlType.SINGLE_STATE_BUTTON) {
        buttons.add(ActionButton.text(
            d.title, d.texts[0], buttonType.SINGLE_STATE_BUTTON, i, 0));
      } else {
        buttons.add(ActionButton.text(
            d.title, d.texts[d.state], buttonType.TWO_STATE_BUTTON, i, 0));
      }
      i++;
    }
    return [
      Tile(ControlContainer(buttons), false, 4, 2),
    ];
  }

  int numberOfTiles() {
    return 1;
  }

  Future<void> pressButton(
      BuildContext context, int buttonIndex, int tileIndex) async {
    // Send the button press to the API
    await _controlAPI!.send(context,
        _buttonsData[buttonIndex].actions[_buttonsData[buttonIndex].state]);
    // Update the button data to the other state
    _buttonsData[buttonIndex].updateState();
    // Send the update to the dashboard provider
    _updates.add(tileIndex);
  }

  void processNewEvent(proto.ControlEvent e) {}
}

class ButtonData {
  // state is tell which information to use for the button to be displayed
  int state = 0;
  String title = "";
  String id = "";
  proto.ControlConfig_ControlType? type;
  List<String> texts = [];
  List<proto.Action> actions = [];
  String iconType = "";

  ButtonData(proto.ControlConfig c) {
    title = c.title;
    id = c.id;
    type = c.type;
    texts = c.stateText;
    iconType = c.iconType;
    for (String p in c.stateActionPayload) {
      actions.add(proto.Action(name: c.actionName, payload: p));
    }
  }

  void updateState() {
    // Only switch the state if the button is a two-state button
    if (type == proto.ControlConfig_ControlType.TWO_STATE_BUTTON ||
        type == proto.ControlConfig_ControlType.ICON_BUTTON) {
      if (state == 0) {
        state = 1;
      } else {
        state = 0;
      }
    }
  }
}
