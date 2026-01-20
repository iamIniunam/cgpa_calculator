import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/shared/components/app_dialog_widgets.dart';
import 'package:cgpa_calculator/ux/views/components/gpa_trajectory.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/components/semester_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // void _showGradingScaleDialog(BuildContext context, CGPAViewModel viewModel) {
  //   final data = viewModel.cgpaDataResult.value.data;
  //   showDialog(
  //     context: context,
  //     builder: (context) => GradingScaleDialog(
  //       currentScale: data?.selectedScale ?? GradingScale.scale43,
  //       onScaleChanged: (scale) {
  //         if (scale != null) viewModel.changeGradingScale(scale);
  //       },
  //     ),
  //   );
  // }

  void _showCourseDurationDialog(
      BuildContext context, CGPAViewModel viewModel) {
    final data = viewModel.cgpaDataResult.value.data;
    showDialog(
      context: context,
      builder: (context) => CourseDurationDialog(
        currentDuration: data?.selectedDuration ?? CourseDuration.fourYears,
        onCourseDurationChanged: (duration) {
          if (duration != null) viewModel.changeCourseDuration(duration);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CGPAViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ValueListenableBuilder<UIResult<CGPAData>>(
      valueListenable: viewModel.cgpaDataResult,
      builder: (context, result, child) {
        if (result.isLoading && result.data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = result.data ??
            CGPAData(
              semesters: [],
              cgpa: 0.0,
              selectedDuration: CourseDuration.fourYears,
            );

        final maxGrade =
            GradeCalculator.getMaxGrade(authViewModel.gradingScale);
        final totalCredits = viewModel.getTotalCredits();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image(
                    image: AppImages.appLogo3,
                    fit: BoxFit.cover,
                    height: 35,
                    width: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(AppStrings.appName,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              centerTitle: false,
              bottom: const Divider(height: 2).asPreferredSize(height: 1),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // _showGradingScaleDialog(context, viewModel);
                      },
                      icon: const Icon(Icons.settings, size: 18),
                      // label: Text('$scaleText ${AppStrings.scale}'),
                      label: const Text('Settings'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                CGPADisplay(
                  cgpa: data.cgpa,
                  maxGrade: maxGrade,
                  totalCredits: totalCredits,
                ),
                const GpaTrajectory(),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              icon: Icons.school_rounded,
                              title: 'Total Credits',
                              value: '84',
                              iconColor: AppColors.purple,
                              iconBackgroundColor: AppColors.purpleBackground,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: StatsCard(
                              icon: Icons.bar_chart_rounded,
                              title: 'Highest GPA',
                              value: '3.90',
                              iconColor: AppColors.green,
                              iconBackgroundColor: AppColors.greenBackground,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      StatsCard(
                        icon: Icons.my_location_rounded,
                        title: 'Target',
                        value: '4.30',
                        iconColor: AppColors.blue,
                        iconBackgroundColor: AppColors.blueBackground,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(AppStrings.semesters,
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () {
                              _showCourseDurationDialog(context, viewModel);
                            },
                            icon: const Icon(Icons.settings, size: 18),
                            label: Text(
                                '${data.selectedDuration.yearsText} ${AppStrings.years}'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  data.selectedDuration.semesterCount,
                  (index) {
                    final semesterNumber = index + 1;
                    final gpa = viewModel.getSemesterGPA(semesterNumber);
                    final crediHours =
                        viewModel.getSemesterTotalCredits(semesterNumber);
                    return SemesterCard(
                      semesterNumber: semesterNumber,
                      gpa: gpa,
                      creditHours: crediHours,
                      isFirst: index == 0,
                      isLast: index == data.selectedDuration.semesterCount - 1,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
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
    return Material(
      elevation: 2,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardBackground
          : Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: width ?? 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
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
      ),
    );
  }
}
