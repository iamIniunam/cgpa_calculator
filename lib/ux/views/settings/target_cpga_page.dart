import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/app_confirmation_botttom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/show_app_bottom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:cgpa_calculator/ux/views/settings/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';

class TargetCGPAPage extends StatefulWidget {
  const TargetCGPAPage({super.key});

  @override
  State<TargetCGPAPage> createState() => _TargetCGPAPageState();
}

class _TargetCGPAPageState extends State<TargetCGPAPage> {
  final CGPAViewModel _cgpaViewModel = AppDI.getIt<CGPAViewModel>();
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final SemesterViewModel _semesterViewModel = AppDI.getIt<SemesterViewModel>();

  late double _currentSliderValue;
  late double _currentCGPA;
  late double _minCgpa;
  late double _maxCgpa;
  late int _completedCredits;
  late int _upcomingCredits;

  @override
  void initState() {
    super.initState();
    initializeValues();
    _cgpaViewModel.setTargetCGPAResult.addListener(handleSetTargetResult);
  }

  void initializeValues() {
    final user = _authViewModel.currentUser.value;
    final maxPoint = user?.maxGradePoint ?? 5.0;

    _currentCGPA = _semesterViewModel.currentCGPA;
    _currentSliderValue =
        user?.targetCGPA ?? (_currentCGPA + 0.15).clamp(0.0, maxPoint);
    _minCgpa = (_currentCGPA - 0.5).clamp(0.0, maxPoint);
    _maxCgpa = maxPoint;
    _completedCredits = _semesterViewModel.totalCredits;
    _upcomingCredits = estimateUpcomingCredits();
  }

  int estimateUpcomingCredits() {
    if (_semesterViewModel.completedSemestersCount == 0) return 15;

    final avgCreditsPerSemester =
        _completedCredits / _semesterViewModel.completedSemestersCount;
    return avgCreditsPerSemester.round();
  }

  void handleSetTargetResult() async {
    final result = _cgpaViewModel.setTargetCGPAResult.value;
    if (result.isLoading) {
      AppDialogs.showLoadingDialog(context);
    } else if (result.isSuccess) {
      Navigation.back(context: context);
      await AppDialogs.showSuccessDialog(context,
          successMessage: result.message ?? '');
      setState(() {});
    } else if (result.isError) {
      Navigation.back(context: context);
      AppDialogs.showErrorDialog(context, errorMessage: result.message ?? '');
    }
  }

  double calculateRequiredGPA() {
    return _cgpaViewModel.calculateRequiredSemesterGPA(
      currentCGPA: _currentCGPA,
      targetCGPA: _currentSliderValue,
      completedCredits: _completedCredits,
      upcomingCredits: _upcomingCredits,
    );
  }

  bool isTargetAchievable() {
    final maxPoint = _authViewModel.currentUser.value?.maxGradePoint ?? 5.0;
    return CGPACalculator.isTargetAchievable(
      currentCGPA: _currentCGPA,
      targetCGPA: _currentSliderValue,
      completedCredits: _completedCredits,
      upcomingCredits: _upcomingCredits,
      maxGradePoint: maxPoint,
    );
  }

  Future<void> handleSetTarget() async {
    await _cgpaViewModel.setTargetCGPA(targetCGPA: _currentSliderValue);
  }

  @override
  void dispose() {
    _cgpaViewModel.setTargetCGPAResult.removeListener(handleSetTargetResult);
    super.dispose();
  }

  bool isButtonDisabled() {
    final user = _authViewModel.currentUser.value;
    final targetCGPA = user?.targetCGPA;

    // Disable button if target is set and matches current slider value
    return targetCGPA != null &&
        (_currentSliderValue - targetCGPA).abs() < 0.01;
  }

  @override
  Widget build(BuildContext context) {
    final requiredGPA = calculateRequiredGPA();
    final isAchievable = isTargetAchievable();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Target CGPA'),
          bottom: const Divider(height: 2).asPreferredSize(height: 1),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColorGradientDark,
                          AppColors.primaryColorGradientLight,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current CGPA'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textGrey2,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentCGPA.toStringAsFixed(2),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontSize: 36,
                                    height: 1,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.textGrey2.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.greyInputBorder,
                              width: 0.3,
                            ),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            color: AppColors.white.withOpacity(0.7),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.transparentBackgroundDark
                          : AppColors.transparentBackgroundLight,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set Target CGPA'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        letterSpacing: 1.1,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Adjust based on graduation plans',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.textGrey2.withOpacity(0.2)
                                    : AppColors.transparentBackgroundLight
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.greyInputBorder,
                                  width: 0.3,
                                ),
                              ),
                              child: Text(
                                _currentSliderValue.toStringAsFixed(2),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontSize: 24,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Slider(
                          value: _currentSliderValue,
                          min: _minCgpa,
                          max: _maxCgpa,
                          label: _currentSliderValue.toStringAsFixed(2),
                          onChanged: (value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_minCgpa.toStringAsFixed(2),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(_maxCgpa.toStringAsFixed(2),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.transparentBackgroundDark
                          : AppColors.transparentBackgroundLight,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Required semester gpa'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          requiredGPA.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 60,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isAchievable
                              ? 'To reach your target CGPA of ${_currentSliderValue.toStringAsFixed(2)}, you need to achieve a semester GPA of ${requiredGPA.toStringAsFixed(2)} in your upcoming semester.'
                              : '⚠️ This target may not be achievable with the current grading scale. The required GPA exceeds the maximum possible grade.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.grey300
                                        : AppColors.grey400,
                                    fontSize: 16,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.transparentBackgroundDark
                          : AppColors.transparentBackgroundLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Based on $_completedCredits completed credits and estimated $_upcomingCredits upcoming credits.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Disable button after target is set and matches current
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                enabled: !isButtonDisabled(),
                onTap: () async {
                  bool res = await showAppBottomSheet(
                    context: context,
                    showCloseButton: false,
                    child: const AppConfirmationBotttomSheet(
                      text:
                          'Are you sure you want to set this as your target CGPA?',
                      title: 'Confirm Target CGPA',
                    ),
                  );
                  if (res == true) {
                    handleSetTarget();
                  }
                },
                child: const Text('Set target CGPA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
