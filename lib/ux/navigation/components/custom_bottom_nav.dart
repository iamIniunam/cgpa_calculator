import 'dart:ui';

import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.transparentBackgroundDark
                  : AppColors.transparentBackgroundLight.withOpacity(0.4),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) {
                  final isActive = currentIndex == index;
                  final icon = [
                    Iconsax.home5,
                    Icons.layers_rounded,
                    Iconsax.setting_45,
                  ][index];

                  final label = [
                    AppStrings.home,
                    AppStrings.semesters,
                    AppStrings.settings
                  ][index];

                  return AppMaterial(
                    inkwellBorderRadius: BorderRadius.circular(32),
                    onTap: () {
                      onTap(index);
                    },
                    child: isActive
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppGradients.primaryGradientDark
                                  : AppGradients.primaryGradientLight,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.white
                                      : AppColors.primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.white
                                        : AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.white.withOpacity(0.18)
                                  : AppColors.primaryColor.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: AppColors.white,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
