import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // static const Color primaryColorColor.fromRGBO(21, 101, 192, 1)C0);
  static const Color primaryColor = Color(0xFF294F56);
  static const Color primaryColorLight = Color(0xFF6FBAC9);
  static const Color primary500 = Color(0xFF0D47A1);
  static const Color scaffoldBackground = Color(0xFF303030);
  static const Color disabledButton = Color(0xFF4A4A4A);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color greyInputBorder = Color(0xFFF8F9FB);
  static const Color lightFontGrey = Color(0xFFD2D6D9);
  static const Color backgroundGrey = Color(0xFFF2F2F2);
  static const Color field2 = Color(0xFFF2F4F5);
  static const Color red500 = Color(0xFFF00707);
  static const Color borderColor = Color(0xFFEAEAEA);
  static const Color grey200 = Color(0xFFE8E8E8);
  static const Color grey300 = Color(0xFF9D9D9D);
  static const Color disabledBorder = Color(0xFF616161);

  static const Color dark = Color(0xFF19191A);
  static const Color dark2 = Color(0xFF2E3B3D);
  static const Color textGrey = Color(0xFFA0A0A0);
  static const Color textFieldBackground = Color(0xFF2E3B3D);
  static const Color cardBackground = Color(0xFF2C3033);
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
