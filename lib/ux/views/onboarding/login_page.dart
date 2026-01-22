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
import 'package:cgpa_calculator/ux/views/onboarding/forgot_password_page.dart';
import 'package:cgpa_calculator/ux/views/onboarding/sign_up_page.dart';
import 'package:flutter/gestures.dart';
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
                      hintText: 'student@university.edu',
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
                            'Sign in with Google',
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
                      text: 'New here? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textGrey,
                            fontSize: 13.5,
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Create an account',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigation.navigateToScreen(
                                context: context,
                                screen: const SignUpPage(),
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
    );
  }
}
