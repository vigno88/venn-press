import 'package:VennUI/components/Graph.dart';
import 'package:VennUI/components/ValuePicker.dart';
import 'package:VennUI/dialogs/EditSingleNumberDialog.dart';
import 'package:VennUI/grpc/v1/ui.pbgrpc.dart' as proto;
import 'package:VennUI/providers/SettingsProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ListSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SettingsListElement("General", "general", IconType.Cog),
            SettingsListElement("Heating Profile", "heating", IconType.Graph),
            SettingsListElement("Pressure Profile", "pressure", IconType.Graph),
          ],
        ));
  }
}

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List<proto.Setting> settings = context.watch<SettingsProvider>().settings;
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            Expanded(
                child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(5),
                      children: <Widget>[
                        SettingsSubtitle("PID - Top heating plate"),
                        SettingsItem(
                            "P Constant",
                            ValuePicker(0, settings[0].value, settings[0].max,
                                settings[0].min, update)),
                        SettingsItem(
                            "I Constant",
                            ValuePicker(1, settings[1].value, settings[1].max,
                                settings[1].min, update)),
                        SettingsItem(
                            "D Constant",
                            ValuePicker(2, settings[2].value, settings[2].max,
                                settings[2].min, update)),
                        SettingsSubtitle("PID - Bottom heating plate"),
                        SettingsItem(
                            "P Constant",
                            ValuePicker(3, settings[3].value, settings[3].max,
                                settings[3].min, update)),
                        SettingsItem(
                            "I Constant",
                            ValuePicker(4, settings[4].value, settings[4].max,
                                settings[4].min, update)),
                        SettingsItem(
                            "D Constant",
                            ValuePicker(5, settings[5].value, settings[5].max,
                                settings[5].min, update)),
                        // SettingsSubtitle("Material"),
                        // SettingsItem(
                        //     "Hardness Constant",
                        //     ValuePicker(6, settings[6].value, settings[6].max,
                        //         settings[6].min, update)),
                        SettingsSubtitle("Load cell"),
                        SettingsItem(
                            "Load cell Factor",
                            ValuePicker(6, settings[6].value, settings[6].max,
                                settings[6].min, update)),
                        SettingsSubtitle("Motor Controller"),
                        SettingsItem(
                            "P Constant",
                            ValuePicker(7, settings[7].value, settings[7].max,
                                settings[7].min, update)),
                        SettingsItem(
                            "I Constant",
                            ValuePicker(8, settings[8].value, settings[8].max,
                                settings[8].min, update)),
                        SettingsItem(
                            "D Constant",
                            ValuePicker(9, settings[9].value, settings[9].max,
                                settings[9].min, update)),
                        SettingsItem(
                            "Step Multiplier",
                            ValuePicker(10, settings[10].value,
                                settings[10].max, settings[10].min, update)),
                        SettingsItem(
                            "PID Sample Time",
                            ValuePicker(11, settings[11].value,
                                settings[11].max, settings[11].min, update)),
                        SettingsItem(
                            "Max Load (kg) - Safety",
                            ValuePicker(12, settings[12].value,
                                settings[12].max, settings[12].min, update)),
                      ],
                    ))),
          ],
        ));
  }

  void update(double v, int i) {
    context.read<SettingsProvider>().setSetting(i, v);
    // context.read<SettingsProvider>().settings[i].value = v;
  }
}

// SettingsItem is list item with a title on the right a widget on the right
class SettingsItem extends StatelessWidget {
  final String title;
  final Widget rightWidget;

  SettingsItem(this.title, this.rightWidget);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Expanded(
              flex: 8,
              child: Text(
                this.title,
                style:
                    TextStyle(color: baseColor.withOpacity(0.8), fontSize: 30),
              ),
            ),
            Expanded(
              flex: 4,
              child: rightWidget,
            ),
          ],
        ));
  }
}

class SettingsSubtitle extends StatelessWidget {
  final String text;

  SettingsSubtitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        this.text,
        style: TextStyle(color: baseColor, fontSize: 30),
      ),
    );
  }
}

class PressureSettings extends StatefulWidget {
  @override
  _PressureSettingsState createState() => _PressureSettingsState();
}

class _PressureSettingsState extends State<PressureSettings> {
  int index = 0;
  void a(BuildContext context) {
    context.read<SettingsProvider>().appdOnePointGraph(index);
    // setState(() {
    //   var list = context.read<SettingsProvider>().graphSettings[index].points;
    //   if (list.length == 0) {
    //     context
    //         .read<SettingsProvider>()
    //         .graphSettings[index]
    //         .points
    //         .add(proto.Point(x: 0, y: 0));
    //   } else {
    //     context
    //         .read<SettingsProvider>()
    //         .graphSettings[index]
    //         .points
    //         .add(list[list.length - 1]);
    //   }
    // });
  }

