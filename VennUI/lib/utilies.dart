import 'package:flutter/material.dart';

void showModal(BuildContext context, String title, String content) {
  AlertDialog alert = AlertDialog(
    scrollable: true,
    title: Text(title),
    content: Text(content),
    titleTextStyle:
        TextStyle(color: baseColor, fontWeight: FontWeight.bold, fontSize: 40),
    contentTextStyle: TextStyle(color: baseColor, fontSize: 23),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

BoxBorder blueBorderDecoration = Border.all(
  color: blueBorder,
  width: 2,
);

BoxBorder transparentBorderDecoration = Border.all(
  color: Colors.transparent,
  width: 2,
);
const Color baseColor = Color(0xff222f3e);
const Color infoColor = Color(0xff576574);
const Color paleColor = Color(0xff8395a7);
const Color oldBaseColor = Color(0xff14121f);
// final Color paleBlue = Color(0xff54a0ff);
// final Color blueBorder = Color(0xffb3d4ff);
// final Color darkBlue = Color(0xff2e86de);

final Color paleBlue = Color(0xffe0e9f7);
final Color paleBlueDarker = Color(0xffb3bac6);
final Color darkBlue = Color(0xff4884c9);
final Color blueBorder = Color(0xff4583cc);

final Color greyBackground = Color(0xfff6f8f9);
final Color greyIcon = Color(0xff767c7d);
final Color greyBorder = Color(0xffc5c6c7);

const serverIP = "127.0.0.1";
// const serverIP = "10.0.2.2";

int get1DCoord(int x, int y, int width) {
  return x + width * y;
}

int getYCoord(int i, int width) {
  return i ~/ width;
}

int getXCoord(int i, int width) {
  return i % width;
}

List<BoxShadow> tileShadows(
    double offset, double spreadRadius, double blurRadius, Color color) {
  return [
    BoxShadow(
      color: color.withOpacity(0.3),
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: Offset(0, offset),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: Offset(0, -offset),
    ),
  ];
}

String doubleAsString(double value) {
  return value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
}
