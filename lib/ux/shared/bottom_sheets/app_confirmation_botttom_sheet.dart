import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/back_and_next_button_row.dart';
import 'package:flutter/material.dart';

class AppConfirmationBotttomSheet extends StatelessWidget {
  const AppConfirmationBotttomSheet({
    super.key,
    required this.text,
    this.title,
    this.secondButtonText,
    this.secondButtonColor,
  });

  final String text;
  final String? title;
  final String? secondButtonText;
  final Color? secondButtonColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                text,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        BackAndNextButtonRow(
          onTapFirstButton: () {
            Navigation.back(
              context: context,
              result: false,
            );
          },
          onTapNextButton: () {
            Navigation.back(
              context: context,
              result: true,
            );
          },
          firstText: 'Cancel',
          secondText: secondButtonText ?? 'Yes',
          buttonColor: secondButtonColor,
        ),
      ],
    );
  }
}
