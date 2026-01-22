import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/delete_course_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({
    super.key,
    this.existingCourse,
    this.semesterNumber,
    this.courseIndex,
  });

  final CourseInput? existingCourse;
  final int? semesterNumber;
  final int? courseIndex;

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late int selectedGradeIndex;
  late int creditHours;
  late TextEditingController courseCodeController;

  bool get isEditMode => widget.existingCourse != null;

  @override
  void initState() {
    super.initState();

    // if (isEditMode) {
    //   courseCodeController =
    //       TextEditingController(text: widget.existingCourse?.courseCode);
    //   creditHours = widget.existingCourse?.creditHours ?? 0;

    //   final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    //   final gradeOptions =
    //       GradeCalculator.getGradeOptions(authViewModel.gradingScale);
    //   selectedGradeIndex = gradeOptions.indexWhere(
    //     (option) => option.value == widget.existingCourse?.score,
    //   );
    //   if (selectedGradeIndex == -1) selectedGradeIndex = 0;
    // } else {
    //   courseCodeController = TextEditingController();
    //   creditHours = 3;
    //   selectedGradeIndex = 0;
    // }
  }

  // void saveCourse() {
  //   if (courseCodeController.text.trim().isEmpty) {
  //     AppDialogs.showErrorDialog(context,
  //         errorMessage: 'Please enter a course code');
  //     return;
  //   }
  //   final viewModel = Provider.of<AuthViewModel>(context, listen: false);
  //   // final gradeOptions =
  //       // GradeCalculator.getGradeOptions(viewModel.gradingScale);
  //   // final selectedGrade = gradeOptions[selectedGradeIndex];

  //   final courseInput = CourseInput(
  //     courseCode: courseCodeController.text.trim(),
  //     creditHours: creditHours,
  //     grade: selectedGrade.label,
  //     score: selectedGrade.value,
  //   );

  //   Navigation.back(context: context, result: courseInput);
  // }

  @override
  void dispose() {
    courseCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Course'),
          actions: isEditMode
              ? [
                  DeleteCourseButton(
                    widget: widget,
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
                  sectionHeader(context, 'Course code'),
                  const SizedBox(height: 8),
                  PrimaryTextFormField(
                    autofocus: true,
                    hintText: 'e.g. CS101',
                    // fillColor: Theme.of(context).brightness == Brightness.dark
                    //     ? AppColors.transparentBackgroundDark
                    //     : AppColors.transparentBackgroundLight,
                    // greyedOut: true,
                    controller: courseCodeController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 8),
                  sectionHeader(context, 'Performance'),
                  const SizedBox(height: 16),
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
                                      'Credit Hours',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      'Weight of the course',
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
                                    Text('$creditHours',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontSize: 16)),
                                    iconBox(
                                      icon: Icons.add_rounded,
                                      color: AppColors.primaryColor,
                                      onTap: () {
                                        if (creditHours < 3) {
                                          setState(() {
                                            creditHours++;
                                          });
                                        }
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
                                  'Grade Achieved',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              // if (gradeOptions.isNotEmpty)
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
                                    'gradeOptions[selectedGradeIndex].label',
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
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, int index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, int index) {
                              // final option = gradeOptions[index];
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
                                        'option.label',
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
                                    'option.gradePoint',
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
                onTap: () {},
                child: const Text('Add Course to Semester'),
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
