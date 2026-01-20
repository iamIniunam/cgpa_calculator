import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppMaterial(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.transparentBackgroundDark
            : AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        inkwellBorderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigation.navigateToScreen(
          //     context: context, screen: const EditProfilePage());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image: AppImages.appLogo,
                  height: 58,
                  width: 58,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'student@university.edu',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).appBarTheme.foregroundColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
