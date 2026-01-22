import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DevCredits extends StatelessWidget {
  const DevCredits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 13,
            color: AppColors.textGrey,
          ),
          text: 'Built with Flutter & 🤍 by ',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Utils.openWebLink(link: 'https://iniunamid.framer.website');
            },
          children: const [
            TextSpan(
              text: 'ID',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
