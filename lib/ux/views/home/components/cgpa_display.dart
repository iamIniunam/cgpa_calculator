import 'package:cgpa_calculator/platform/extensions/string_extensions.dart';
import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/material.dart';

class CGPADisplay extends StatelessWidget {
  const CGPADisplay({super.key, required this.viewModel});

  final SemesterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ValueListenableBuilder<AppUser?>(
        valueListenable: AppDI.getIt<AuthViewModel>().currentUser,
        builder: (context, user, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.currentCGPA.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textGrey2, letterSpacing: 1.2),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textGrey2.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.greyInputBorder, width: 0.3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.cgpaChange >= 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: AppColors.white.withOpacity(0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          viewModel.cgpaChange >= 0
                              ? '+${viewModel.cgpaChange.toStringAsFixed(2)}'
                              : viewModel.cgpaChange.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    viewModel.currentCGPA.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.white, fontSize: 60, height: 1),
                  ),
                  Text(
                    '${AppStrings.targetCGPAHeading}${targetCGPAText(user?.targetCGPA)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textGrey2,
                        ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
