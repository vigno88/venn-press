import 'package:VennUI/dialogs/ValuePickerDialog.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ValuePicker extends StatefulWidget {
  // final double value;

  // const ValuePicker(this.value);

  @override
  _ValuePickerState createState() => _ValuePickerState();
}

class _ValuePickerState extends State<ValuePicker> {
  double value = 2.0030;

  @override
  Widget build(BuildContext context) {
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
                  () => decreaseByOne(),
                )),
            Expanded(
                flex: 5,
                child: Center(
                    child: GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (_) {
                              return ValuePickerDialogBox();
                              // return ChangeNotifierProvider.value(
                              //     // value: provider, child: EditDialogBox());
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
                  () => increaseByOne(),
                )),
          ],
        ),
      ),
    );
  }

  void increaseByOne() {
    setState(() {
      value += 1;
    });
  }

  void decreaseByOne() {
    setState(() {
      value -= 1;
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