  void r(BuildContext context) {
    context.read<SettingsProvider>().removeLastGraphPoint(index);
    // setState(() {
    //   if (context.read<SettingsProvider>().graphSettings[index].points.length >
    //       0) {
    //     context
    //         .read<SettingsProvider>()
    //         .graphSettings[index]
    //         .points
    //         .removeLast();
    //   }
    // });
  }

  List<Point> g(BuildContext context) {
    return context
        .watch<SettingsProvider>()
        .graphSettings[index]
        .points
        .map((p) => new Point.fromProto(p))
        .toList();
  }

  void e(BuildContext context, int i, double v, Coord c) {
    context.read<SettingsProvider>().editGraph(index, i, v, c);
    // setState(() {
    //   if (c == Coord.X) {
    //     context.read<SettingsProvider>().graphSettings[index].points[i].x = v;
    //   } else {
    //     context.read<SettingsProvider>().graphSettings[index].points[i].y = v;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    proto.GraphSettings s =
        context.watch<SettingsProvider>().graphSettings[index];
    GraphInfo i = GraphInfo(s.horizontalAxis, s.verticalAxis,
        s.unitHorizontalAxis, s.unitVerticalAxis);
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            GraphContainer(g, i),
            GraphMaker(a, r, e, g, i),
          ],
        ));
  }
}

class HeatingSettings extends StatefulWidget {
  @override
  _HeatingSettingsState createState() => _HeatingSettingsState();
}

class _HeatingSettingsState extends State<HeatingSettings> {
  int index = 1;

  void a(BuildContext context) {
    setState(() {
      var list = context.watch<SettingsProvider>().graphSettings[index].points;
      if (list.length == 0) {
        context
            .read<SettingsProvider>()
            .graphSettings[index]
            .points
            .add(proto.Point(x: 0, y: 0));
      } else {
        context.read<SettingsProvider>().graphSettings[index].points.add(
            proto.Point(
                x: list[list.length - 1].x, y: list[list.length - 1].y));
      }
    });
  }

  void r(BuildContext context) {
    setState(() {
      if (context.read<SettingsProvider>().graphSettings[index].points.length >
          0) {
        context
            .read<SettingsProvider>()
            .graphSettings[index]
            .points
            .removeLast();
      }
    });
  }

  List<Point> g(BuildContext context) {
    return context
        .watch<SettingsProvider>()
        .graphSettings[index]
        .points
        .map((p) => Point.fromProto(p))
        .toList();
  }

  void e(BuildContext context, int i, double v, Coord c) {
    setState(() {
      if (c == Coord.X) {
        context.read<SettingsProvider>().graphSettings[index].points[i].x = v;
      } else {
        context.read<SettingsProvider>().graphSettings[index].points[i].y = v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    proto.GraphSettings s =
        context.watch<SettingsProvider>().graphSettings[index];
    GraphInfo i = GraphInfo(s.horizontalAxis, s.verticalAxis,
        s.unitHorizontalAxis, s.unitVerticalAxis);
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            GraphContainer(g, i),
            GraphMaker(a, r, e, g, i),
          ],
        ));
  }
}

enum IconType {
  Cog,
  Graph,
}

class SettingsListElement extends StatelessWidget {
  final String title;
  final String pageName;
  final IconType icon;

  SettingsListElement(this.title, this.pageName, this.icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<SettingsProvider>().updateSettingsPage(this.pageName),
      child: Container(
          height: 127,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  getIconData(),
                  color: baseColor,
                  size: 50,
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  this.title,
                  style: TextStyle(color: baseColor, fontSize: 45),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: paleColor.withOpacity(0.07),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Icon(
                      SimpleLineIcons.arrow_right,
                      size: 25,
                      color: baseColor,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  IconData? getIconData() {
    switch (this.icon) {
      case IconType.Cog:
        return SimpleLineIcons.settings;
      case IconType.Graph:
        return SimpleLineIcons.graph;
    }
  }
}

class SettingPageReturn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: baseColor, width: 1.5))),
      padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
      child: GestureDetector(
        onTap: () =>
            context.read<SettingsProvider>().updateSettingsPage("list"),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 60,
                decoration: BoxDecoration(
                  color: paleColor.withOpacity(0.07),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Icon(
                  SimpleLineIcons.arrow_left,
                  size: 30,
                  color: baseColor,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                "Return",
                style: TextStyle(color: baseColor, fontSize: 35),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GraphContainer extends StatelessWidget {
  GraphContainer(this.getPoints, this.info);

  final List<Point> Function(BuildContext context) getPoints;
  final GraphInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        height: 400,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(color: greyBorder, width: 2.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 30.0, left: 12.0, top: 30, bottom: 12),
            child: Graph(getPoints, info),
          ),
        ));
  }
}

