import 'dart:ui';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/view_models/theme_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/login_page.dart';
import 'package:cgpa_calculator/ux/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCGPAApp extends StatelessWidget {
  const MyCGPAApp({super.key});

  ThemeViewModel get themeViewModel => AppDi.getIt<ThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: themeViewModel.themeMode,
      builder: (context, mode, _) {
        ThemeMode themeMode;
        switch (mode) {
          case AppThemeMode.light:
            themeMode = ThemeMode.light;
            break;
          case AppThemeMode.dark:
            themeMode = ThemeMode.dark;
            break;
          case AppThemeMode.system:
          default:
            themeMode = ThemeMode.system;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightThemeData,
          darkTheme: AppTheme.darkThemeData,
          themeMode: themeMode,
          navigatorKey: Navigation.navigatorKey,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          home: const EntryPage(),
        );
      },
    );
  }
}

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      if (authViewModel.appUser != null) {
        Navigation.navigateToHomePage(context: context);
      } else {
        Navigation.navigateToScreenAndClearAllPrevious(
          context: context,
          screen: const LoginPage(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
