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
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  final SemesterViewModel _semesterViewModel = AppDI.getIt<SemesterViewModel>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  void handleLoginResult() async {
    final result = _authViewModel.loginResult.value;
    if (result.isSuccess) {
      await _semesterViewModel.loadSemesters();
      if (!mounted) return;
      Navigation.back(context: context);
      Navigation.navigateToHomePage(context: context);
    } else if (result.isError) {
      Navigation.back(context: context);
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? '',
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
        errorMessage: AppStrings.pleaseFillInAllTheFieldsToContinue,
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
                      AppStrings.helloWithEmoji,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.pleaseSignInToAccessYourDashboard,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(height: 36),
                    PrimaryTextFormField(
                      labelText: AppStrings.emailAddress,
                      hintText: AppStrings.emailAddressHintText,
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
                      labelText: AppStrings.password,
                      hintText: AppStrings.passwordHintText,
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
                          AppStrings.forgotPassword,
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
                      child: const Text(AppStrings.signIn),
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