class Point {
  Point(this.x, this.y);
  int x;
  double y;

  Point.from(Point p)
      : x = p.x,
        y = p.y;

  Point.fromProto(proto.Point p)
      : x = p.x.toInt(),
        y = p.y;
}

class GraphInfo {
  GraphInfo(this.xTitle, this.yTitle, this.xUnit, this.yUnit);

  String xTitle = "";
  String yTitle = "";
  String xUnit = "";
  String yUnit = "";
}

enum Coord { X, Y }

class GraphMaker extends StatelessWidget {
  GraphMaker(this.appendPoint, this.removeLastPoint, this.editPoint,
      this.getPoints, this.info);

  final void Function(BuildContext) appendPoint;
  final void Function(BuildContext) removeLastPoint;
  final void Function(BuildContext, int i, double v, Coord c) editPoint;
  final List<Point> Function(BuildContext) getPoints;
  final GraphInfo info;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Container(
          height: 368,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: greyBorder,
                width: 2.0,
              )),
          child: Column(children: [
            GraphMakerTopBar(appendPoint, removeLastPoint),
            GraphListPoints(getPoints, info, editPoint),
          ]),
        ));
  }
}

class GraphMakerTopBar extends StatelessWidget {
  GraphMakerTopBar(this.appendPoint, this.removeLastPoint);

  final void Function(BuildContext) appendPoint;
  final void Function(BuildContext) removeLastPoint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: greyBorder, width: 2.0))),
      alignment: Alignment.centerRight,
      child: Container(
        height: 50,
        width: 130,
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: greyBorder, width: 2.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: GraphMakerButton(
              Feather.minus,
              () => removeLastPoint(context),
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child:
                    GraphMakerButton(Feather.plus, () => appendPoint(context))),
          ],
        ),
      ),
    ));
  }
}

class GraphListPoints extends StatefulWidget {
  GraphListPoints(this.getPoints, this.info, this.editPoint);

  final List<Point> Function(BuildContext) getPoints;
  final GraphInfo info;
  final void Function(BuildContext, int i, double v, Coord c) editPoint;

  @override
  _GraphListPointsState createState() => _GraphListPointsState();
}

class _GraphListPointsState extends State<GraphListPoints> {
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List<Point> points = widget.getPoints(context);
    return Expanded(
      flex: 5,
      child: Scrollbar(
          controller: controller,
          isAlwaysShown: true,
          child: ListView.separated(
              controller: controller,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              padding: const EdgeInsets.all(5),
              itemCount: points.length,
              itemBuilder: (BuildContext context, int i) {
                return GraphPointListItem(
                    i, widget.info, points[i], widget.editPoint);
              })),
    );
  }
}

class GraphPointListItem extends StatelessWidget {
  GraphPointListItem(this.i, this.info, this.p, this.editPoint);

  final int i;
  final Point p;
  final GraphInfo info;
  final void Function(BuildContext, int i, double v, Coord c) editPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Starting index Number
            Expanded(
              child: Text(
                (i + 1).toString(),
                style: TextStyle(
                    color: greyIcon, fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
            // Point value
            Expanded(
                flex: 7,
                child: GraphPointListItemValue(
                    info.xTitle + " (" + info.xUnit + ")",
                    p.x.toDouble(),
                    i,
                    Coord.X,
                    editPoint)),
            Expanded(
              child: Container(),
            ),
            Expanded(
                flex: 7,
                child: GraphPointListItemValue(
                    info.yTitle + " (" + info.yUnit + ")",
                    p.y,
                    i,
                    Coord.Y,
                    editPoint)),
          ],
        ),
      ),
    ));
  }
}

class GraphPointListItemValue extends StatelessWidget {
  final String text;
  final double value;
  final int index;
  final Coord c;
  final void Function(BuildContext, int i, double v, Coord c) editPoint;

  GraphPointListItemValue(
      this.text, this.value, this.index, this.c, this.editPoint);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text + ": " + doubleAsString(value),
            style: TextStyle(color: baseColor, fontSize: 25),
          ),
          SizedBox(width: 20),
          GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (_) {
                    return EditSingleNumberDialogBox(value, double.infinity,
                        double.negativeInfinity, updateValue);
                  }),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  SimpleLineIcons.pencil,
                  size: 25,
                  color: darkBlue,
                ),
              ))
        ]
        // )
        );
  }

  void updateValue(BuildContext context, double v) {
    editPoint(context, this.index, v, this.c);
  }
}

class GraphMakerButton extends StatelessWidget {
  GraphMakerButton(this.data, this.f);

  final IconData data;
  final VoidCallback f;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: f,
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
            color: paleBlue,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Icon(data, color: darkBlue, size: 25),
        ));
  }
}
