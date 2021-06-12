import 'dart:async';
import 'package:VennUI/components/Grid.dart';
import 'package:VennUI/grpc/metric.dart';
import 'package:flutter/material.dart';
import 'package:VennUI/grpc/v1/ui.pb.dart' as proto;
import 'package:flutter_icons/flutter_icons.dart';

// Metric serive is used to track data about the metrics
class MetricService {
  // _updates is used to tell the provider which widget needs to be updated
  StreamController<int> _updates = StreamController<int>();
  Stream<int> get updateStream => _updates.stream;

  // isAlert is used as a flag to tell when one of the metric tiles is in alert
  bool isAlert = false;

  List<MetricChip> chips = [];

  // Configuration and metric service API object
  MetricGrpcAPI? _metricAPI;

  MetricService(this._metricAPI);

  Future<void> initiate() async {
    // Get the config from the server
    var c = await _metricAPI!.readConfig();
    List<proto.MetricConfig> config = c.configs;

    // Create the list of metric data
    var m = await _metricAPI!.getMetrics();
    for (int i = 0; i < m.updates.length; i++) {
      var t = MetricData(
        m.updates[i].name,
        m.updates[i].value,
        config[i].unit,
        config[i].type,
        config[i].info,
        m.updates[i].target,
        config[i].hasTarget_6,
      );
      chips.add(MetricChip(t, 1.0));
    }

    // Listen for new metrics from the backend
    _metricAPI!.getMetricStream().listen((metric) {
      processNewMetric(metric);
    });
  }

  void processNewMetric(proto.MetricUpdate update) {
    // Update the required tile
    for (int i = 0; i < chips.length; i++) {
      if (chips[i].data.name == update.name) {
        MetricData d = chips[i].data;
        d.update(update);
        chips[i] = MetricChip(d, 1.0);
        _updates.add(i);
      }
    }
    // Look if any tile is in alert
    // bool alert = false;
    // metricTiles.forEach((tile) {
    //   if (tile._isAlert) {
    //     alert = true;
    //   }
    // });
    // // Only notifier listeners if alert state is different from previous
    // if (isAlert != alert) {
    //   isAlert = alert;
    // }
  }

  List<Tile> getTiles() {
    return chips.map((chip) => Tile(chip, false, 2, 1)).toList();
  }

  int get numberOfTiles => chips.length;
}

class MetricData {
  double _value = 0;
  String _name = "";
  String _unit = "";
  String _type = "";
  String _info = "";
  double _target = 0;
  late Icon _icon;
  bool _hasTarget = false;
  bool _isAlert = false;
  double _uncertainty = 2;

  MetricData(
    String name,
    double value,
    String unit,
    String type,
    String info,
    double goal,
    bool hasTarget,
  ) {
    _value = value;
    _name = name;
    _unit = unit;
    _type = type;
    _info = info;
    _target = goal;
    _hasTarget = hasTarget;
    _isAlert = false;
    // Set the right icon for the metric type
    switch (type) {
      case 'Temperature':
        _icon = Icon(FontAwesome5Solid.thermometer_half);
        break;
      case 'Humidity':
        _icon = Icon(Ionicons.ios_water);
        break;
      case 'Speed':
        _icon = Icon(Ionicons.ios_speedometer);
        break;
      case 'Weight':
        _icon = Icon(MaterialCommunityIcons.weight);
        break;
      case 'Distance':
        _icon = Icon(FontAwesome5Solid.ruler_vertical);
        break;
    }
  }

  double get value => _value;
  String get name => _name;
  String get unit => _unit;
  String get type => _type;
  String get info => _info;
  double get target => _target;
  bool get hasTarget => _hasTarget;
  bool get isAlert => _isAlert;
  Icon get icon => _icon;

  void update(proto.MetricUpdate u) {
    // The target is not update at the same time as the value
    if (_value == null) {
      _target = u.target;
    } else {
      _value = u.value;
      _target = u.target;
    }
    _isAlert = false;
    if (hasTarget &&
        (value < target - _uncertainty || value > target + _uncertainty)) {
      _isAlert = true;
    }
  }
}
