import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/grading_system_selection_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/login_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/sign_up_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthBottomSection extends StatelessWidget {
  AuthBottomSection({super.key, this.isLogin = false});

  final bool isLogin;
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final SemesterViewModel _semesterViewModel = AppDI.getIt<SemesterViewModel>();

  Future<void> signInWithGoogle(BuildContext context) async {
    AppDialogs.showLoadingDialog(context);

    await _authViewModel.signInWithGoogle();
    if (!context.mounted) return;

    handleAuthResult(context);
  }

  void handleAuthResult(BuildContext context) async {
    final result = _authViewModel.googleSignInResult.value;
    if (result.isSuccess) {
      if (isLogin &&
          _authViewModel.currentUser.value?.profileComplete == true) {
        await _semesterViewModel.loadSemesters();
        if (!context.mounted) return;
        Navigation.back(context: context);
        Navigation.navigateToHomePage(context: context);
      } else {
        Navigation.back(context: context);
        Navigation.navigateToScreen(
          context: context,
          screen: const GradingSystemSelectionPage(),
        );
      }
    } else if (result.isError) {
      Navigation.back(context: context);
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Authentication failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or continue with',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        AppMaterial(
          inkwellBorderRadius:
              BorderRadius.circular(AppDimens.defaultBorderRadius),
          onTap: () => signInWithGoogle(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppDimens.defaultBorderRadius),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.greyInputBorder
                    : AppColors.grey300,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImages.svgGoogleLogo,
                const SizedBox(width: 10),
                Text(
                  isLogin ? 'Sign in with Google' : 'Sign up with Google',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: isLogin ? 'New here? ' : 'Already have an account? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 13.5,
                ),
            children: <TextSpan>[
              TextSpan(
                text: isLogin ? 'Create an account' : 'Sign In',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigation.navigateToScreen(
                      context: context,
                      screen: isLogin ? const SignUpPage() : const LoginPage(),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
