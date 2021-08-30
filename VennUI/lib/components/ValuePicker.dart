import 'package:VennUI/components/Notification.dart';
import 'package:VennUI/dialogs/EditSingleNumberDialog.dart';
import 'package:VennUI/providers/NotificationProvider.dart';
import 'package:VennUI/providers/SettingsProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ValuePicker extends StatefulWidget {
  ValuePicker(
      this.index, this.initialValue, this.max, this.min, this.updateValue);

  final double initialValue;
  final double max;
  final double min;
  final void Function(double, int) updateValue;
  final int index;

  @override
  _ValuePickerState createState() => _ValuePickerState(initialValue);
}

class _ValuePickerState extends State<ValuePicker> {
  _ValuePickerState(this.value);

  double value;

  @override
  Widget build(BuildContext context) {
    value = context.watch<SettingsProvider>().settings[widget.index].value;
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: greyBorder, width: 2.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 4,
                child: ValuePickerButton(
                  Feather.minus,
                  () => decreaseByOne(context),
                )),
            Expanded(
                flex: 5,
                child: Center(
                    child: GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (_) {
                              return EditSingleNumberDialogBox(
                                  value, widget.max, widget.min, update);
                            }),
                        child: AutoSizeText(
                          doubleAsString(value),
                          style: TextStyle(color: baseColor, fontSize: 45),
                          maxLines: 1,
                          minFontSize: 10,
                        )))),
            Expanded(
                flex: 4,
                child: ValuePickerButton(
                  Feather.plus,
                  () => increaseByOne(context),
                )),
          ],
        ),
      ),
    );
  }

  void update(BuildContext context, double v) {
    value = v;
    widget.updateValue(v, widget.index);
  }

  void increaseByOne(BuildContext context) {
    if (value + 1 > widget.max) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Warning,
          "Cannot increase more than the maximum value: " +
              widget.max.toString()));
      return;
    }
    setState(() {
      widget.updateValue(++value, widget.index);
    });
  }

  void decreaseByOne(BuildContext context) {
    if (value - 1 < widget.min) {
      context.read<NotificationProvider>().displayNotification(NotificationData(
          NotificationType.Warning,
          "Cannot decrease more than the minimum value: " +
              widget.min.toString()));
      return;
    }
    setState(() {
      widget.updateValue(--value, widget.index);
    });
  }
}

class ValuePickerButton extends StatefulWidget {
  final IconData data;
  final VoidCallback func;

  ValuePickerButton(this.data, this.func);

  @override
  _ValuePickerButtonState createState() => _ValuePickerButtonState();
}

class _ValuePickerButtonState extends State<ValuePickerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.func(),
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            // color: greyBackground,
            color: paleBlue,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Icon(this.widget.data,
              // color: greyIcon,
              color: darkBlue,
              size: 50),
        ));
  }
}
