import 'package:VennUI/components/ValuePicker.dart';
import 'package:VennUI/providers/SettingsProvider.dart';
import 'package:VennUI/utilies.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
            SettingsListElement("General", "general", "cog"),
            SettingsListElement("Heating Profile", "heating", "graph"),
            SettingsListElement("Pressure Profile", "pressure", "graph"),
          ],
        ));
  }
}

class GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.all(5),
              children: <Widget>[
                SettingsSubtitle("PID - Top heating plate"),
                SettingsItem("P Constant", Container()),
                SettingsItem("I Constant", Container()),
                SettingsItem("D Constant", Container()),
                SettingsSubtitle("PID - Bottom heating plate"),
                SettingsItem("P Constant", Container()),
                SettingsItem("I Constant", Container()),
                SettingsItem("D Constant", Container()),
                SettingsSubtitle("PID - Top heating plate"),
                SettingsItem("P Constant", Container()),
                SettingsItem("I Constant", Container()),
                SettingsItem("D Constant", Container()),
                SettingsSubtitle("PID - Bottom heating plate"),
                SettingsItem("P Constant", Container()),
                SettingsItem("I Constant", Container()),
                SettingsItem("D Constant", Container()),
              ],
            )),
          ],
        ));
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
              child: ValuePicker(),
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

class PressureSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            // ListView(
            //   padding: const EdgeInsets.all(8),
            //   children: <Widget>[Container()],
            // ),
          ],
        ));
  }
}

class HeatingSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            SettingPageReturn(),
            // ListView(
            //   padding: const EdgeInsets.all(8),
            //   children: <Widget>[Container()],
            // ),
          ],
        ));
  }
}

class SettingsListElement extends StatelessWidget {
  final String title;
  final String pageName;
  final String iconType;

  SettingsListElement(this.title, this.pageName, this.iconType);

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
                child: getIcon(),
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

  Icon getIcon() {
    switch (this.iconType) {
      case "cog":
        return Icon(
          SimpleLineIcons.settings,
          color: baseColor,
          size: 50,
        );
        break;
      case "graph":
        return Icon(
          SimpleLineIcons.graph,
          size: 50,
          color: baseColor,
        );
        break;
      default:
    }
    return null;
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
