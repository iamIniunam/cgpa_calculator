import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_group.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSemesterPage extends StatefulWidget {
  const AddSemesterPage({super.key});

  @override
  State<AddSemesterPage> createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController targetGPAController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Course'),
          // actions: isEditMode
          //     ? [
          //         DeleteCourseButton(
          //           cgpaViewModel: cgpaViewModel,
          //           widget: widget,
          //         ),
          //       ]
          //     : null,
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
                  SettingsGroup(settingTiles: [
                    SettingTile(
                      title: 'Mark as current semester',
                      icon: Icons.check_circle_outline_rounded,
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (v) {},
                        activeColor: AppColors.primaryColor,
                      ),
                      dense: true,
                      showDivider: false,
                    ),
                  ])
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                onTap: () {},
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
