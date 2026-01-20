import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/add_course_page.dart';
import 'package:flutter/material.dart';

class DeleteCourseButton extends StatelessWidget {
  const DeleteCourseButton({
    super.key,
    required this.cgpaViewModel,
    required this.widget,
  });

  final CGPAViewModel cgpaViewModel;
  final AddCoursePage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: AppMaterial(
        inkwellBorderRadius: BorderRadius.circular(8),
        onTap: () {
          cgpaViewModel.removeCourseFromSemester(
            widget.semesterNumber ?? 0,
            widget.courseIndex ?? 0,
          );
          Navigation.back(context: context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Delete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
          ),
        ),
      ),
    );
  }
}
