import 'package:VennUI/components/Graph.dart';
import 'package:VennUI/components/SettingPages.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GraphDashboard extends StatefulWidget {
  GraphDashboard(this.title, this.getPoints, this.info, this.xMax, this.yMax)
      : this.empty = false;

  GraphDashboard.empty(this.title)
      : this.xMax = 0,
        this.yMax = 0,
        this.getPoints = null,
        this.info = null,
        this.empty = true;

  final String title;
  final List<Point> Function(BuildContext)? getPoints;
  final GraphInfo? info;
  final double xMax;
  final double yMax;
  final bool empty;

  @override
  _GraphDashboardState createState() => _GraphDashboardState();
}

class _GraphDashboardState extends State<GraphDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: AutoSizeText(
                widget.title,
                style: TextStyle(
                    color: baseColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                minFontSize: 10,
                maxLines: 1,
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
                child: widget.empty
                    ? nd()
                    : Graph.extended(widget.getPoints!, widget.info!,
                        widget.xMax, widget.yMax),
              )),
        ],
      ),
    );
  }

  Widget nd() {
    return Center(
      child: Text(
        "No curve defined",
        style: TextStyle(color: baseColor, fontSize: 30),
      ),
    );
  }
}
