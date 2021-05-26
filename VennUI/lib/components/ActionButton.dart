import 'package:VennUI/providers/DashboardProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

enum buttonType {
  TWO_STATE_BUTTON,
  SINGLE_STATE_BUTTON,
  ICON_BUTTON,
}

class ActionButton extends StatefulWidget {
  final String text;
  final String title;
  final String iconType;
  final buttonType type;
  final int tileIndex;
  final int buttonIndex;

  ActionButton.text(
      this.title, this.text, this.type, this.buttonIndex, this.tileIndex)
      : iconType = null;
  ActionButton.icon(
      this.title, this.iconType, this.type, this.buttonIndex, this.tileIndex)
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
              onTapDown: (details) => _tapDown(context),
              onTapUp: (details) => _tapUp(context),
              onTap: () => _onTap(context),
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

  void _tapUp(BuildContext context) {
    setState(() {
      colorButton = paleBlue.withOpacity(0.2);
    });
    if (widget.type == buttonType.ICON_BUTTON) {
      context
          .read<DashboardProvider>()
          .pressButton(context, widget.buttonIndex, widget.tileIndex);
    }
  }

  void _tapDown(BuildContext context) {
    setState(() {
      colorButton = paleBlue.withOpacity(0.25);
    });
    if (widget.type == buttonType.ICON_BUTTON) {
      context
          .read<DashboardProvider>()
          .pressButton(context, widget.buttonIndex, widget.tileIndex);
    }
  }

  void _onTap(BuildContext context) {
    // Icon button actions are sent on tap down and tap up
    if (widget.type != buttonType.ICON_BUTTON) {
      context
          .read<DashboardProvider>()
          .pressButton(context, widget.buttonIndex, widget.tileIndex);
    }
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
