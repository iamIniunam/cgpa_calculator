import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_logo_box.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final TextEditingController emailController = TextEditingController();

  void handleForgotPasswordResult() {
    final result = _authViewModel.forgotPasswordResult.value;
    if (result.isSuccess) {
      AppDialogs.showSuccessDialog(
        context,
        successMessage: 'Check your email for password reset instructions.',
        title: 'Email Sent',
        onDismiss: () {
          Navigation.back(context: context);
          Navigation.back(context: context);
        },
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'An unexpected error occurred.',
      );
    }
  }

  Future<void> handleForgotPassword() async {
    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all the fields to continue.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);
    var request = ForgotPasswordRequest(email: email);
    await _authViewModel.sendPasswordResetEmail(request);
    if (!mounted) return;
    Navigation.back(context: context);
    handleForgotPasswordResult();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              const AppLogoBox(),
              const SizedBox(height: 20),
              Text(
                'Forgot your password?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'No worries! Enter your email address below and we\'ll send you a link to reset your password.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 36),
              PrimaryTextFormField(
                labelText: 'Email Address',
                hintText: 'student@university.edu',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 66),
              PrimaryButton(
                onTap: handleForgotPassword,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
