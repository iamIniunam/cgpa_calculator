import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/grading_system_view.dart';
import 'package:flutter/material.dart';

class GradingSystemSelectionPage extends StatefulWidget {
  const GradingSystemSelectionPage({super.key, this.isEditMode = false});

  final bool isEditMode;

  @override
  State<GradingSystemSelectionPage> createState() =>
      _GradingSystemSelectionPageState();
}

class _GradingSystemSelectionPageState
    extends State<GradingSystemSelectionPage> {
  List<GradingScale> gradingScales = GradingScale.values;
  GradingScale? selectedScale = GradingScale.scale43;

  bool scaleNotListed = false;

  final gradingScaleNames = [
    'Standard GPA',
    'Extended GPA',
    'Five Point Scale',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Text(
                  'Institution Name (optional)',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                PrimaryTextFormField(
                  hintText: 'e.g.Accra Institute of Technology',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 18),
                Text(
                  'Grading System',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  'This determines how your CGPA is calculated.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 16),
                ...gradingScales.map(
                  (grade) => GradeSystemCard(
                    grade: grade,
                    gradeName: gradingScaleNames[grade.index],
                    selected: selectedScale == grade && !scaleNotListed,
                    onTap: () {
                      setState(() {
                        selectedScale = grade;
                        scaleNotListed = false;
                      });
                    },
                  ),
                ),
                GradeSystemCard(
                  title: 'Custom Scale',
                  gradeName: 'My scale is not listed',
                  selected: scaleNotListed,
                  onTap: () {
                    setState(() {
                      scaleNotListed = !scaleNotListed;
                      if (scaleNotListed) {
                        selectedScale = null;
                      }
                    });
                  },
                ),
                Visibility(
                  visible: scaleNotListed,
                  child: PrimaryTextFormField(
                    hintText: 'Enter grade scale',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: PrimaryButton(
              onTap: () {
                widget.isEditMode
                    ? Navigation.back(context: context)
                    : Navigation.navigateToHomePage(context: context);
              },
              child: Text(widget.isEditMode ? 'Save' : AppStrings.continueText),
            ),
          ),
        ],
      ),
    );
  }
}
