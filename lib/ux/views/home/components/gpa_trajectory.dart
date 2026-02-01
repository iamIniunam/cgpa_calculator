import 'package:cgpa_calculator/ux/shared/components/status_dot.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/home/components/gpa_trajectory_data.dart';
import 'package:flutter/material.dart';

class GpaTrajectory extends StatelessWidget {
  const GpaTrajectory({
    super.key,
    required this.semesters,
    required this.totalSemesters,
    this.maxGradePoint,
  });

  final List<Semester> semesters;
  final int totalSemesters;
  final double? maxGradePoint;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.transparentBackgroundDark
          : AppColors.transparentBackgroundLight,
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.gpaTrajectory.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                        ),
                        Text(
                          '$totalSemesters semester(s)',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.textGrey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.dark
                          : AppColors.field2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const StatusDot(),
                        Text(
                          AppStrings.live.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GpaTrajectoryData(
              semesters: semesters,
              totalSemesters: totalSemesters,
              maxGradePoint: maxGradePoint,
            ),
          ],
        ),
      ),
    );
  }
}
