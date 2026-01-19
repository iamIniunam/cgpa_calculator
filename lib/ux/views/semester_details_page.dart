import 'dart:ui';

import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/add_course_page.dart';
import 'package:cgpa_calculator/ux/views/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/components/course_card.dart';
import 'package:cgpa_calculator/ux/shared/components/empty_state.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SemesterDetailsPage extends StatelessWidget {
  const SemesterDetailsPage({super.key, required this.semesterNumber});

  final int semesterNumber;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CGPAViewModel>(context);

    return ValueListenableBuilder<UIResult<CGPAData>>(
      valueListenable: viewModel.cgpaDataResult,
      builder: (context, result, child) {
        final courses = viewModel.getCoursesForSemester(semesterNumber);
        final gpa = viewModel.getSemesterGPA(semesterNumber);
        final totalCredits = viewModel.getSemesterTotalCredits(semesterNumber);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('${AppStrings.semester} $semesterNumber'),
              bottom: const Divider(height: 2).asPreferredSize(height: 1),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: courses.isEmpty
                      ? const EmptyState()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, right: 16),
                              child: Text(AppStrings.courses,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  final course = courses[index];
                                  return CourseCard(
                                    courseCode: course.courseCode ?? '',
                                    creditHours: course.creditHours ?? 0,
                                    grade: course.grade ?? '',
                                    score: course.score ?? 0.0,
                                    semesterNumber: semesterNumber,
                                    courseIndex: index,
                                    isFirst: index == 0,
                                    isLast: index == courses.length - 1,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 66),
                          ],
                        ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        color: Colors.black.withOpacity(0.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GPADisplay(gpa: gpa, maxcredits: totalCredits),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              onTap: () async {
                                var result = await Navigation.navigateToScreen(
                                  context: context,
                                  screen: const AddCoursePage(),
                                );

                                if (result is CourseInput) {
                                  viewModel.addCourseToSemester(
                                      semesterNumber, result);
                                }
                              },
                              child: const Text('Add Course'),
                            ),
                          ],
                        ),
                      ),
                    ),
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
