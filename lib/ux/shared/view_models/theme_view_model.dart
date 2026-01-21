import 'package:cgpa_calculator/platform/data_source/persistence/preference_manager.dart';
import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

class ThemeViewModel {
  final PreferenceManager preferenceManager = AppDI.getIt<PreferenceManager>();

  ValueNotifier<AppThemeMode> themeMode =
      ValueNotifier<AppThemeMode>(AppThemeMode.system);

  ThemeViewModel() {
    loadThemeMode();
  }

  void setThemeMode(AppThemeMode mode) {
    themeMode.value = mode;
    preferenceManager.setPreference(
      key: AppConstants.themeKey,
      value: mode.name,
    );
  }

  void loadThemeMode() {
    final saved = preferenceManager.getPreference(key: AppConstants.themeKey);
    if (saved != null) {
      final mode = AppThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppThemeMode.system,
      );
      themeMode.value = mode;
    }
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
