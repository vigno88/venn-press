///
//  Generated code. Do not modify.
//  source: ui.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Destination extends $pb.ProtobufEnum {
  static const Destination NONE = Destination._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NONE');
  static const Destination MOTOR = Destination._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOTOR');
  static const Destination MICROCONTROLLER = Destination._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MICROCONTROLLER');

  static const $core.List<Destination> values = <Destination> [
    NONE,
    MOTOR,
    MICROCONTROLLER,
  ];

  static final $core.Map<$core.int, Destination> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Destination? valueOf($core.int value) => _byValue[value];

  const Destination._($core.int v, $core.String n) : super(v, n);
}

class User_Roles extends $pb.ProtobufEnum {
  static const User_Roles USER = User_Roles._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER');
  static const User_Roles ADMIN = User_Roles._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ADMIN');
  static const User_Roles CREATOR = User_Roles._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATOR');

  static const $core.List<User_Roles> values = <User_Roles> [
    USER,
    ADMIN,
    CREATOR,
  ];

  static final $core.Map<$core.int, User_Roles> _byValue = $pb.ProtobufEnum.initByValue(values);
  static User_Roles? valueOf($core.int value) => _byValue[value];

  const User_Roles._($core.int v, $core.String n) : super(v, n);
}

class ControlConfig_ControlType extends $pb.ProtobufEnum {
  static const ControlConfig_ControlType TWO_STATE_BUTTON = ControlConfig_ControlType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TWO_STATE_BUTTON');
  static const ControlConfig_ControlType SINGLE_STATE_BUTTON = ControlConfig_ControlType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SINGLE_STATE_BUTTON');
  static const ControlConfig_ControlType ICON_BUTTON = ControlConfig_ControlType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ICON_BUTTON');

  static const $core.List<ControlConfig_ControlType> values = <ControlConfig_ControlType> [
    TWO_STATE_BUTTON,
    SINGLE_STATE_BUTTON,
    ICON_BUTTON,
  ];

  static final $core.Map<$core.int, ControlConfig_ControlType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ControlConfig_ControlType? valueOf($core.int value) => _byValue[value];

  const ControlConfig_ControlType._($core.int v, $core.String n) : super(v, n);
}

