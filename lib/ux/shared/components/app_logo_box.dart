import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:flutter/material.dart';

class AppLogoBox extends StatelessWidget {
  const AppLogoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.field2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image(image: AppImages.appLogo),
      ),
    );
  }
}

class AppLogoBoxBig extends StatelessWidget {
  const AppLogoBoxBig({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Image(
        image: AppImages.appLogo,
        fit: BoxFit.cover,
      ),
    );
  }
}
