import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyInputBorder,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const FlutterLogo(size: 100),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.whatShouldWeCallYou,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                PrimaryTextFormField(
                  hintText: AppStrings.nameHintText,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              enabled: nameController.text.isNotEmpty,
              onTap: () {
                Navigation.navigateToHomePage(context: context);
              },
              child: const Text(AppStrings.continueText),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: AppTheme.fontFamily),
                text: 'Built with Flutter & 💙 by ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('tapped');
                    Utils.openWebLink(link: 'iniunamid.framer.website');
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
    );
  }
}
