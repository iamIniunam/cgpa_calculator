import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SemesterSearch extends StatelessWidget {
  const SemesterSearch({super.key, required this.onSearchToggle});

  final VoidCallback onSearchToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: AppMaterial(
          onTap: onSearchToggle,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.transparentBackgroundDark
                    : AppColors.transparentBackgroundLight.withOpacity(0.4),
                shape: BoxShape.circle),
            child: const Icon(
              Iconsax.search_normal,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
