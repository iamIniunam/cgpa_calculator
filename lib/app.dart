import 'dart:ui';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/shared/view_models/theme_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/grading_system_selection_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/login_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:cgpa_calculator/ux/views/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class ScholrApp extends StatelessWidget {
  const ScholrApp({super.key});

  ThemeViewModel get themeViewModel => AppDI.getIt<ThemeViewModel>();

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
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
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
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final SemesterViewModel _semesterViewModel = AppDI.getIt<SemesterViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _authViewModel.loadCurrentUser();

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      final user = _authViewModel.currentUser.value;
      if (user != null && user.id.isNotEmpty) {
        await _authViewModel.updateLastActive(user.id);
      }

      if (!mounted) return;
      if (user == null) {
        Navigation.navigateToScreenAndClearAllPrevious(
          context: context,
          screen: const LoginPage(),
        );
        return;
      }

      if (!_authViewModel.isLoggedIn()) {
        Navigation.navigateToScreenAndClearAllPrevious(
          context: context,
          screen: const LoginPage(),
        );
        return;
      }

      if (!mounted) return;

      if (!_authViewModel.isProfileComplete()) {
        Navigation.navigateToScreenAndClearAllPrevious(
          context: context,
          screen: const GradingSystemSelectionPage(),
        );
      } else {
        await _semesterViewModel.loadSemesters();
        if (!mounted) return;
        Navigation.navigateToHomePage(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
