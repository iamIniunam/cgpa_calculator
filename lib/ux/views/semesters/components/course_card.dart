import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/models/course_model.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_course_page.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.semester,
    this.isFirst = false,
    this.isLast = false,
  });

  final Course course;
  final Semester semester;
  final bool isFirst;
  final bool isLast;

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
              course.courseCode?.toUpperCase() ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('${course.creditUnits} ${AppStrings.credits}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        trailing: Container(
          width: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            course.grade?.toUpperCase() ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        shape: border(context),
        onTap: () {
          Navigation.navigateToScreen(
            context: context,
            screen: AddCoursePage(
              isEditMode: true,
              semester: semester,
              course: course,
            ),
          );
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
