import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';

class DeleteActionButton extends StatelessWidget {
  const DeleteActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AppMaterial(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        inkwellBorderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            AppStrings.delete,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class CompleteActionButton extends StatelessWidget {
  const CompleteActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AppMaterial(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        inkwellBorderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            AppStrings.complete,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
