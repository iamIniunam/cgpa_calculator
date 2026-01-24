import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_logo_box.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/auth_bottom_section.dart';
import 'package:cgpa_calculator/ux/views/onboarding/forgot_password_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  void handleLoginResult() {
    final result = _authViewModel.loginResult.value;
    if (result.isSuccess) {
      Navigation.navigateToHomePage(context: context);
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'Login failed. Please try again.',
      );
    }
  }

  Future<void> handleLogin() async {
    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: 'Please fill in all the fields to continue.',
      );
      return;
    }

    AppDialogs.showLoadingDialog(context);
    var request = LoginRequest(
      email: email,
      password: password,
    );

    await _authViewModel.login(request);
    if (!mounted) return;
    Navigation.back(context: context);
    handleLoginResult();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(toolbarHeight: 0),
        body: Column(
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
                      'Hello! 👋',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Please sign in to access your dashboard',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(height: 36),
                    PrimaryTextFormField(
                      labelText: 'Email',
                      hintText: AppStrings.emailHint,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
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
                      suffixWidget: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AppMaterial(
                          inkwellBorderRadius: BorderRadius.circular(24),
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textGrey.withOpacity(0.6),
                          ),
                        ),
                      ),
                      labelTrailing: GestureDetector(
                        onTap: () {
                          Navigation.navigateToScreen(
                            context: context,
                            screen: const ForgotPasswordPage(),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.end,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      onTap: handleLogin,
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: AuthBottomSection(isLogin: true),
            ),
          ],
        ),
      ),
    );
  }
}
