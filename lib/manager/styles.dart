

import 'dart:math';

import 'package:flutter/material.dart';

final myTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  //backgroundColor: Colors.white,
  primarySwatch: primaryColorMat,

);
// Define the palette colors
const Color primaryColor = Color(0xFF0097A7);
const Color secondaryColor = Color(0xFFB2EBF2);
const Color accentColor = Color(0xFF006064);
const Color accentColor0   = Color(0xFF024855);
const Color dialogsCol = secondaryColor;
const Color loadingCol = accentColor0;
const Color FocusTextFieldColor = Colors.blue;
const Color DisabledTextFieldColor = Colors.blue;
const Color customColor1 = Color(0xFF0F8D9C);
const Color appbarColor  = Color(0xFF096C7A);
const Color settingIconColor  = appbarColor;
const Color chartValuesColor  = Colors.white;
const Color cardColor  = Color(0xff003A44);
const Color oldCardCol  = Colors.white38;
const Color newCardCol  = Colors.greenAccent;
const Color valuePopColor = customColor1;
const Color touchVerticalLineColor = accentColor;

const mainCol = Color(0xFFffd716);//ylw
const mainCol2 = Color(0xFF16254b);//blue
const buttonStyleCol = Color(0xFFffd716);
const dialogBackgroundColor = secondaryColor;

const yellowColHex = Color(0XFFffd716);
const greyColHex = Color(0XFFB0B0B0);
const hintYellowColHex = Color(0X60ffd716);
const hintYellowColHex2 = Color(0X80ffd716);
const blueColHex = Color(0XFF0a1227);
const blueColHex3 = Color(0X700a1227);
const blueColHex2 = Color(0XFF16254b);


const MaterialColor primaryColorMat = MaterialColor(
  0xFF0097A7,
  <int, Color>{
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF0097A7),
    600: Color(0xFF00838F),
    700: Color(0xFF006064),
    800: Color(0xFF004D40),
    900: Color(0xFF00251A),
  },
);
const MaterialColor customColor = MaterialColor(
  0xFF024855,
  <int, Color>{
    50: Color(0xFFD4ECE8),
    100: Color(0xFFA8DAD2),
    200: Color(0xFF7DBCB9),
    300: Color(0xFF519E9F),
    400: Color(0xFF297D85),
    500: Color(0xFF006764),
    600: Color(0xFF005C57),
    700: Color(0xFF004E4A),
    800: Color(0xFF00403D),
    900: Color(0xFF002A28),
  },
);

TextStyle highlightStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.transparent,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.w500,
  shadows: [Shadow(color: Colors.red, offset: Offset(0, -1))],
  decorationColor: Colors.red,
  decorationThickness: 1,
  decorationStyle: TextDecorationStyle.solid,
);
TextStyle bodyStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
);

ButtonStyle borderStyle({Color color = primaryColor}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    shape: RoundedRectangleBorder(
        side:  BorderSide(color: color, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(100)),
  );
}
ButtonStyle filledStyle({Color color = primaryColor}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  );
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
Color getRandomColor1() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,

  );
}