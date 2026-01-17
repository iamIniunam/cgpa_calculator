import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();

  void handleLogin() async {
    FocusScope.of(context).unfocus();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (nameController.text.isEmpty) {
      AppDialogs.showErrorDialog(context,
          errorMessage: 'Please enter your name to continue.');
      return;
    }

    AppDialogs.showLoadingDialog(context);
    await authViewModel.login(nameController.text.trim());
    if (!mounted) return;
    Navigation.back(context: context);
    if (authViewModel.loginResult.value.isSuccess) {
      Navigation.navigateToHomePage(context: context);
    } else if (authViewModel.loginResult.value.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage:
            authViewModel.loginResult.value.message ?? 'Login failed.',
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.greyInputBorder,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Image(
                        image: AppImages.appLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Hello! 👋',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.whatShouldWeCallYou,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: PrimaryTextFormField(
                        hintText: AppStrings.nameHintText,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PrimaryButton(
                enabled: nameController.text.isNotEmpty,
                onTap: handleLogin,
                child: const Text(AppStrings.continueText),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontFamily: AppTheme.fontFamily, fontSize: 13),
                  text: 'Built with Flutter & 💙 by ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Utils.openWebLink(
                          link: 'https://iniunamid.framer.website');
                    },
                  children: [
                    TextSpan(
                      text: 'ID',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
