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
import 'package:flutter/services.dart';
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
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
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
                  totalCredits: viewModel.getTotalCredits(),
                ),
                const GpaTrajectory(),
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
