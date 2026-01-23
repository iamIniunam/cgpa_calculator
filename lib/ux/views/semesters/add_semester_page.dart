import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/app_confirmation_botttom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/show_app_bottom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/delete_course_button.dart';
import 'package:cgpa_calculator/ux/views/semesters/semesters_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_group.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSemesterPage extends StatefulWidget {
  const AddSemesterPage({
    super.key,
    this.semester,
    this.isEditMode = false,
  });

  final Semester? semester;
  final bool isEditMode;

  @override
  State<AddSemesterPage> createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  final SemesterViewModel semesterViewModel = AppDI.getIt<SemesterViewModel>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController targetGPAController = TextEditingController();
  SemesterStatus status = SemesterStatus.completed;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.semester != null) {
      final semester = widget.semester!;
      titleController.text = semester.semesterName ?? '';
      academicYearController.text = semester.academicYear ?? '';
      targetGPAController.text =
          semester.targetGPA != null ? semester.targetGPA.toString() : '';
      status = semester.status ?? SemesterStatus.completed;
    }
  }

  void toggleSemesterStatus(bool value) async {
    setState(() {
      status = value ? SemesterStatus.inProgress : SemesterStatus.completed;
    });
    if (widget.isEditMode) {
      Fluttertoast.showToast(
        msg: "Updating status...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      try {
        await updateSemesterStatus();
        if (mounted) {
          Fluttertoast.showToast(
            msg: "Semester status updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "Failed to update status",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    }
  }

  void handleSemesterCreationResult() {
    final result = semesterViewModel.createSemesterResult.value;
    if (result.isSuccess) {
      Navigation.navigateToScreen(
        context: context,
        screen: const SemestersPage(),
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to create semester. Please try again.',
      );
    }
  }

  Future<void> addSemester() async {
    final title = titleController.text.trim();
    final academicYear = academicYearController.text.trim();
    final targetGPA = targetGPAController.text.trim();

    if (title.isEmpty || academicYear.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all required fields.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);

    final semester = Semester.create(
      semesterName: title,
      academicYear: academicYear,
      status: status,
      targetGPA: targetGPA.isNotEmpty ? double.parse(targetGPA) : null,
    );

    await semesterViewModel.createSemester(semester);
    if (!mounted) return;
    Navigation.back(context: context);
    handleSemesterCreationResult();
  }

  Future<void> updateSemester() async {
    final title = titleController.text.trim();
    final academicYear = academicYearController.text.trim();
    final targetGPA = targetGPAController.text.trim();

    if (title.isEmpty || academicYear.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all required fields.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);

    final semester = Semester.create(
      id: widget.semester?.id,
      semesterName: title,
      academicYear: academicYear,
      status: status,
      targetGPA: targetGPA.isNotEmpty ? double.parse(targetGPA) : null,
      createdAt: widget.semester?.createdAt,
    );

    await semesterViewModel.updateSemester(semester);
    if (!mounted) return;
    Navigation.back(context: context);
  }

  void handleUpdateSemesterResult() {
    final result = semesterViewModel.updateSemesterResult.value;
    if (result.isSuccess) {
      AppDialogs.showSuccessDialog(
        context,
        successMessage: 'Semester updated successfully',
        onDismiss: () {
          Navigation.back(context: context);
          Navigation.back(context: context);
        },
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to update semester. Please try again.',
      );
    }
  }

  void deleteSemester() async {
    AppDialogs.showLoadingDialog(context);

    await semesterViewModel.deleteSemester(widget.semester?.id ?? '');
    if (!context.mounted) return;
    Navigation.back(context: context);
    final result = semesterViewModel.deleteSemesterResult.value;
    if (result.isSuccess) {
      AppDialogs.showSuccessDialog(
        context,
        successMessage: 'Semester deleted successfully',
        onDismiss: () {
          Navigation.back(context: context);
          Navigation.back(context: context);
        },
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to delete semester. Please try again.',
      );
    }
  }

  Future<void> updateSemesterStatus() async {
    if (widget.semester == null) return;
    await semesterViewModel.updateSemesterStatus(
      semesterId: widget.semester?.id ?? '',
      status: status,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    academicYearController.dispose();
    targetGPAController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditMode ? 'Update Semester' : 'Add Semester'),
          actions: widget.isEditMode
              ? [
                  DeleteActionButton(
                    onTap: () async {
                      bool res = await showAppBottomSheet(
                        context: context,
                        showCloseButton: false,
                        child: const AppConfirmationBotttomSheet(
                          text:
                              'Are you sure you want to delete this semester?',
                          title: 'Delete Semester',
                        ),
                      );
                      if (res == true) {
                        deleteSemester();
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
                  PrimaryTextFormField(
                    labelText: 'Semester Title',
                    hintText: 'e.g. Summer 2024',
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextFormField(
                    labelText: 'Academic Year',
                    hintText: 'e.g. 2023/2024',
                    controller: academicYearController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextFormField(
                    labelText: 'Target GPA',
                    hintText: 'e.g. 3.50',
                    optional: true,
                    controller: targetGPAController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  SettingsGroup(
                    settingTiles: [
                      SettingTile(
                        title: 'Mark as current semester',
                        icon: Icons.check_circle_outline_rounded,
                        trailing: CupertinoSwitch(
                          value: status == SemesterStatus.inProgress,
                          onChanged: toggleSemesterStatus,
                          activeColor: AppColors.primaryColor,
                        ),
                        dense: true,
                        showDivider: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                onTap: widget.isEditMode ? updateSemester : addSemester,
                child: Text(widget.isEditMode ? 'Update' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
