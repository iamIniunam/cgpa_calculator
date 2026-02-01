import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';

class GPADisplay extends StatelessWidget {
  const GPADisplay({super.key, required this.semester});

  final Semester semester;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.totalCredits,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textGrey
                          : AppColors.dark,
                    ),
              ),
              Text(
                semester.totalCreditUnits.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : AppColors.dark,
                    ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppStrings.gpa,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textGrey
                          : AppColors.dark,
                    ),
              ),
              Text(
                semester.formattedGPA,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppStrings.targetGPA,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textGrey
                          : AppColors.dark,
                    ),
              ),
              Text(
                semester.targetGPA != null
                    ? (semester.targetGPA?.toStringAsFixed(2) ?? '')
                    : '--',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : AppColors.dark,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
