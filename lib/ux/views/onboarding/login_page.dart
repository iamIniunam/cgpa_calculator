import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/views/onboarding/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.cardBackground
                              : AppColors.field2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image(image: AppImages.appLogo3),
                      ),
                    ),
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
                      obscureText: true,
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
                      labelTrailing: GestureDetector(
                        onTap: () {
                          // Handle forgot password tap
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
                      onTap: () {
                        Navigation.navigateToHomePage(context: context);
                      },
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
                        BorderRadius.circular(AppDimens.dafaultBorderRadius),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimens.dafaultBorderRadius),
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
