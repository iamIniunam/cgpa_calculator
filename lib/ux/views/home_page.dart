import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/shared/components/app_dialog_widgets.dart';
import 'package:cgpa_calculator/ux/views/components/semester_card.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showGradingScaleDialog(BuildContext context, CGPAViewModel viewModel) {
    final data = viewModel.cgpaDataResult.value.data;
    showDialog(
      context: context,
      builder: (context) => GradingScaleDialog(
        currentScale: data?.selectedScale ?? GradingScale.scale43,
        onScaleChanged: (scale) {
          if (scale != null) viewModel.changeGradingScale(scale);
        },
      ),
    );
  }

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
              selectedScale: GradingScale.scale43,
              selectedDuration: CourseDuration.fourYears,
            );
        final scaleText = GradeCalculator.getScaleText(data.selectedScale);
        final maxGrade = GradeCalculator.getMaxGrade(data.selectedScale);

        return Scaffold(
          appBar: AppBar(
            title: Text('Hello, ${authViewModel.userName}!'),
            centerTitle: false,
            bottom: const Divider(height: 2).asPreferredSize(height: 1),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      _showGradingScaleDialog(context, viewModel);
                    },
                    icon: const Icon(Icons.settings, size: 18),
                    label: Text('$scaleText ${AppStrings.scale}'),
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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                CGPADisplay(cgpa: data.cgpa, maxGrade: maxGrade),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(AppStrings.semesters,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    _showCourseDurationDialog(
                                        context, viewModel);
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
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 8,
                            right: 16,
                            bottom: 16,
                          ),
                          itemCount: data.selectedDuration.semesterCount,
                          itemBuilder: (context, index) {
                            final semesterNumber = index + 1;
                            final gpa =
                                viewModel.getSemesterGPA(semesterNumber);
                            return SemesterCard(
                              semesterNumber: semesterNumber,
                              gpa: gpa,
                              isFirst: index == 0,
                              isLast: index ==
                                  data.selectedDuration.semesterCount - 1,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
