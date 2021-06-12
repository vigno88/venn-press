import 'dart:ui';
import 'package:VennUI/components/Notification.dart';
import 'package:VennUI/providers/NotificationProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:VennUI/virtualKeyboard/virtualKeyboard.dart';
import 'package:provider/provider.dart';

class EditSingleNumberDialogBox extends StatefulWidget {
  EditSingleNumberDialogBox(
      this.initialValue, this.max, this.min, this.updateValue);

  final double initialValue;
  final double max;
  final double min;
  final void Function(BuildContext, double) updateValue;

  @override
  _EditSingleNumberDialogBoxState createState() =>
      _EditSingleNumberDialogBoxState(this.initialValue, this.max, this.min);
}

enum Field {
  Title,
  Info,
  None,
}

class _EditSingleNumberDialogBoxState extends State<EditSingleNumberDialogBox> {
  _EditSingleNumberDialogBoxState(this.value, this.max, this.min);

  TextEditingController? textController;
  double max;
  double min;
  double value;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: doubleAsString(value));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 775,
          width: 700,
          padding: EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Edit",
                style: TextStyle(fontSize: 40, color: baseColor),
              ),
              SizedBox(
                height: 20,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: greyBorder, width: 2.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: greyBorder,
                                                  width: 2.0))),
                                      child: Center(
                                        child: Text(
                                          getMinString(),
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Color(0xff7c7c7d),
                                          ),
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: Text(
                                    "Min",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff7c7c7d),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              textController!.text,
                              style: TextStyle(fontSize: 40, color: baseColor),
                            ),
                          )),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: greyBorder,
                                                  width: 2.0))),
                                      child: Center(
                                        child: Text(
                                          getMaxString(),
                                          style: TextStyle(
                                              fontSize: 40,
                                              color: Color(0xff7c7c7d)),
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: Text(
                                    "Max",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff7c7c7d),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: greyBorder, width: 2.0),
                  color: greyBackground,
                ),
                child: VirtualKeyboard(
                    height: 450,
                    textColor: greyIcon,
                    fontSize: 40,
                    type: VirtualKeyboardType.Numeric,
                    onKeyPress: (key) => updateKeyboard(key)),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: SaveButton("Save", () => saveChanges(context))),
            ],
          ),
        ),
      ],
    );
  }

  String getMaxString() {
    if (max == double.infinity) {
      return "N/D";
    }
    return doubleAsString(max);
  }

  String getMinString() {
    if (min == double.negativeInfinity) {
      return "N/D";
    }
    return doubleAsString(min);
  }

  void saveChanges(BuildContext context) {
    double valueD = 0;
    try {
      valueD = double.parse(textController!.text);
      if (valueD > widget.max) {
        context.read<NotificationProvider>().displayNotification(
            NotificationData(
                NotificationType.Warning,
                "Cannot set to a value bigger than the maximum: " +
                    widget.max.toString()));
      } else if (valueD < widget.min) {
        context.read<NotificationProvider>().displayNotification(
            NotificationData(
                NotificationType.Warning,
                "Cannot set to a value smaller than the minimum: " +
                    widget.min.toString()));
      } else {
        this.widget.updateValue(context, valueD);
      }
    } catch (exception) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Warning,
          "This cannot be used as a number: " + textController!.text));
    }
    Navigator.of(context).pop();
  }

  void updateKeyboard(VirtualKeyboardKey key) {
    setState(() {
      if (key.action == null) {
        textController!.text += key.text!;
        return;
      }
      if (key.action == VirtualKeyboardKeyAction.Backspace) {
        String str = textController!.text;
        if (str.length == 0) {
          return;
        }
        textController!.text = str.substring(0, str.length - 1);
        return;
      }
    });
  }
}

class SaveButton extends StatefulWidget {
  final String text;
  final Function f;

  SaveButton(this.text, this.f);

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  double _scale = 0;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2,
      ),
      lowerBound: 0.5,
      upperBound: 1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: () => widget.f(),
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
            color: paleBlue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow:
                tileShadows(5 * _scale, 1 * _scale, 3 * _scale, paleColor)),
        child: Material(
            color: Colors.transparent,
            child: Center(
              child: Text(
                this.widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: baseColor),
              ),
            )),
      ),
    );
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }
}
