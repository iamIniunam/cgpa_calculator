import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackgroundColor;

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
          width: 0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor),
                      ),
                      const SizedBox(height: 12),
                      Text(title),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
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

class StatsCardBig extends StatelessWidget {
  const StatsCardBig({super.key});

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
          width: double.infinity,
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
              Row(
                children: [
                  StatsDetails(
                    icon: Icons.school_rounded,
                    title: 'Required GPA',
                    value: '4.30',
                    iconColor: AppColors.red,
                    iconBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.redBackground
                            : AppColors.redLight,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  StatsDetails(
                    icon: Icons.track_changes_rounded,
                    title: 'Target',
                    value: '4.30',
                    iconColor: AppColors.blue,
                    iconBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.blueBackground
                            : AppColors.blueLight,
                  ),
                  StatsDetails(
                    icon: Icons.trending_up_rounded,
                    title: 'Projected',
                    value: '3.95',
                    iconColor: AppColors.orange,
                    iconBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.orangeBackground
                            : AppColors.orangeLight,
                    crossAxisAlignment: CrossAxisAlignment.end,
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

class StatsDetails extends StatelessWidget {
  const StatsDetails({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackgroundColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(title),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
