import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/app_confirmation_botttom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/bottom_sheets/show_app_bottom_sheet.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/login_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/sign_up_page.dart';
import 'package:flutter/material.dart';

class DangerButtons extends StatefulWidget {
  const DangerButtons({super.key});

  @override
  State<DangerButtons> createState() => _DangerButtonsState();
}

class _DangerButtonsState extends State<DangerButtons> {
  final AuthViewModel authViewModel = AppDI.getIt<AuthViewModel>();

  void handleLogOut() async {
    AppDialogs.showLoadingDialog(context);
    await authViewModel.logout();
    if (!mounted) return;
    Navigation.navigateToScreenAndClearAllPrevious(
      context: context,
      screen: const LoginPage(),
    );
  }

  void handleDeleteAccount() async {
    AppDialogs.showLoadingDialog(context);
    try {
      await authViewModel.deleteAccount();
      if (!mounted) return;
      Navigation.navigateToScreenAndClearAllPrevious(
        context: context,
        screen: const SignUpPage(),
      );
    } catch (e) {
      Navigation.back(context: context);
      AppDialogs.showErrorDialog(
        context,
        errorMessage: e.toString().contains('requires-recent-login')
            ? 'Please log in again to delete your account.'
            : e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Danger Zone',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.transparentRed.withOpacity(0.9),
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              DangerButton(
                context: context,
                title: 'Log Out',
                icon: Icons.logout_rounded,
                onTap: () async {
                  final result = await showAppBottomSheet(
                    context: context,
                    showCloseButton: false,
                    child: const AppConfirmationBotttomSheet(
                      text: 'Are you sure you want to log out?',
                      title: 'Log Out',
                    ),
                  );
                  if (result == true) {
                    handleLogOut();
                  }
                },
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: DangerButton(
                    context: context,
                    title: 'Delete Account',
                    icon: Icons.delete_forever_rounded,
                    onTap: () async {
                      final result = await showAppBottomSheet(
                        context: context,
                        showCloseButton: false,
                        child: const AppConfirmationBotttomSheet(
                          text:
                              'Are you sure you want to delete your account?\nThis action cannot be undone.',
                          title: 'Delete Account',
                        ),
                      );
                      if (result == true) {
                        handleDeleteAccount();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DangerButton extends StatelessWidget {
  const DangerButton({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final BuildContext context;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppMaterial(
        inkwellBorderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.transparentRed
                : AppColors.transparentRed2,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
