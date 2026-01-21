import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

class ThemeViewModel {
  ValueNotifier<AppThemeMode> themeMode =
      ValueNotifier<AppThemeMode>(AppThemeMode.system);

  void setThemeMode(AppThemeMode mode) {
    themeMode.value = mode;
  }

  bool isLightActive(BuildContext context) {
    final modeValue = themeMode.value;
    if (modeValue == AppThemeMode.light) return true;
    if (modeValue == AppThemeMode.system &&
        MediaQuery.of(context).platformBrightness == Brightness.light) {
      return true;
    }
    return false;
  }

  bool isDarkActive(BuildContext context) {
    final modeValue = themeMode.value;
    if (modeValue == AppThemeMode.dark) return true;
    if (modeValue == AppThemeMode.system &&
        MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return true;
    }
    return false;
  }
}
