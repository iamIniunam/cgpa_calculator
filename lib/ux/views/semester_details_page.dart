import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/components/course_card.dart';
import 'package:cgpa_calculator/ux/shared/components/empty_state.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';
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
        final data = result.data;
        final courses = viewModel.getCoursesForSemester(semesterNumber);
        final gradeOptions = GradeCalculator.getGradeOptions(
            data?.selectedScale ?? GradingScale.scale43);
        final maxGrade = GradeCalculator.getMaxGrade(
            data?.selectedScale ?? GradingScale.scale43);
        final gpa = viewModel.getSemesterGPA(semesterNumber);

        return Scaffold(
          appBar: AppBar(
            title: Text('${AppStrings.semester} $semesterNumber'),
            bottom: const Divider(height: 2).asPreferredSize(height: 1),
          ),
          body: Column(
            children: [
              GPADisplay(gpa: gpa, maxGrade: maxGrade),
              const SizedBox(height: 8),
              Expanded(
                child: courses.isEmpty
                    ? const EmptyState()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, right: 16),
                            child: Text(AppStrings.courses,
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return CourseCard(
                                  courseName: course.name,
                                  creditHours: course.creditHours,
                                  grade: course.grade,
                                  gradeOptions: gradeOptions,
                                  onDelete: () {
                                    viewModel.removeCourseFromSemester(
                                      semesterNumber,
                                      index,
                                    );
                                  },
                                  onNameChanged: (value) {
                                    viewModel.updateCourse(
                                      semesterNumber,
                                      index,
                                      name: value,
                                    );
                                  },
                                  onCreditHoursChanged: (value) {
                                    viewModel.updateCourse(
                                      semesterNumber,
                                      index,
                                      creditHours: value ?? 3,
                                    );
                                  },
                                  onGradeChanged: (value) {
                                    viewModel.updateCourse(
                                      semesterNumber,
                                      index,
                                      grade: value ?? maxGrade,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue.shade800,
            onPressed: () => viewModel.addCourseToSemester(semesterNumber),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
