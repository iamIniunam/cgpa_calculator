import 'dart:async';
import 'dart:io';

import 'package:cgpa_calculator/app.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runAppWithZone();
}

void runAppWithZone() {
  runZonedGuarded<Future<void>>(() async {
    final appFuture = initializeApp();
    runApp(
      FutureBuilder<SharedPreferences>(
        future: appFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SplashScreen();
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthViewModel()),
              ChangeNotifierProxyProvider<AuthViewModel, CGPAViewModel>(
                create: (context) => CGPAViewModel(
                  authViewModel: context.read<AuthViewModel>(),
                ),
                update: (context, authViewModel, previous) =>
                    previous ?? CGPAViewModel(authViewModel: authViewModel),
              ),
            ],
            child: const ScholrApp(),
          );
        },
      ),
    );
  }, errorHandler);
}

Future<SharedPreferences> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  try {
    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
    ]);
  } catch (e) {
    if (kDebugMode) {
      print('Error during first services initialization: $e');
    }
  }

  try {
    await Future.wait([AppDi.init(sharedPreferences: sharedPreferences)]);
  } catch (e) {
    if (kDebugMode) {
      print('Error during second services initialization: $e');
    }
  }
  return sharedPreferences;
}

void errorHandler(Object error, StackTrace stack) {
  if (kDebugMode) {
    print('Error: $error');
    print('Stack trace: $stack');
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
