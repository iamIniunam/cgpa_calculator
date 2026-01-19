import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class GradingSystemView extends StatelessWidget {
  const GradingSystemView({
    super.key,
    required this.selectedScale,
    required this.onScaleChanged,
  });

  final GradingScale selectedScale;
  final ValueChanged<GradingScale> onScaleChanged;

  @override
  Widget build(BuildContext context) {
    const gradingScales = GradingScale.values;
    final gradingScaleNames = [
      'Standard GPA',
      'Extended GPA',
      'Five Point Scale',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Grading System',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'This determines how your CGPA is calculated.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 16),
          ...gradingScales.map(
            (grade) => GradeSystemCard(
              grade: grade,
              gradeName: gradingScaleNames[grade.index],
              selected: selectedScale == grade,
              onTap: () => onScaleChanged(grade),
            ),
          ),
        ],
      ),
    );
  }
}

class GradeSystemCard extends StatelessWidget {
  const GradeSystemCard({
    super.key,
    required this.grade,
    required this.gradeName,
    required this.selected,
    required this.onTap,
  });

  final GradingScale grade;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grade.name.toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                gradeName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
