import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/grade_system_card.dart';
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
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController customScaleController = TextEditingController();
  List<GradingScale> gradingScales = GradingScale.predefinedScales;
  GradingScale? selectedScale;

  bool scaleNotListed = false;

  final gradingScaleNames = [
    'Standard GPA',
    'Extended GPA',
    'Five Point Scale',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      final currentScale = _authViewModel.currentUser.value?.gradingScale ??
          GradingScale.scale4_3;
      if (gradingScales.contains(currentScale)) {
        selectedScale = currentScale;
      } else {
        scaleNotListed = true;
        selectedScale = null;
        customScaleController.text = currentScale.toString();
      }
    }
  }

  void handleCompleteProfileResult() {
    final result = _authViewModel.completeProfileResult.value;
    if (result.isSuccess) {
      // AppDialogs.showSuccessDialog(context,
      //     successMessage: result.message ?? 'Profile updated successfully.');
      Navigation.navigateToHomePage(context: context);
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to create account. Please try again.',
      );
    }
  }

  void handleUpdateProfileResult() {
    final result = _authViewModel.updateProfileResult.value;
    if (result.isSuccess) {
      Navigation.back(context: context);
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to create account. Please try again.',
      );
    }
  }

  Future<void> handleCompleteProfile() async {
    FocusScope.of(context).unfocus();
    final institutionName = institutionController.text.trim();
    final scale = selectedScale;

    if (!widget.isEditMode && institutionName.isEmpty || scale == null) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all the fields to continue.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);

    var completeProfileRequest = CompleteProfileRequest(
      school: institutionName,
      gradingScale: scale,
    );

    var updateProfileRequest = UpdateUserProfileRequest(gradingScale: scale);

    if (widget.isEditMode) {
      await _authViewModel.updateProfile(updateProfileRequest);
      if (!mounted) return;
      Navigation.back(context: context);
      handleUpdateProfileResult();
    } else {
      await _authViewModel.completeProfile(completeProfileRequest);
      if (!mounted) return;
      Navigation.back(context: context);
      handleCompleteProfileResult();
    }
  }

  @override
  void dispose() {
    institutionController.dispose();
    customScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Visibility(
                    visible: !widget.isEditMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.institutionNameOptional,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),
                        PrimaryTextFormField(
                          hintText: AppStrings.institutionNameHintText,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          controller: institutionController,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                  Text(
                    AppStrings.gradingSystem,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.thisDeterminesHowYourCGPAIsCalculated,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...gradingScales.asMap().entries.map(
                        (entry) => GradeSystemCard(
                          grade: entry.value,
                          gradeName: gradingScaleNames.length > entry.key
                              ? gradingScaleNames[entry.key]
                              : 'Custom',
                          selected:
                              selectedScale == entry.value && !scaleNotListed,
                          onTap: () {
                            setState(() {
                              selectedScale = entry.value;
                              scaleNotListed = false;
                            });
                          },
                        ),
                      ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PrimaryButton(
                onTap: handleCompleteProfile,
                child:
                    Text(widget.isEditMode ? AppStrings.save : AppStrings.continueText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
