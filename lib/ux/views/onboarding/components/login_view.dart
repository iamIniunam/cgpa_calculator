import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.controller, this.isEdit = false});

  final TextEditingController controller;
  final bool isEdit;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image(
              image: AppImages.appLogo3,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hello! 👋',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'Enter your name to personalize your experience',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 36),
          PrimaryTextFormField(
            autofocus: widget.isEdit,
            labelText: 'Name',
            hintText: AppStrings.nameHintText,
            controller: widget.controller,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
