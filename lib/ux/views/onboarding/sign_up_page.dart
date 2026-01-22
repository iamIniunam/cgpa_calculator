import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_logo_box.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/grading_system_selection_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  void handleSignUpResult() {
    final result = _authViewModel.signUpResult.value;
    if (result.isSuccess) {
      Navigation.navigateToScreen(
        context: context,
        screen: const GradingSystemSelectionPage(),
      );
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            result.message ?? 'Failed to create account. Please try again.',
      );
    }
  }

  Future<void> handleSignUp() async {
    FocusScope.of(context).unfocus();
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all the fields to continue.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);
    var request = SignUpRequest(
      fullName: fullName,
      email: email,
      password: password,
    );

    await _authViewModel.signUp(request);
    if (!mounted) return;
    Navigation.back(context: context);
    handleSignUpResult();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    children: [
                      const AppLogoBox(),
                      const SizedBox(height: 20),
                      Text(
                        'Start tracking your progress.',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Create an account to get started',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.textGrey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 36),
                      PrimaryTextFormField(
                        labelText: 'Full Name',
                        hintText: 'John Doe',
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      PrimaryTextFormField(
                        labelText: 'Email',
                        hintText: 'student@university.edu',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      PrimaryTextFormField(
                        labelText: 'Password',
                        hintText: '∗∗∗∗∗∗∗∗∗',
                        obscureText: isPasswordObscured,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.none,
                        onChanged: (value) {
                          setState(() {});
                        },
                        suffixWidget: AppMaterial(
                          inkwellBorderRadius: BorderRadius.circular(8),
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textGrey.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        onTap: handleSignUp,
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
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
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w500),
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
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppDimens.defaultBorderRadius),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                              'Sign up with Google',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGrey,
                              fontSize: 13.5,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigation.navigateToScreen(
                                  context: context,
                                  screen: const LoginPage(),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
