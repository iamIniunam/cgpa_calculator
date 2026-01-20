import 'package:cgpa_calculator/app.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await AppDi.init(sharedPreferences: sharedPreferences);
  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: const MyCGPAApp(),
    );
  }
}
