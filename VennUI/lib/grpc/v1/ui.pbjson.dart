///
//  Generated code. Do not modify.
//  source: ui.proto
//
// @dart = 2.7
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const Destination$json = const {
  '1': 'Destination',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'MOTOR', '2': 1},
    const {'1': 'MICROCONTROLLER', '2': 2},
  ],
};

const MetricConfig$json = const {
  '1': 'MetricConfig',
  '2': const [
    const {'1': 'unit', '3': 1, '4': 1, '5': 9, '10': 'unit'},
    const {'1': 'target', '3': 2, '4': 1, '5': 2, '10': 'target'},
    const {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'info', '3': 5, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'hasTarget', '3': 6, '4': 1, '5': 8, '10': 'hasTarget'},
    const {'1': 'smallName', '3': 7, '4': 1, '5': 9, '10': 'smallName'},
  ],
};

const MetricConfigs$json = const {
  '1': 'MetricConfigs',
  '2': const [
    const {'1': 'configs', '3': 1, '4': 3, '5': 11, '6': '.v1.MetricConfig', '10': 'configs'},
  ],
};

const MetricUpdate$json = const {
  '1': 'MetricUpdate',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    const {'1': 'target', '3': 3, '4': 1, '5': 1, '10': 'target'},
    const {'1': 'timestamp', '3': 4, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

const MetricUpdates$json = const {
  '1': 'MetricUpdates',
  '2': const [
    const {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.v1.MetricUpdate', '10': 'updates'},
  ],
};

const Setting$json = const {
  '1': 'Setting',
  '2': const [
    const {'1': 'destination', '3': 1, '4': 1, '5': 14, '6': '.v1.Destination', '10': 'destination'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    const {'1': 'max', '3': 3, '4': 1, '5': 1, '10': 'max'},
    const {'1': 'min', '3': 4, '4': 1, '5': 1, '10': 'min'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'info', '3': 6, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'target', '3': 7, '4': 1, '5': 11, '6': '.v1.Target', '10': 'target'},
    const {'1': 'smallName', '3': 8, '4': 1, '5': 9, '10': 'smallName'},
    const {'1': 'isStatic', '3': 9, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const Target$json = const {
  '1': 'Target',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'uncertainty', '3': 2, '4': 1, '5': 1, '10': 'uncertainty'},
  ],
};

const SettingUpdate$json = const {
  '1': 'SettingUpdate',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    const {'1': 'isStatic', '3': 3, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const TargetUpdate$json = const {
  '1': 'TargetUpdate',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    const {'1': 'isStatic', '3': 3, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const Selector$json = const {
  '1': 'Selector',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'choice', '3': 2, '4': 1, '5': 9, '10': 'choice'},
    const {'1': 'possibleChoices', '3': 3, '4': 3, '5': 9, '10': 'possibleChoices'},
    const {'1': 'isStatic', '3': 9, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const Selectors$json = const {
  '1': 'Selectors',
  '2': const [
    const {'1': 'selectors', '3': 1, '4': 3, '5': 11, '6': '.v1.Selector', '10': 'selectors'},
  ],
};

const SelectorUpdate$json = const {
  '1': 'SelectorUpdate',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'choiceName', '3': 2, '4': 1, '5': 9, '10': 'choiceName'},
    const {'1': 'isStatic', '3': 3, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const ChoiceUpdate$json = const {
  '1': 'ChoiceUpdate',
  '2': const [
    const {'1': 'nameSelector', '3': 1, '4': 1, '5': 9, '10': 'nameSelector'},
    const {'1': 'newChoice', '3': 2, '4': 1, '5': 9, '10': 'newChoice'},
    const {'1': 'isStatic', '3': 3, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const Point$json = const {
  '1': 'Point',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

const GraphSettings$json = const {
  '1': 'GraphSettings',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'unitVerticalAxis', '3': 2, '4': 1, '5': 9, '10': 'unitVerticalAxis'},
    const {'1': 'unitHorizontalAxis', '3': 3, '4': 1, '5': 9, '10': 'unitHorizontalAxis'},
    const {'1': 'verticalAxis', '3': 4, '4': 1, '5': 9, '10': 'verticalAxis'},
    const {'1': 'horizontalAxis', '3': 5, '4': 1, '5': 9, '10': 'horizontalAxis'},
    const {'1': 'points', '3': 6, '4': 3, '5': 11, '6': '.v1.Point', '10': 'points'},
    const {'1': 'isStatic', '3': 7, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const GraphUpdate$json = const {
  '1': 'GraphUpdate',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'newPoints', '3': 2, '4': 3, '5': 11, '6': '.v1.Point', '10': 'newPoints'},
    const {'1': 'isStatic', '3': 3, '4': 1, '5': 8, '10': 'isStatic'},
  ],
};

const Recipe$json = const {
  '1': 'Recipe',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'info', '3': 3, '4': 1, '5': 9, '10': 'info'},
    const {'1': 'settings', '3': 4, '4': 3, '5': 11, '6': '.v1.Setting', '10': 'settings'},
    const {'1': 'selectors', '3': 5, '4': 3, '5': 11, '6': '.v1.Selector', '10': 'selectors'},
    const {'1': 'graphs', '3': 6, '4': 3, '5': 11, '6': '.v1.GraphSettings', '10': 'graphs'},
  ],
};

const UUIDS$json = const {
  '1': 'UUIDS',
  '2': const [
    const {'1': 'uuids', '3': 1, '4': 3, '5': 9, '10': 'uuids'},
  ],
};

const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'role', '3': 2, '4': 1, '5': 14, '6': '.v1.User.Roles', '10': 'role'},
  ],
  '4': const [User_Roles$json],
};

const User_Roles$json = const {
  '1': 'Roles',
  '2': const [
    const {'1': 'USER', '2': 0},
    const {'1': 'ADMIN', '2': 1},
    const {'1': 'CREATOR', '2': 2},
  ],
};

const Users$json = const {
  '1': 'Users',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.v1.User', '10': 'users'},
  ],
};

const WifiCredentials$json = const {
  '1': 'WifiCredentials',
  '2': const [
    const {'1': 'SSID', '3': 1, '4': 1, '5': 9, '10': 'SSID'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

const WifiNames$json = const {
  '1': 'WifiNames',
  '2': const [
    const {'1': 'SSIDs', '3': 1, '4': 3, '5': 9, '10': 'SSIDs'},
  ],
};

const WifiStatus$json = const {
  '1': 'WifiStatus',
  '2': const [
    const {'1': 'isConnected', '3': 1, '4': 1, '5': 8, '10': 'isConnected'},
    const {'1': 'SSID', '3': 2, '4': 1, '5': 9, '10': 'SSID'},
  ],
};

const Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'payload', '3': 2, '4': 1, '5': 9, '10': 'payload'},
  ],
};

const ControlEvent$json = const {
  '1': 'ControlEvent',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'payload', '3': 2, '4': 1, '5': 9, '10': 'payload'},
  ],
};

const SendResponse$json = const {
  '1': 'SendResponse',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
  ],
};

const ControlConfig$json = const {
  '1': 'ControlConfig',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.v1.ControlConfig.ControlType', '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'state_text', '3': 4, '4': 3, '5': 9, '10': 'stateText'},
    const {'1': 'action_name', '3': 5, '4': 1, '5': 9, '10': 'actionName'},
    const {'1': 'state_action_payload', '3': 6, '4': 3, '5': 9, '10': 'stateActionPayload'},
    const {'1': 'iconType', '3': 7, '4': 1, '5': 9, '10': 'iconType'},
  ],
  '4': const [ControlConfig_ControlType$json],
};

const ControlConfig_ControlType$json = const {
  '1': 'ControlType',
  '2': const [
    const {'1': 'TWO_STATE_BUTTON', '2': 0},
    const {'1': 'SINGLE_STATE_BUTTON', '2': 1},
    const {'1': 'ICON_BUTTON', '2': 2},
  ],
};

const ControlConfigs$json = const {
  '1': 'ControlConfigs',
  '2': const [
    const {'1': 'configs', '3': 1, '4': 3, '5': 11, '6': '.v1.ControlConfig', '10': 'configs'},
  ],
};

const Empty$json = const {
  '1': 'Empty',
};

const DoubleValue$json = const {
  '1': 'DoubleValue',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 1, '10': 'value'},
  ],
};

const FloatValue$json = const {
  '1': 'FloatValue',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 2, '10': 'value'},
  ],
};

const Int64Value$json = const {
  '1': 'Int64Value',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 3, '10': 'value'},
  ],
};

const UInt64Value$json = const {
  '1': 'UInt64Value',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 4, '10': 'value'},
  ],
};

const Int32Value$json = const {
  '1': 'Int32Value',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 5, '10': 'value'},
  ],
};

const UInt32Value$json = const {
  '1': 'UInt32Value',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 13, '10': 'value'},
  ],
};

const BoolValue$json = const {
  '1': 'BoolValue',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
  ],
};

const StringValue$json = const {
  '1': 'StringValue',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

const BytesValue$json = const {
  '1': 'BytesValue',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 12, '10': 'value'},
  ],
};

