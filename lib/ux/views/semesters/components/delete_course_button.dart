import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_course_page.dart';
import 'package:flutter/material.dart';

class DeleteCourseButton extends StatelessWidget {
  const DeleteCourseButton({
    super.key,
    required this.widget,
  });

  final AddCoursePage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AppMaterial(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        inkwellBorderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigation.back(context: context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            'Delete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class CompleteCourseButton extends StatelessWidget {
  const CompleteCourseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AppMaterial(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        inkwellBorderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigation.back(context: context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            'Complete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
