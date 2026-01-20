import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // static const Color primaryColor = Color(0xFF294F56);
  static const Color primaryColor = Color(0xFF00606B);
  static const Color primaryColorLight = Color(0xFF6FBAC9);
  static const Color primaryColorGradientLight = Color(0xFF057C8A);
  static const Color primaryColorGradientDark = Color(0xFF00616C);
  static const Color primary500 = Color(0xFF0D47A1);
  static const Color scaffoldBackground2 = Color(0xFF303030);
  static const Color scaffoldBackground = Color(0xFF19202E);
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
  static const Color grey400 = Color(0xFF707070);
  static const Color disabledBorder = Color(0xFF616161);

  static const Color dark = Color(0xFF19191A);
  static const Color dark2 = Color(0xFF2E3B3D);
  static const Color grey = Color(0xFF94A3B8);
  static const Color textGrey = Color(0xFFA0A0A0);
  static const Color textGrey2 = Color(0xFFE6F0F1);
  static const Color textFieldBackground = Color(0xFF2E3B3D);
  static const Color cardBackground = Color(0xFF2C3033);

  static const Color purple = Color(0xFF4F46E5);
  static const Color purpleBackground = Color(0xFFEEF2FF);
  static const Color green = Color(0xFF059669);
  static const Color greenBackground = Color(0xFFECFDF5);
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueBackground = Color(0xFFE0F2FE);
  static  Color transparentBackgroundDark = Colors.white.withOpacity(0.11);
  static  Color transparentBackgroundLight = AppColors.primaryColor.withOpacity(0.1);
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

class AppGradients {
  AppGradients._();

  static LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryColorGradientDark,
      AppColors.primaryColorGradientDark.withOpacity(0.0),
    ],
  );

  static LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.white,
      AppColors.white,
      AppColors.white.withOpacity(0.0),
    ],
  );

  static LinearGradient bottomBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      AppColors.black.withOpacity(0.2),
      AppColors.black.withOpacity(0.4),
      // AppColors.black.withOpacity(0.6),
    ],
  );
}
