import 'package:cgpa_calculator/ux/shared/components/status_dot.dart';
import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/views/home/components/gpa_trajectory_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GpaTrajectory extends StatelessWidget {
  const GpaTrajectory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
      child: Material(
        // elevation: 2,
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
                            'GPA Trajectory',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '8 semesters',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.textGrey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
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
                            'Live'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const GpaTrajectoryData(
                semesters: [],
                totalSemesters: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
