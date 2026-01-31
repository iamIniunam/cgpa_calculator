import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class GradeSystemCard extends StatelessWidget {
  const GradeSystemCard({
    super.key,
    this.grade,
    this.title,
    required this.gradeName,
    required this.selected,
    required this.onTap,
  });

  final GradingScale? grade;
  final String? title;
  final String gradeName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppMaterial(
        inkwellBorderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryColor
                : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardBackground
                    : AppColors.field2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grade?.name ?? title ?? '',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color:
                          (Theme.of(context).brightness == Brightness.light &&
                                  selected)
                              ? AppColors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.white
                                  : AppColors.dark),
                    ),
              ),
              Text(
                gradeName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color:
                          (Theme.of(context).brightness == Brightness.light &&
                                  selected)
                              ? Colors.white70
                              : AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
