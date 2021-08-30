import 'package:VennUI/components/Grid.dart';
import 'package:VennUI/providers/dashboard_services/Control.dart';
import 'package:VennUI/providers/dashboard_services/Graphics.dart';
import 'package:VennUI/providers/dashboard_services/Metrics.dart';
import 'package:flutter/material.dart';
import 'package:VennUI/utilies.dart';
import 'package:tuple/tuple.dart';

// DashboardProvider act as a proxy between the different dashboard services
// and the UI. It gathers widgets from the services to display them and updates
// them when required through update received in the service update stream.
// This way the UI is always up to date
class DashboardProvider with ChangeNotifier {
  // grid contains information about our current grid setup
  final grid = Grid();
  MetricService? metricService;
  ControlService? controlService;
  GraphicService? graphicService;

  // modifiedTileIndex tells to the Selector (of this provider) which tiles needs to be updated
  int modifiedTileIndex = 0;
  // numPages tells the number of pages there is in the dashboard
  int numPages = 1;
  // activeIndex tells the current active page
  int activeIndex = 0;
  // isLoading tells when loading of initial data is done
  bool isLoading = true;
  // isAlert tells when a tile is in alert state
  bool isAlert = false;

  // dragTargets are placeholder for tiles that will be used when tiles are movable
  List<Widget> widgets = [];
  int _dragTargetLen = 0;

  // List<Tile> tiles = [];
  Stopwatch stopwatch = new Stopwatch();

  // tilePositions are the position of each of the widget on the grid
  List<Tuple2> _tilePositions = [
    Tuple2(2, 1),
    Tuple2(0, 1),
    Tuple2(2, 0),
    Tuple2(0, 0),
    Tuple2(0, 2),
    Tuple2(4, 0),
    Tuple2(4, 2),
  ];

  DashboardProvider(MetricService m, ControlService c, GraphicService g) {
    metricService = m;
    controlService = c;
    graphicService = g;
    initiate();
  }

  Future<void> initiate() async {
    // Wait until both service initiate
    await metricService!.initiate();
    await controlService!.initiate();
    await graphicService!.initiate();
    widgets.addAll(getDragTargets());
    widgets.addAll(getDashboardWidgets());
    isLoading = false;
    notifyListeners();

    // Listen to the update stream of the metric service
    metricService!.updateStream.listen((update) {
      modifiedTileIndex = _dragTargetLen + update;
      widgets[modifiedTileIndex] =
          (widgets[modifiedTileIndex] as DashboardWidget)
              .copy(metricService!.getTiles()[update]);
      notifyListeners();
    });

    // Listen to the update stream of the control service
    controlService!.updateStream.listen((update) {
      modifiedTileIndex =
          _dragTargetLen + metricService!.numberOfTiles + update;
      widgets[modifiedTileIndex] =
          (widgets[modifiedTileIndex] as DashboardWidget)
              .copy(controlService!.getTiles()[update]);
      notifyListeners();
    });

    controlService!.testStateStream.listen((event) {
      if (event == TestCommand.StartTest) {
        stopwatch.start();
      } else if (event == TestCommand.StopTest) {
        stopwatch.stop();
        stopwatch.reset();
      }
    });
  }

  List<Tile> getTiles() {
    List<Tile> tiles = [];
    tiles.addAll(metricService!.getTiles());
    tiles.addAll(controlService!.getTiles());
    tiles.addAll(graphicService!.getTiles());
    return tiles;
  }

  void setActivePageIndex(int i) {
    if (i < 0 || i > numPages) {
      throw ('Invalid page index');
    }
    activeIndex = i;
    notifyListeners();
  }

  List<Widget> getWidgets() {
    return widgets;
  }

  List<Widget> getDragTargets() {
    List<Widget> targets = [];
    for (int i = 0; i < grid.height * grid.width; i++) {
      targets.add(CellDragTarget(
          getXCoord(i, grid.width), getYCoord(i, grid.width), grid));
    }
    _dragTargetLen = targets.length;
    return targets;
  }

  List<Widget> getDashboardWidgets() {
    List<Tile> tiles = new List<Tile>.from(getTiles());
    List<Widget> dashboardWidgets = [];
    for (int i = 0; i < tiles.length; i++) {
      dashboardWidgets.add(DashboardWidget(
          _tilePositions[i].item1, _tilePositions[i].item2, grid, tiles[i]));
    }
    return dashboardWidgets;
  }

  void pressButton(BuildContext context, int buttonIndex, int tileIndex) {
    controlService!.pressButton(context, buttonIndex, tileIndex);
  }

  void cancelButton(BuildContext context, int buttonIndex, int tileIndex) {
    controlService!.cancelButton(context, buttonIndex, tileIndex);
  }

  Future<void> updateGraphics() async {
    await graphicService!.update();
    widgets.clear();
    notifyListeners();
    widgets.addAll(getDragTargets());
    widgets.addAll(getDashboardWidgets());
    notifyListeners();
  }
}
