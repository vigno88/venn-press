import 'package:VennUI/components/GraphDashboard.dart';
import 'package:VennUI/components/Grid.dart';
import 'package:VennUI/components/SettingPages.dart';
import 'package:VennUI/grpc/settings.dart';
import 'package:VennUI/grpc/v1/ui.pbgrpc.dart' as proto;
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// Graphic service is used to track data about the graphics
class GraphicService {
  GraphicService(this._settingAPI);

  SettingGrpcAPI? _settingAPI;

  List<GraphDashboard> gs = [];
  List<proto.GraphSettings> settings = [];

  Future<void> initiate() async {
    // Get the config from the server
    proto.Recipe r = await _settingAPI!.readCurrentRecipe();

    // Make the first graph
    settings.add(r.graphs[0]);
    if (settings[0].points.isEmpty) {
      gs.add(GraphDashboard.empty(settings[0].name + " Curve"));
    } else {
      GraphInfo i = GraphInfo(
          settings[0].horizontalAxis,
          settings[0].verticalAxis,
          settings[0].unitHorizontalAxis,
          settings[0].unitVerticalAxis);
      Tuple2 maxs = getMax(settings[0].points);
      gs.add(GraphDashboard(
          settings[0].name + " Curve", points1, i, maxs.item1, maxs.item2));
    }

    // Make the second graph
    settings.add(r.graphs[1]);
    if (settings[1].points.isEmpty) {
      gs.add(GraphDashboard.empty(settings[1].name + " Curve"));
    } else {
      GraphInfo i = GraphInfo(
          settings[1].horizontalAxis,
          settings[1].verticalAxis,
          settings[1].unitHorizontalAxis,
          settings[1].unitVerticalAxis);
      Tuple2 maxs = getMax(settings[1].points);
      gs.add(GraphDashboard(
          settings[1].name + " Curve", points2, i, maxs.item1, maxs.item2));
    }
  }

  List<Point> points1(BuildContext c) {
    List<Point> l = [];
    for (proto.Point p in settings[0].points) {
      l.add(Point.fromProto(p));
    }
    return l;
  }

  List<Point> points2(BuildContext c) {
    List<Point> l = [];
    for (proto.Point p in settings[1].points) {
      l.add(Point.fromProto(p));
    }
    return l;
  }

  Tuple2 getMax(List<proto.Point> ps) {
    double xMax = 0, yMax = 0;
    for (proto.Point p in ps) {
      if (p.x > xMax) {
        xMax = p.x;
      }
      if (p.y > yMax) {
        yMax = p.y;
      }
    }
    return Tuple2(xMax, yMax);
  }

  List<Tile> getTiles() {
    return [Tile(gs[0], false, 4, 2), Tile(gs[1], false, 4, 2)];
  }

  Future<void> update() async {
    // Get the config from the server
    proto.Recipe r = await _settingAPI!.readCurrentRecipe();
    settings.clear();
    gs.clear();

    // Make the first graph
    settings.add(r.graphs[0]);
    if (settings[0].points.isEmpty) {
      gs.add(GraphDashboard.empty(settings[0].name + " Curve"));
    } else {
      GraphInfo i = GraphInfo(
          settings[0].horizontalAxis,
          settings[0].verticalAxis,
          settings[0].unitHorizontalAxis,
          settings[0].unitVerticalAxis);
      Tuple2 maxs = getMax(settings[0].points);
      gs.add(GraphDashboard(
          settings[0].name + " Curve", points1, i, maxs.item1, maxs.item2));
    }

    // Make the second graph
    settings.add(r.graphs[1]);
    if (settings[1].points.isEmpty) {
      gs.add(GraphDashboard.empty(settings[1].name + " Curve"));
    } else {
      GraphInfo i = GraphInfo(
          settings[1].horizontalAxis,
          settings[1].verticalAxis,
          settings[1].unitHorizontalAxis,
          settings[1].unitVerticalAxis);
      Tuple2 maxs = getMax(settings[1].points);
      gs.add(GraphDashboard(
          settings[1].name + " Curve", points2, i, maxs.item1, maxs.item2));
    }
  }
}
