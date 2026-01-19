import 'package:cgpa_calculator/ux/shared/components/status_dot.dart';
import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/components/gpa_trajectory_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GpaTrajectory extends StatelessWidget {
  const GpaTrajectory({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CGPAViewModel>(context);

    return ValueListenableBuilder<UIResult<CGPAData>>(
      valueListenable: viewModel.cgpaDataResult,
      builder: (context, result, _) {
        final data = result.data;
        if (data == null) return const SizedBox.shrink();

        final hasData = data.semesters.isNotEmpty;
        if (!hasData) return const SizedBox.shrink();

        return Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade900, width: 0.5),
            ),
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
                          color: AppColors.dark,
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
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GpaTrajectoryData(
                  semesters: data.semesters,
                  totalSemesters: data.selectedDuration.semesterCount,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
