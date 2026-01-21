import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BackAndNextButtonRow extends StatelessWidget {
  const BackAndNextButtonRow({
    super.key,
    this.enableNextButton = true,
    required this.onTapNextButton,
    this.firstText,
    this.secondText,
    this.onTapFirstButton,
    this.firstIcon,
    this.secondIcon,
    this.buttonColor,
  });

  final bool enableNextButton;
  final VoidCallback onTapNextButton;
  final String? firstText;
  final String? secondText;
  final VoidCallback? onTapFirstButton;
  final Widget? firstIcon;
  final Widget? secondIcon;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PrimaryOutlinedButton(
              onTap: onTapFirstButton ??
                  () {
                    Navigator.pop(context);
                  },
              backgroundColor: AppColors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: firstIcon != null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: firstIcon,
                    ),
                  ),
                  Text(
                    firstText ?? 'Back',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              backgroundColor: buttonColor ?? AppColors.primaryColor,
              enabled: enableNextButton,
              onTap: onTapNextButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: secondIcon != null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: secondIcon,
                    ),
                  ),
                  Text(
                    secondText ?? 'Next',
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
