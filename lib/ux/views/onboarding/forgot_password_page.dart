import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_logo_box.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

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
                onTap: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
