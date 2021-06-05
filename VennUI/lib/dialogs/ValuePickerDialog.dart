import 'dart:ui';
import 'package:VennUI/utilies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:VennUI/virtualKeyboard/virtualKeyboard.dart';

class ValuePickerDialogBox extends StatefulWidget {
  const ValuePickerDialogBox({Key? key}) : super(key: key);

  @override
  _ValuePickerDialogBoxState createState() => _ValuePickerDialogBoxState();
}

enum Field {
  Title,
  Info,
  None,
}

class _ValuePickerDialogBoxState extends State<ValuePickerDialogBox> {
  // RecipeInfo selectedRecipe;
  // TextEditingController titleController;
  // Field selectedField = Field.None;
  // bool isCapsOn = false;
  double max = 1000;
  double min = 0;
  double value = 50;

  @override
  Widget build(BuildContext context) {
    // selectedRecipe = context
    //     .watch<SettingsProvider>()
    //     .recipesInfo[context.watch<SettingsProvider>().hoverRecipe];
    // titleController = TextEditingController(text: selectedRecipe.title);
    // infoController = TextEditingController(text: selectedRecipe.info);
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
                style: TextStyle(
                    fontSize: 40,
                    // fontWeight: FontWeight.w600,
                    color: baseColor),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                              doubleAsString(min),
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
                                  doubleAsString(value),
                                  style:
                                      TextStyle(fontSize: 40, color: baseColor),
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
                                              doubleAsString(max),
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
                        )
                        // child: Text(
                        //   doubleAsString(value),
                        //   style: TextStyle(fontSize: 27),
                        // )
                        ),
                    // SizedBox(width: 20),
                    // Expanded(child: Container()),
                    // Expanded(
                    //     flex: 2,
                    //     child: SaveButton("Save", () => saveChanges(context))),
                  ]),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: greyBorder, width: 2.0),
                  // color: paleBlue.withOpacity(0.4),
                  // color: paleBlueNew,
                  color: greyBackground,
                ),
                child: VirtualKeyboard(
                    height: 450,
                    // textColor: Colors.black,
                    textColor: greyIcon,
                    // textColor: darkBlueNew,
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

  void saveChanges(BuildContext context) {
    // selectedRecipe.info = infoController.text;
    // selectedRecipe.title = titleController.text;
    // context.read<SettingsProvider>().editRecipe(context, selectedRecipe);
    Navigator.of(context).pop();
  }

  void updateKeyboard(VirtualKeyboardKey key) {
    // TextEditingController controller;
    // switch (selectedField) {
    //   case Field.None:
    //     return;
    //   case Field.Info:
    //     controller = infoController;
    //     break;
    //   case Field.Title:
    //     controller = titleController;
    //     break;
    // }
    // // Check if the key is a char value
    // if (key.action == null) {
    //   if (isCapsOn) {
    //     controller.text += key.capsText;
    //     return;
    //   }
    //   controller.text += key.text;
    //   return;
    // }
    // if (key.action == VirtualKeyboardKeyAction.Backspace) {
    //   String str = controller.text;
    //   if (str.length == 0) {
    //     return;
    //   }
    //   controller.text = str.substring(0, str.length - 1);
    //   return;
    // }
    // if (key.action == VirtualKeyboardKeyAction.Space) {
    //   controller.text += ' ';
    //   return;
    // }
    // if (key.action == VirtualKeyboardKeyAction.Shift) {
    //   isCapsOn = !isCapsOn;
    //   return;
    // }
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
            // color: Colors.white,
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
