import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FlutterLogo(size: 100),
            Image(
              image: AppImages.appLogo,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
