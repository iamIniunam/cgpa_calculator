import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/course_view_model.dart';
import 'package:flutter/material.dart';

class DeleteCourseButton extends StatelessWidget {
  const DeleteCourseButton(
      {super.key, required this.courseViewModel, required this.semesterId, required this.courseId});

  final CourseViewModel courseViewModel;
  final String semesterId;
  final String courseId;

  void deleteCourse(BuildContext context) async {
    AppDialogs.showLoadingDialog(context);

    await courseViewModel.deleteCourse(
      semesterId: semesterId,
      courseId: courseId,
    );
    if (!context.mounted) return;
    Navigation.back(context: context);
    final result = courseViewModel.deleteCourseResult.value;
    if (result.isSuccess) {
      AppDialogs.showSuccessDialog(
        context,
        successMessage: 'Course deleted successfully',
        onDismiss: () {
          Navigation.back(context: context);
          Navigation.back(context: context);
        },
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to delete course. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AppMaterial(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        inkwellBorderRadius: BorderRadius.circular(10),
        onTap: () => deleteCourse(context),
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
