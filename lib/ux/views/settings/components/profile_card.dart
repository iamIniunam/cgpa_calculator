import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/views/settings/profile_page.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppMaterial(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.transparentBackgroundDark
            : AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        inkwellBorderRadius: BorderRadius.circular(32),
        onTap: () {
          Navigation.navigateToScreen(
            context: context,
            screen: const ProfilePage(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image(
                  image: AppImages.sampleProfileImage,
                  height: 64,
                  width: 64,
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
