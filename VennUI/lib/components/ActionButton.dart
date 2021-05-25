import 'package:VennUI/providers/DashboardProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatefulWidget {
  final String text;
  final String title;
  final String iconType;
  final int tileIndex;
  final int buttonIndex;

  ActionButton.text(this.title, this.text, this.buttonIndex, this.tileIndex)
      : iconType = null;
  ActionButton.icon(this.title, this.iconType, this.buttonIndex, this.tileIndex)
      : text = null;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Color colorButton = paleBlue.withOpacity(0.2);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 210,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
            widget.title,
            style: TextStyle(
                color: baseColor, fontSize: 30, fontWeight: FontWeight.bold),
            minFontSize: 10,
            maxLines: 1,
          )),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTapDown: _tapDown,
              onTapUp: _tapUp,
              onTap: () => context
                  .read<DashboardProvider>()
                  .pressButton(context, widget.buttonIndex, widget.tileIndex),
              child: Container(
                  height: 110,
                  width: 110,
                  padding: EdgeInsets.all(15),
                  decoration: new BoxDecoration(
                    border: blueBorderDecoration,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: colorButton,
                  ),
                  child: Center(
                    child: getContent(),
                  )))
        ],
      ),
    );
  }

  void _tapUp(TapUpDetails details) {
    setState(() {
      colorButton = paleBlue.withOpacity(0.2);
    });
  }

  void _tapDown(TapDownDetails details) {
    setState(() {
      colorButton = paleBlue.withOpacity(0.25);
    });
  }

  Widget getContent() {
    if (widget.text != null) {
      return AutoSizeText(
        widget.text,
        style: TextStyle(
            color: darkBlue, fontSize: 30, fontWeight: FontWeight.bold),
        minFontSize: 5,
        maxLines: 1,
      );
    } else {
      switch (widget.iconType) {
        case "up_arrow":
          return Icon(
            Ionicons.md_arrow_up,
            color: darkBlue,
            size: 50,
          );
        case "down_arrow":
          return Icon(Ionicons.md_arrow_down, color: darkBlue, size: 50);
      }
    }
  }
}
