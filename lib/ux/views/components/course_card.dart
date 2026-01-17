import 'package:cgpa_calculator/ux/shared/components/app_dropdown_field.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String courseName;
  final int creditHours;
  final double grade;
  final List<GradeOption> gradeOptions;
  final VoidCallback onDelete;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int?> onCreditHoursChanged;
  final ValueChanged<double?> onGradeChanged;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.creditHours,
    required this.grade,
    required this.gradeOptions,
    required this.onDelete,
    required this.onNameChanged,
    required this.onCreditHoursChanged,
    required this.onGradeChanged,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late TextEditingController courseCodeController = TextEditingController();
  bool isLocked = false;
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    courseCodeController = TextEditingController(text: widget.courseName);
    isLocked = widget.courseName.trim().isNotEmpty;
  }

  @override
  void didUpdateWidget(CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseName != widget.courseName) {
      courseCodeController.text = widget.courseName;
      final wasLocked = isLocked;
      isLocked = widget.courseName.trim().isNotEmpty;
      if (wasLocked && !isLocked) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) nameFocusNode.requestFocus();
        });
      }
    }
  }

  @override
  void dispose() {
    courseCodeController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  void toggleLock() {
    setState(() {
      isLocked = !isLocked;
      if (!isLocked) {
        Future.delayed(const Duration(milliseconds: 100), () {
          nameFocusNode.requestFocus();
        });
      }
    });
  }

  void handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteCourse),
        content: Text(
          widget.courseName.isEmpty
              ? AppStrings.deleteCourse
              : '${AppStrings.delete} ${widget.courseName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmptyCourse = widget.courseName.trim().isEmpty;
    return Card(
      color: isLocked
          ? Colors.grey.shade900
          : AppColors.primaryColor.withOpacity(0.2),
      elevation: isLocked ? 1 : 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLocked ? Colors.transparent : AppColors.primaryColor,
          width: isLocked ? 0 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PrimaryTextFormField(
                    autofocus: true,
                    labelText: AppStrings.courseCode,
                    hintText: AppStrings.courseCodeHintText,
                    controller: courseCodeController,
                    enabled: !isLocked,
                    focusNode: nameFocusNode,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.primaryColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.disabledBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.blue.shade400, width: 2),
                    ),
                    onChanged: (value) {
                      widget.onNameChanged(value);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.characters,
                    hasBottomPadding: false,
                  ),
                ),
                const SizedBox(width: 8),
                if (!isEmptyCourse) ...[
                  iconBox(
                    color:
                        isLocked ? Colors.grey.shade800 : Colors.blue.shade700,
                    icon: isLocked
                        ? Icons.lock_outline_rounded
                        : Icons.lock_open_rounded,
                    iconColor: isLocked ? Colors.grey.shade400 : Colors.white,
                    onTap: toggleLock,
                  ),
                  const SizedBox(width: 8),
                ],
                iconBox(
                  color: Colors.red.shade900.withOpacity(0.3),
                  icon: Icons.delete_outline_rounded,
                  iconColor: Colors.red.shade200,
                  onTap: handleDelete,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppDropdownField(
                    valueHolder: widget.creditHours,
                    labelText: AppStrings.creditHours,
                    enabled: !isLocked,
                    stringItems: false,
                    dropdownItems: [0, 1, 2, 3]
                        .map((credits) => DropdownMenuItem(
                              value: credits,
                              child: Text('$credits CH'),
                            ))
                        .toList(),
                    onChanged: !isLocked
                        ? (value) => widget.onCreditHoursChanged(value as int?)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDropdownField(
                    valueHolder: widget.grade,
                    labelText: AppStrings.grade,
                    enabled: !isLocked,
                    stringItems: false,
                    dropdownItems: widget.gradeOptions
                        .map((grade) => DropdownMenuItem(
                              value: grade.value,
                              child: Text(grade.label),
                            ))
                        .toList(),
                    onChanged: !isLocked
                        ? (value) => widget.onGradeChanged(value as double?)
                        : null,
                  ),
                ),
              ],
            ),
            if (isLocked && !isEmptyCourse)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.courseLockedClickTheLockIconToEdit,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppMaterial iconBox({
    required Color color,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return AppMaterial(
      color: color,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      inkwellBorderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(11),
        child: Icon(
          icon,
          size: 25,
          color: iconColor,
        ),
      ),
    );
  }
}
