import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SemesterStats extends StatelessWidget {
  const SemesterStats({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.width,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.transparentBackgroundDark
            : AppColors.transparentBackgroundLight,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: width ?? 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: AppColors.transparentBackgroundLight.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.7
                          : 0.4,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase()),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
