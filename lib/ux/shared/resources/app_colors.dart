import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color primaryColor = Color(0xFF0D47A1);
  static const Color primary500 = Color(0xFF0D47A1);
  static const Color scaffoldBackground = Color(0xFF303030);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color greyInputBorder = Color(0xFFF8F9FB);
  static const Color lightFontGrey = Color(0xFFD2D6D9);
  static const Color backgroundGrey = Color(0xFFF2F2F2);
  static const Color field2 = Color(0xFFF2F4F5);
  static const Color red500 = Color(0xFFF00707);
  static const Color borderColor = Color(0xFFEAEAEA);
}

//This converts Hexadecimal color code to RGB or RGBA
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
