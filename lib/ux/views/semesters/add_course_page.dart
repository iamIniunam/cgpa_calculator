import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/app_confirmation_botttom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/show_app_bottom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/course_model.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/action_buttons.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/course_view_model.dart';
import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({
    super.key,
    required this.semester,
    this.course,
    this.isEditMode = false,
  });

  final Semester semester;
  final Course? course;
  final bool isEditMode;

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final CourseViewModel courseViewModel = AppDI.getIt<CourseViewModel>();
  final AuthViewModel authViewModel = AppDI.getIt<AuthViewModel>();

  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  int selectedGradeIndex = 0;
  int creditHours = 3;

  List<GradeMapping> get gradeOptions {
    final gradingScale =
        authViewModel.currentUser.value?.gradingScale ?? GradingScale.scale5_0;
    return gradingScale.gradeMappings;
  }

  bool get isEditMode => widget.isEditMode;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.course != null) {
      courseCodeController.text = widget.course?.courseCode ?? '';
      scoreController.text = widget.course?.score?.toString() ?? '';
      creditHours = widget.course?.creditUnits ?? 3;

      // Set selectedGradeIndex based on the grade in the course
      final grade = widget.course?.grade;
      final index = gradeOptions.indexWhere((g) => g.grade == grade);
      if (index != -1) {
        selectedGradeIndex = index;
      }
    }
  }

  void handleAddCourseResult() {
    final result = courseViewModel.addCourseResult.value;
    if (result.isSuccess) {
      Navigation.back(context: context, result: true);
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'Failed to add course.',
      );
    }
  }

  Future<void> addCourse() async {
    final courseCode = courseCodeController.text.trim();
    final gradingScale = authViewModel.currentUser.value?.gradingScale;

    if (courseCode.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please enter a valid course code.',
      );
      return;
    }

    final selectedGrade = gradeOptions[selectedGradeIndex].grade;
    final gradePoint = gradingScale?.getGradePoint(selectedGrade) ?? 0.0;

    AppDialogs.showLoadingDialog(context);
    final course = Course.create(
      courseCode: courseCode,
      creditUnits: creditHours,
      score: double.tryParse(scoreController.text.trim()),
      grade: selectedGrade,
      gradePoint: gradePoint,
    );

    await courseViewModel.addCourse(
        semesterId: widget.semester.id ?? '', course: course);
    if (!mounted) return;
    Navigation.back(context: context);
    handleAddCourseResult();
  }

  Future<void> updateCourse() async {
    final courseCode = courseCodeController.text.trim();
    final gradingScale = authViewModel.currentUser.value?.gradingScale;

    if (courseCode.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please enter a valid course code.',
      );
      return;
    }

    final selectedGrade = gradeOptions[selectedGradeIndex].grade;
    final gradePoint = gradingScale?.getGradePoint(selectedGrade) ?? 0.0;

    AppDialogs.showLoadingDialog(context);
    final updatedCourse = Course.create(
      id: widget.course?.id ?? '',
      courseCode: courseCode,
      creditUnits: creditHours,
      score: double.tryParse(scoreController.text.trim()),
      grade: selectedGrade,
      gradePoint: gradePoint,
      createdAt: widget.course?.createdAt,
    );

    await courseViewModel.updateCourse(
        semesterId: widget.semester.id ?? '', course: updatedCourse);
    if (!mounted) return;
    Navigation.back(context: context);
    handleUpdateCourseResult();
  }

  void handleUpdateCourseResult() {
    final result = courseViewModel.updateCourseResult.value;
    if (result.isSuccess) {
      AppDialogs.showSuccessDialog(
        context,
        successMessage: result.message ?? 'Course updated successfully.',
        onDismiss: () {
          Navigation.back(context: context);
          Navigation.back(context: context, result: true);
        },
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'Failed to update course.',
      );
    }
  }

  void deleteCourse() async {
    AppDialogs.showLoadingDialog(context);

    await courseViewModel.deleteCourse(
      semesterId: widget.semester.id ?? '',
      courseId: widget.course?.id ?? '',
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
  void dispose() {
    courseCodeController.dispose();
    scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(isEditMode ? AppStrings.editCourse : AppStrings.addCourse),
          actions: (isEditMode && widget.course?.id != null)
              ? [
                  DeleteActionButton(
                    onTap: () async {
                      bool res = await showAppBottomSheet(
                        context: context,
                        showCloseButton: false,
                        child: const AppConfirmationBotttomSheet(
                          text: AppStrings.areYouSureYouWantToDeleteThisCourse,
                          title: AppStrings.deleteCourse,
                        ),
                      );
                      if (res == true) {
                        deleteCourse();
                      }
                    },
                  ),
                ]
              : null,
          bottom: const Divider(height: 2).asPreferredSize(height: 1),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  sectionHeader(context, AppStrings.courseCode),
                  const SizedBox(height: 8),
                  PrimaryTextFormField(
                    autofocus: true,
                    hintText: AppStrings.courseCodeHintText,
                    controller: courseCodeController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 8),
                  sectionHeader(context, AppStrings.performance),
                  const SizedBox(height: 16),
                  PrimaryTextFormField(
                    labelText: AppStrings.scoreObtained,
                    hintText: AppStrings.scoreObtainedHintText,
                    controller: scoreController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.transparentBackgroundDark
                          : AppColors.transparentBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.creditHours,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      AppStrings.weightOfTheCourse,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textGrey,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.transparentBackgroundDark
                                      : AppColors.transparentBackgroundLight
                                          .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    iconBox(
                                      icon: Icons.remove_rounded,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.transparentBackgroundDark
                                          : AppColors.transparentBackgroundLight
                                              .withOpacity(0.2),
                                      onTap: () {
                                        if (creditHours > 0) {
                                          setState(() {
                                            creditHours--;
                                          });
                                        }
                                      },
                                    ),
                                    Text(creditHours.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontSize: 16)),
                                    iconBox(
                                      icon: Icons.add_rounded,
                                      color: AppColors.primaryColor,
                                      onTap: () {
                                        setState(() {
                                          creditHours++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.gradeAchieved,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.transparentBackgroundDark
                                      : AppColors.transparentBackgroundLight
                                          .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.white70, width: 0.3),
                                ),
                                child: Text(
                                  gradeOptions[selectedGradeIndex].grade,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 74,
                          child: ListView.separated(
                            itemCount: gradeOptions.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, int index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, int index) {
                              final option = gradeOptions[index];
                              final isSelected = selectedGradeIndex == index;
                              return Column(
                                children: [
                                  AppMaterial(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      setState(() {
                                        selectedGradeIndex = index;
                                      });
                                    },
                                    child: Container(
                                      height: 56,
                                      width: 56,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors
                                                    .transparentBackgroundDark
                                                : AppColors
                                                    .transparentBackgroundLight
                                                    .withOpacity(0.3)),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        option.grade,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option.gradePoint.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                onTap: isEditMode ? updateCourse : addCourse,
                child: Text(
                  isEditMode
                      ? AppStrings.updateCourse
                      : AppStrings.addCourseToSemester,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text sectionHeader(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 1.2),
    );
  }

  Widget iconBox({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: icon == Icons.add_rounded ? 12 : 0,
        right: icon == Icons.add_rounded ? 0 : 12,
      ),
      child: AppMaterial(
        inkwellBorderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppColors.white, size: 18),
        ),
      ),
    );
  }
}
