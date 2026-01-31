import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/components/user_profile_picture.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
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
              UserProfilePicture(size: 64),
              const SizedBox(width: 12),
              ValueListenableBuilder<AppUser?>(
                  valueListenable: AppDI.getIt<AuthViewModel>().currentUser,
                  builder: (context, user, _) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    );
                  }),
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
