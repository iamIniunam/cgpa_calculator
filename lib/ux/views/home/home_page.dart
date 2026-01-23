import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/home/components/action_buttons.dart';
import 'package:cgpa_calculator/ux/views/home/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/home/components/gpa_trajectory.dart';
import 'package:cgpa_calculator/ux/views/home/components/stats_card.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SemesterViewModel semesterViewModel = AppDI.getIt<SemesterViewModel>();
  final AuthViewModel authViewModel = AppDI.getIt<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ValueListenableBuilder<List<Semester>>(
          valueListenable: semesterViewModel.semesters,
          builder: (context, semesters, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CGPADisplay(viewModel: semesterViewModel),
                const SizedBox(height: 16),
                GpaTrajectory(
                  semesters: semesters,
                  totalSemesters: semesters.length,
                  maxGradePoint:
                      authViewModel.currentUser.value?.gradingScale?.maxPoint ??
                          5.0,
                ),
                const SizedBox(height: 8),
                const ActionButtons(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            icon: Icons.school_rounded,
                            title: 'Total Credits',
                            value: semesterViewModel.totalCredits.toString(),
                            iconColor: AppColors.purple,
                            iconBackgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.purpleBackground
                                    : AppColors.purpleLight,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.track_changes_rounded,
                            title: 'Total Semesters',
                            value: semesterViewModel.totalSemesters.toString(),
                            iconColor: AppColors.green,
                            iconBackgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.greenBackground
                                    : AppColors.greenLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StatsCardBig(semesterViewModel: semesterViewModel),
                  ],
                ),
                const SizedBox(height: 95),
              ],
            );
          },
        ),
      ],
    );
  }
}
