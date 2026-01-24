import 'dart:ui';

import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/app_confirmation_botttom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/show_app_bottom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/components/empty_state.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_course_page.dart';
import 'package:cgpa_calculator/ux/views/home/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/course_card.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/delete_course_button.dart';
import 'package:flutter/material.dart';
import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';

class SemesterDetailsPage extends StatefulWidget {
  const SemesterDetailsPage({super.key, required this.semester});

  final Semester semester;

  @override
  State<SemesterDetailsPage> createState() => _SemesterDetailsPageState();
}

class _SemesterDetailsPageState extends State<SemesterDetailsPage> {
  late Semester semester;
  final SemesterViewModel semesterViewModel = AppDI.getIt<SemesterViewModel>();

  @override
  void initState() {
    super.initState();
    semester = widget.semester;
    semesterViewModel.semesters.addListener(_onSemestersChanged);
  }

  void _onSemestersChanged() {
    final updated = semesterViewModel.semesters.value.firstWhere(
      (s) => s.id == semester.id,
      orElse: () => semester,
    );
    setState(() {
      semester = updated;
    });
  }

  Future<void> updateSemesterStatus() async {
    await semesterViewModel.updateSemesterStatus(
      semesterId: widget.semester.id ?? '',
      status: SemesterStatus.completed,
    );
  }

  @override
  void dispose() {
    semesterViewModel.semesters.removeListener(_onSemestersChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(semester.semesterName ?? ''),
          actions: semester.status == SemesterStatus.inProgress
              ? [
                  CompleteActionButton(
                    onTap: () async {
                      bool res = await showAppBottomSheet(
                        context: context,
                        showCloseButton: false,
                        child: const AppConfirmationBotttomSheet(
                          text:
                              'Are you sure you want to mark this semester as completed?',
                          title: 'Complete Semester',
                        ),
                      );
                      if (res == true) {
                        UiUtils.showToast(message: "Updating status...");
                        await updateSemesterStatus();
                        UiUtils.showToast(message: "Semester status updated");
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (!mounted) return;
                        Navigation.back(context: context);
                      }
                    },
                  ),
                ]
              : null,
          bottom: const Divider(height: 2).asPreferredSize(height: 1),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: (semester.courses ?? []).isEmpty
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
                          child: Builder(
                            builder: (context) {
                              final courses =
                                  (semester.courses ?? []).reversed.toList();
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  return CourseCard(
                                    course: courses[index],
                                    semester: semester,
                                    isFirst: index == 0,
                                    isLast: index == courses.length - 1,
                                  );
                                },
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
                        GPADisplay(semester: semester),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          onTap: () {
                            Navigation.navigateToScreen(
                              context: context,
                              screen: AddCoursePage(semester: semester),
                            );
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
  }
}
