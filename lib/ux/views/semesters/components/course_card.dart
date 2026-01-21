import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_course_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseCard extends StatelessWidget {
  final int creditHours;
  final String grade;
  final String courseCode;
  final double score;
  final int semesterNumber;
  final int courseIndex;
  final bool isFirst;
  final bool isLast;

  const CourseCard({
    super.key,
    required this.creditHours,
    required this.grade,
    required this.courseCode,
    required this.score,
    required this.semesterNumber,
    required this.courseIndex,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0),
      shape: border(context),
      child: ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              courseCode.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('$creditHours Credits',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            grade.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        shape: border(context),
        onTap: () async {
          final result = await Navigation.navigateToScreen(
            context: context,
            screen: AddCoursePage(
              existingCourse: CourseInput(
                courseCode: courseCode,
                creditHours: creditHours,
                grade: grade,
                score: score,
              ),
              semesterNumber: semesterNumber,
              courseIndex: courseIndex,
            ),
          );

          // if (result != null && result is CourseInput) {
          //   viewModel.updateCourse(
          //     semesterNumber,
          //     courseIndex,
          //     courseCode: result.courseCode,
          //     creditHours: result.creditHours,
          //     grade: result.grade,
          //     score: result.score,
          //   );
          // }
        },
      ),
    );
  }

  RoundedRectangleBorder border(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(24) : Radius.zero,
        topRight: isFirst ? const Radius.circular(24) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(24) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(24) : Radius.zero,
      ),
      side: BorderSide(color: Theme.of(context).dividerColor, width: 0),
    );
  }
}
