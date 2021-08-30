import 'package:VennUI/components/SettingPages.dart';
import 'package:VennUI/utilies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  Graph(this.getPoints, this.info)
      : this.extended = false,
        this.xMax = 0,
        this.yMax = 0;

  Graph.extended(this.getPoints, this.info, this.xMax, this.yMax)
      : this.extended = true;

  final List<Point> Function(BuildContext) getPoints;
  final GraphInfo info;

  // Is is extended is set, max and min needs to be set. This is use to show a live
  // view of the graph (e.g. on a dashboard)
  final bool extended;
  final double xMax;
  final double yMax;

  @override
  _GraphState createState() => _GraphState(xMax, yMax);
}

class _GraphState extends State<Graph> {
  _GraphState(this.xMax, this.yMax);

  double xMax = 0;
  double yMax = 0;
  String unitX = "";
  String unitY = "";
  int xStep = 0;
  int yStep = 0;
  List<FlSpot> spots = [];

  @override
  Widget build(BuildContext context) {
    List<Point> ps = widget.getPoints(context);
    if (!getGraphValues(context, ps)) {
      return Container(
        child: Center(
          child: Text(
            "The points are not in acsending order.",
            style: TextStyle(color: greyIcon, fontSize: 35),
          ),
        ),
      );
    }
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            if (value % yStep == 0) {
              return FlLine(
                color: greyBorder,
                strokeWidth: 1,
              );
            }
            return FlLine(color: Colors.transparent);
          },
          getDrawingVerticalLine: (value) {
            if (value % xStep == 0) {
              return FlLine(
                color: greyBorder,
                strokeWidth: 1,
              );
            }
            return FlLine(color: Colors.transparent);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => TextStyle(
                color: greyIcon, fontWeight: FontWeight.bold, fontSize: 16),
            getTitles: (value) => getTitlesX(value),
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: greyIcon,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: (value) => getTitleY(value),
            reservedSize: 28,
            margin: 12,
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: greyBorder, width: 1)),
        minX: 0,
        maxX: xMax,
        minY: 0,
        maxY: yMax,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            colors: [darkBlue],
            // barWidth: 5,
            barWidth: 0,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              // show: true,
              show: false,
              colors: [darkBlue.withOpacity(0.3)],
            ),
          ),
        ],
      ),
    );
  }

  bool getGraphValues(BuildContext context, List<Point> ps) {
    spots = [];
    // Get Units
    unitX = widget.info.xUnit;
    unitY = widget.info.yUnit;

    int prevX = 0;
    double x = 0;
    double y = 0;
    for (Point p in ps) {
      // Verify all x values are in ascending order
      if (p.x < prevX) {
        return false;
      }
      // Get the biggest x value
      if (p.x > x) {
        x = p.x.toDouble();
      }
      // Get the biggest y value
      if (p.y > y) {
        y = p.y;
      }
      prevX = p.x;
      spots.add(new FlSpot(p.x.toDouble(), p.y));
    }
    if (!widget.extended) {
      xMax = x;
      yMax = y;
    }
    getSteps();
    return true;
  }

  void getSteps() {
    if (xMax > 10) {
      xStep = xMax ~/ 10;
    } else {
      xStep = 2;
    }
    if (yMax > 10) {
      yStep = yMax ~/ 5;
    } else {
      yStep = 2;
    }
  }

  String getTitlesX(double value) {
    if (value % (xStep * 2) == 0) {
      return value.toInt().toString() + " " + unitX;
    }
    return "";
  }

  String getTitleY(double value) {
    if (value % (yStep * 2) == 0) {
      return value.toInt().toString() + " " + unitY;
    }
    return "";
  }
}
